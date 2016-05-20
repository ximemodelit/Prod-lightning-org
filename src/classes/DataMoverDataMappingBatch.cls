/*
 * It is a batch class that takes each object from a particular type 
 * and copies its data to another object. 
 * 
 * @author Ximena Lasserre
 * @since 12-2014
 */
public class DataMoverDataMappingBatch implements Database.Batchable<SObject>, Database.Stateful{
      
    //class variables
    public static Map<String, Schema.SObjectType> globalDescribe = Schema.getGlobalDescribe();
        
    public String query;
    public String sourceExternalIdField; 
    public String targetExternalIdField;
    public String targetObjectAPIName; 
    public String sourceObjectAPIName;
    public Boolean srcExtIdIsNameField;
    public Boolean trgExtIdIsNameField;
    public Map<String, String> sourceToTargetAPIs;
    public sObject mappingObject;
    public List<Field_Mapping__c> fieldsList;
    public List<SObject> updatedRecords = new List<SObject>();
    public List<SObject> newRecords = new List<SObject>();
    public List<CheckBox_Picklist_Correlation__c> chkboxAndPckLstList;
    public Map<String, Field_Mapping__c> sourceFieldToFieldMapObj;
    public JobLogWrapper jobWrapper;
    private String jobName;
    private String sourcePackage;
    public Mapping_Object__c currentMappingObject;
    public List<Id> mappingObjectsIds;
    public Id jobLogId;
    
    /* 
     * Constructor
     * @param List<Id> mappingObjectsIds
     * @param String scheduledJobName
     */
    public DataMoverDataMappingBatch(List<Id> mappingObjectsIds, String scheduledJobName, Id jobLogId){
        
        Mapping_Object__c mapObj = DataMoverDataMappingBatchUtils.retrieveMappingObjectToRunBatch(mappingObjectsIds);
        if(mapObj != null){
        
            this.sourceExternalIdField = mapObj.Source_External_ID_API_Name__c;
            this.targetExternalIdField = mapObj.Target_External_ID_API_Name__c;
            this.targetObjectAPIName = mapObj.Target_Object_API_Name__c;
            this.sourceObjectAPIName = mapObj.Source_Object_API_Name__c;
            this.srcExtIdIsNameField = mapObj.Source_External_ID_is_Name_Field__c;
            this.trgExtIdIsNameField = mapObj.Target_External_ID_is_Name_Field__c; 
            this.sourceToTargetAPIs = new Map<String, String>();
            this.mappingObject = new Mapping_Object__c();
            this.sourceFieldToFieldMapObj = new Map<String, Field_Mapping__c>();
            this.getMappingObjectAndfieldMappings(mapObj.Id);
            this.jobWrapper = new JobLogWrapper(); 
            this.jobName = scheduledJobName;
            this.sourcePackage = mapObj.Package_Name__c;
            this.currentMappingObject = mapObj;
            this.mappingObjectsIds = mappingObjectsIds;
            this.jobLogId = jobLogId;
            system.debug('####### ' + jobLogId);
            
            List<Field_Mapping__c> fieldMappingForMapObj = mapObj.FieldsMapping__r;
                                                               
            Integer times = 0;
            this.query = '';
            //iterate over fieldMappingForMapObj to create the query 
            this.query += 'SELECT ';
            for(Field_Mapping__c field : fieldMappingForMapObj){
                if(times < fieldMappingForMapObj.size() - 1){ 
                    this.query += field.Source_Field_API_Name__c + ', ';
                    times += 1;
                }
                else{ 
                    this.query += field.Source_Field_API_Name__c;
                }               
            }           
            this.query += ' FROM ' + mapObj.Source_Object_API_Name__c;
        }   
    }
    
    /*
     * Performs the query with the string that was passed to the constructor
     * and returns its result
     * @param BC - Database.BatchableContext
     * @return Database.QueryLocator 
     */
    public Database.QueryLocator start(Database.BatchableContext BC){  
        return Database.getQueryLocator(query);
        
    }

    /*
     * Uses the result from the query to map the values from the source objects to the target objects
     * @param BC - Database.BatchableContext
     * @param scope - List<sObject>: The result from the query performed in start method
     */
    public void execute(Database.BatchableContext BC, List<sObject> scope){
        
        //get the source object field map
        Schema.SObjectType thesourceObj = globalDescribe.get(sourceObjectAPIName);
        Map<String, Schema.SObjectField> sourceObjectFieldsMap = thesourceObj.getDescribe().fields.getMap();
        
        //get the target object type
        Schema.SObjectType targObjType = Schema.getGlobalDescribe().get(targetObjectAPIName);
        SObject trgtObj = targObjType.newSObject();
        //get the target object field map
        Map<String,Schema.SObjectField> targetObjectFieldsMap = targObjType.getDescribe().fields.getMap();
        
        //list of records to add the copied sobjects
        List<SObject> records = new List<SObject>();
        //list of updated records
        updatedRecords = new List<SObject>();
        //list of new records
        newRecords = new List<SObject>();
        
        List<DataMoverDataMappingWrapper> srcObjectsToUpdate = new List<DataMoverDataMappingWrapper>();
        
        //iterate over each object brought by the query
        for(sObject sObj : scope){
            SObject newTrgtObj = targObjType.newSObject();
            
            //iterate over sourceToTargetAPIs to see if they match the fields in SObject
            for(String apiSource : sourceToTargetAPIs.keySet()){      
                system.debug('>>>  ' + apiSource); 
                //if field is a lookup to the target object it should not be copied to target
                if(!fieldIsLookupToTarget(apiSource)){  
                     
                    //if source field is Datetime and target Date, cast them
                    system.debug('>>> source type ' + DataMoverDataMappingBatchUtils.getDescribeFieldResult(sourceObjectFieldsMap.get(apiSource)).getType().name());
                    system.debug('>>> target type ' + DataMoverDataMappingBatchUtils.getDescribeFieldResult(targetObjectFieldsMap.get(sourceToTargetAPIs.get(apiSource))).getType().name());
                    if(DataMoverDataMappingBatchUtils.getDescribeFieldResult(sourceObjectFieldsMap.get(apiSource)).getType().name().equalsIgnoreCase(Schema.DisplayType.DateTime.name().toUppercase()) &&
                    DataMoverDataMappingBatchUtils.getDescribeFieldResult(targetObjectFieldsMap.get(sourceToTargetAPIs.get(apiSource))).getType().name().equalsIgnoreCase(Schema.DisplayType.Date.name().toUppercase())){
                        //cast the datetime value to date and assign it to the field   
                        Date dateValue = DataMoverDataMappingBatchUtils.castDateTimeValueToDate((Datetime)sObj.get(apiSource));                         
                        newTrgtObj.put(sourceToTargetAPIs.get(apiSource), dateValue);  
                    }
                    
                    //if any of the fields is checkbox or picklist find their corresponding CheckBox_Picklist_Correlation__c obj
                    else if(sourceFieldToFieldMapObj != null && 
                    DataMoverDataMappingBatchUtils.checkIfAnyFieldIsCheckboxOrPicklist(sourceFieldToFieldMapObj.get(apiSource).Source_Field_Type__c, 
                    sourceFieldToFieldMapObj.get(apiSource).Target_Field_Type__c)){ 
                        
                        //get the CheckBox_Picklist_Correlation__c for that field_Mapping__c object
                        List<CheckBox_Picklist_Correlation__c> chckPickList = sourceFieldToFieldMapObj.get(apiSource).CheckBox_Picklist_Correlations__r;
                        for(CheckBox_Picklist_Correlation__c chckPickObject : chckPickList){
                            //check that the source value is not N/A, empty or null and that its the same as the value from the object
                            if(chckPickObject.get('Source_Value__c') != DataMoverConstants.NOT_APPLICABLE_STRING && chckPickObject.get('Source_Value__c') != ''
                            && chckPickObject.get('Source_Value__c') != null && chckPickObject.get('Source_Value__c') == String.valueOf(sObj.get(apiSource))){
                                newTrgtObj.put(sourceToTargetAPIs.get(apiSource), chckPickObject.get('Target_Value__c'));
                            }
                        }
                    }
                    
                    //if source field type is string or textArea, check that the target is not shorter in length, if it is cut
                    else if((DataMoverDataMappingBatchUtils.getDescribeFieldResult(sourceObjectFieldsMap.get(apiSource)).getType().name().equalsIgnoreCase(Schema.DisplayType.String.name().toUppercase()) ||
                    DataMoverDataMappingBatchUtils.getDescribeFieldResult(sourceObjectFieldsMap.get(apiSource)).getType().name().equalsIgnoreCase(Schema.DisplayType.TextArea.name().toUppercase()) ||
                    DataMoverDataMappingBatchUtils.getDescribeFieldResult(sourceObjectFieldsMap.get(apiSource)).getType().name().equalsIgnoreCase(Schema.DisplayType.Integer.name().toUppercase()) ||
                    DataMoverDataMappingBatchUtils.getDescribeFieldResult(sourceObjectFieldsMap.get(apiSource)).getType().name().equalsIgnoreCase(Schema.DisplayType.Double.name().toUppercase()) ||
                    DataMoverDataMappingBatchUtils.getDescribeFieldResult(sourceObjectFieldsMap.get(apiSource)).getType().name().equalsIgnoreCase(Schema.DisplayType.Email.name().toUppercase())) &&
                    sObj.get(apiSource) != null &&
                    String.valueOf(sObj.get(apiSource)).length() > DataMoverDataMappingBatchUtils.getDescribeFieldResult(targetObjectFieldsMap.get(sourceToTargetAPIs.get(apiSource))).getLength()){
                        //get the length of the target field
                        Integer lengthTrgtField = DataMoverDataMappingBatchUtils.getDescribeFieldResult(targetObjectFieldsMap.get(sourceToTargetAPIs.get(apiSource))).getLength();
                    
                        String newTxt = DataMoverDataMappingBatchUtils.reduceStringLength(String.valueOf(sObj.get(apiSource)),
                                lengthTrgtField);                           
                        newTrgtObj.put(sourceToTargetAPIs.get(apiSource), newTxt);
                    }                    
                    else{
                        newTrgtObj.put(sourceToTargetAPIs.get(apiSource), sObj.get(apiSource));
                    }                   
                }else{ 
                    //if field is lookup create an instance of DataMoverDataMappingWrapper
                    DataMoverDataMappingWrapper dmdmw = new DataMoverDataMappingWrapper(sObj, newTrgtObj);                  
                    srcObjectsToUpdate.add(dmdmw); //add the object to srcObjectsToUpdate to update the source object
                }       
            }
            records.add(newTrgtObj);          
        }   
        //check if the objects in records list exist or not
        this.doObjectsExist(records); 
           
        //if there are any objects in updatedRecords list update them
        if(updatedRecords.size() > 0){
            Database.saveResult[] updateResults = Database.update(updatedRecords, false);  
            for(Integer i = 0; i < updatedRecords.size(); i++){
                jobWrapper.nrOfRecords++;
                Database.SaveResult result = updateResults[i];
                if(!result.isSuccess()){
                    String valueOfExtId = String.valueOf(updatedRecords[i].get(targetExternalIdField));
                    for(Database.Error err : result.getErrors()){                       
                        jobWrapper.errorLogs.add(new ErrorLogWrapper(err.getMessage(), err.getStatusCode().name(),
                            thesourceObj.getDescribe().getName(), targObjType.getDescribe().getName(), valueOfExtId));
                    }
                }
            }
        }
        
        
        //if there are any objects in newRecords list insert them
        if(newRecords.size() > 0){
            List<SObject> updatedSources = new List<SObject>();
            
            Database.SaveResult[] insertResults = Database.insert(newRecords, false);
            for(Integer i = 0; i < newRecords.size(); i++){
                jobWrapper.nrOfRecords++;
                Database.SaveResult result = insertResults[i];
                if(!result.isSuccess()){
                    String valueOfExtId = String.valueOf(newRecords[i].get(targetExternalIdField));
                    for(Database.Error err : result.getErrors()){                       
                        jobWrapper.errorLogs.add(new ErrorLogWrapper(err.getMessage(), err.getStatusCode().name(),
                            thesourceObj.getDescribe().getName(), targObjType.getDescribe().getName(), valueOfExtId));
                    } 
                }
            }
            //update the source object 
            for(DataMoverDataMappingWrapper wrapObject : srcObjectsToUpdate){
                wrapObject.updateSourceLookupWithTargetId();
                updatedSources.add(wrapObject.sourceObject);
            }
            Database.SaveResult[] updateSourcesResults = Database.update(updatedSources, false);
            for(Integer i = 0; i < updatedSources.size(); i++){
                jobWrapper.nrOfRecords++;
                Database.SaveResult result = updateSourcesResults[i];
                if(!result.isSuccess()){
                    String valueOfExtId = String.valueOf(updatedSources[i].get(targetExternalIdField));
                    for(Database.Error err : result.getErrors()){                       
                        jobWrapper.errorLogs.add(new ErrorLogWrapper(err.getMessage(), err.getStatusCode().name(),
                            thesourceObj.getDescribe().getName(), targObjType.getDescribe().getName(), valueOfExtId));
                    }
                }
            }
        }  
        system.debug('###### ' + jobWrapper); 
        
    }
    
    /*
     * It checks if there were securities if this batch was for Assets & Liabilities, 
     * deletes them and inserts them again calling another batch
     * The insertJobAndErrorLog is called in order to insert the batch's database results 
     */
    public void finish(Database.BatchableContext BC){
        
        //update mapping object so that synced = true
        DataMoverDataMappingBatchUtils.changeSyncedToTrueForMappingObject(currentMappingObject);
                    
        //check if there are more objects to run with another batch
        Mapping_Object__c newObjectForBatch = DataMoverDataMappingBatchUtils.retrieveMappingObjectToRunBatch(mappingObjectsIds);
        if(newObjectForBatch != null){
            //insert job and error logs only for this execution     
            if(jobWrapper != null){
                system.debug('#### first insert');
                jobLogId = DataMoverDataMappingBatchUtils.insertJobAndErrorLog(jobWrapper, jobName, jobLogId, false);
            }
            //if there are more mapping objs, execute new batch
            DataMoverDataMappingBatch newBatch = new DataMoverDataMappingBatch(mappingObjectsIds, jobName, jobLogId);
            Database.executeBatch(newBatch, 200);
        }else{ 
            //if no more mapping objects, update mapping object synced field to true
            DataMoverDataMappingBatchUtils.changeSyncedToFalseForAll(mappingObjectsIds);
            //check if there is a mapping object for securities and at least one A&L object for this package
            Mapping_Object__c securitiesObject = DataMoverDataMappingBatchUtils.checkIfSecuritiesExistForPackage(mappingObjectsIds, sourcePackage);
            if(securitiesObject != null){
                //insert job log and error logs for this execution
                jobLogId = DataMoverDataMappingBatchUtils.insertJobAndErrorLog(jobWrapper, jobName, jobLogId, false);
                //delete securities
                DataMoverDeleteSecuritiesBatch deleteBatch = new DataMoverDeleteSecuritiesBatch(securitiesObject, jobName, jobLogId);   
                Database.executeBatch(deleteBatch, 200);                
            }else{ 
                //if no securities, insert job and error logs for the last time
                if(jobWrapper != null){
                    system.debug('#### ' + jobWrapper+'-'+jobName+'-'+ jobLogId);
                    system.debug('#### last insert');
                    DataMoverDataMappingBatchUtils.insertJobAndErrorLog(jobWrapper, jobName, jobLogId, true);
                }
            }   
        }
    }
    
    /**
     * It queries the mapping_Object__c and all its related fields_List__c using
     * the parameters. It also fills the fieldsLis listswith the correlating source and target
     * fields and it queries all the CheckBox_Picklist_Correlation__c if there are any related
     * @param String - mapObjId: the Id of the mapping object
     */
    public void getMappingObjectAndFieldMappings(String mapObjId){
        
        //find the Mapping_Object__c that corresponds to both source and target
        mappingObject = [SELECT Id, X18_Character_Job_Id__c, Package_Name__c, Scheduled_Job_Id__c, Source_External_ID_Field__c,
                                Source_External_ID_Field_Type__c, Source_External_ID_is_Name_Field__c, Source_Object_API_Name__c,
                                Source_Object_Label__c, SourceTargetLabel__c, Target_External_ID_Field__c, Target_External_ID_Field_Type__c,
                                Target_External_ID_is_Name_Field__c, Target_Object_API_Name__c, Target_Object_Label__c 
                           FROM Mapping_Object__c 
                          WHERE Id = :mapObjId];
        
        //query all the Field_Mapping__c objects related to the mapping object with its CheckBox_Picklist_Correlations__r objs                                 
        fieldsList = [SELECT Source_Field_API_Name__c, Source_Field_Label__c, Source_Field_Required__c, Source_Field_Type__c,
                             Source_Is_Name_Field__c, Target_Field_API_Name__c, Object_Mapping__c, Target_Field_Label__c, Target_Field_Type__c,
                             Target_Field_Required__c, Target_Is_Name_Field__c, 
                             (SELECT Source_Value__c, Target_Value__c, Field_Mapping__c, Name, Source_Field_API_Name__c,
                                     Target_Field_API_Name__c   
                              FROM CheckBox_Picklist_Correlations__r)
                        FROM Field_Mapping__c
                       WHERE Object_Mapping__c = :mapObjId
                         AND (NOT Source_Field_Type__c LIKE 'Roll-Up Summary%')];

        
        //fill sourceToTargetAPIs with Source_Field_API_Name__c and its corresponding Target_Field_API_Name__c                                     
        for(Field_Mapping__c field : fieldsList){
            sourceToTargetAPIs.put(field.Source_Field_API_Name__c.toLowerCase(), field.Target_Field_API_Name__c.toLowerCase());
        } 
        //fill sourceFieldToFieldMapObj with Source_Field_API_Name__c and the Field_Mapping__c obj
        for(Field_Mapping__c field : fieldsList){
            sourceFieldToFieldMapObj.put(field.Source_Field_API_Name__c.toLowerCase(), field);
        }
         
    }
    
    /*
     * It checks if the current field is a lookup field to the target field, if so it 
     * returns true, else false
     * @param String - sourceFieldApi: The current field Api name
     * @return boolean
     */
    public boolean fieldIsLookupToTarget(String sourceFieldApi){
        //get the sobject
        Schema.SObjectType theObj = globalDescribe.get(sourceObjectAPIName);
        //get the sobject field
        Map<String, Schema.SObjectField> fieldResultsMap = theObj.getDescribe().fields.getMap();
        Schema.SObjectField theField = fieldResultsMap.get(sourceFieldApi);
        //get the describe field result
        Schema.DescribeFieldResult dfr = DataMoverDataMappingBatchUtils.getDescribeFieldResult(theField);
        //if it is a reference and it points to the target obj return true, else false
        if(dfr.getType() == Schema.DisplayType.Reference && String.ValueOf(dfr.getReferenceTo()) == '(' + targetObjectAPIName + ')'){
            return true;
        }else{
            return false;
        }
    }
    
    /*
     * It takes a list of objects and checks if they already exist or not.
     * For each object that exists it adds it to updatedRecords list, 
     * else it adds it to newRecords list. 
     * @param List<SObject> newObjs: List of SObjects to check if exist
     */
    public void doObjectsExist(List<SObject> newObjs){
        
        //create a list of strings to add the value of the targets external fields
        List<String> listString = new List<String>();
        if(newObjs.size() > 0){ 
            for(SObject newObj : newObjs){
                if(newObj.get(targetExternalIdField) != null){
                    listString.add(String.valueOf(newObj.get(targetExternalIdField)));
                }
            }
        }
        //create a query string that brings all objects in listString list that exist
        String q = '';
        
        List<SObject> queriedObj = new List<SObject>();
        if(listString.size() > 0){
            q = 'SELECT Id, ' + targetExternalIdField +
                ' FROM ' + targetObjectAPIName +
                ' WHERE ' + targetExternalIdField + ' IN :listString';
        
           
            for(List<SObject> sobj : Database.query(q)){
                for(SObject eachObj : sobj){
                    queriedObj.add(eachObj);
                }           
            }
        }
        
        //iterate over the objects of the passed parameter 
        for(SObject paramObj : newObjs){
            boolean oldRecord = false;
            //iterate over the objects obtained by the query
            for(Sobject queryObj : queriedObj){
                if(queryObj.get(targetExternalIdField) == paramObj.get(targetExternalIdField) && queryObj.get(targetExternalIdField) != null){
                    //if they have the same ext id, the id is assigned to the n object and oldRecord is set to true
                    paramObj.put('Id', queryObj.get('Id'));
                    //it is added to updatedRecords      
                    updatedRecords.add(paramObj);
                    oldRecord = true;
                }           
            }
            if(!oldRecord){ 
                //it is added to newRecords  
                newRecords.add(paramObj); 
            }                     
        }   
    }    
}