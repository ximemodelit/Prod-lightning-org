/*
 *Batch class that takes an object from a package
 *and copies its data to an xlr8 security object.
 *@author Ximena Lasserre
 *@since Jul 2015
 */
public with sharing class DataMoverSecuritiesDataMappingBatch implements Database.Batchable<SObject>, Database.Stateful{
    
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
    private Id jobLogId;
    private String sourcePackage;
    
    /* 
     * Constructor
     * @param String - query: The string to be queried
     * @param String - srcExternalIdField: The field in the source object used as the source external Id
     * @param String - trgtExternalIdField: The field in the target object used as the target external Id
     * @param String - sourceObjAPI: The API field name of the source object
     * @param String - targetObjAPI: The API field name of the target object
     * @param String - mapObjId
     * @param Boolean - srcExtIdIsNameField
     * @param Boolean - trgExtIdIsNameField
     * @param String - scheduledJobName
     * @param Id - jobLogId
     * @param String - srcPackage
     */
    public DataMoverSecuritiesDataMappingBatch(String query, String srcExternalIdField, String trgtExternalIdField, String sourceObjAPI,
        String targetObjAPI, String mapObjId, Boolean srcExtIdIsNameField, Boolean trgExtIdIsNameField, String scheduledJobName, Id jobLogId, String srcPackage){ 
        
        if(query != null && srcExternalIdField != null && trgtExternalIdField != null && sourceObjAPI != null &&
        targetObjAPI != null && srcExtIdIsNameField != null && trgExtIdIsNameField != null && scheduledJobName != null
        && srcPackage != null){ 

            this.query = query;
            this.sourceExternalIdField = srcExternalIdField;
            this.targetExternalIdField = trgtExternalIdField;
            this.targetObjectAPIName = targetObjAPI;
            this.sourceObjectAPIName = sourceObjAPI;
            this.srcExtIdIsNameField = srcExtIdIsNameField;
            this.trgExtIdIsNameField = trgExtIdIsNameField; 
            this.sourceToTargetAPIs = new Map<String, String>();
            this.mappingObject = new Mapping_Object__c();
            this.sourceFieldToFieldMapObj = new Map<String, Field_Mapping__c>();
            this.getMappingObjectAndfieldMappings(mapObjId);
            this.jobWrapper = new JobLogWrapper(); 
            this.jobName = scheduledJobName;
            this.jobLogId = jobLogId;
            this.sourcePackage = srcPackage;
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
        system.debug('### ' + scope.size()); 
        //system.assert(true == false); 
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
        
        List<DataMoverDataMappingWrapper> srcObjectsToUpdate = new List<DataMoverDataMappingWrapper>();
        
        //iterate over each object brought by the query
        for(sObject sObj : scope){
            SObject newTrgtObj = targObjType.newSObject();
            
            //iterate over sourceToTargetAPIs to see if they match the fields in SObject
            for(String apiSource : sourceToTargetAPIs.keySet()){      
                //if field is a lookup to the target object it should not be copied to target
                if(!fieldIsLookupToTarget(apiSource)){  
                    
                    //if source field is Datetime and target Date, cast them
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
                            if(chckPickObject.get('Source_Value__c') == String.valueOf(sObj.get(apiSource))){
                                newTrgtObj.put(sourceToTargetAPIs.get(apiSource), chckPickObject.get('Target_Value__c'));
                            }
                        }
                    }
                    
                    //if source field type is string or textArea, check that the target is not shorter in length, if it is cut
                    else if((DataMoverDataMappingBatchUtils.getDescribeFieldResult(sourceObjectFieldsMap.get(apiSource)).getType().name().equalsIgnoreCase(Schema.DisplayType.String.name().toUppercase()) ||
                    DataMoverDataMappingBatchUtils.getDescribeFieldResult(sourceObjectFieldsMap.get(apiSource)).getType().name().equalsIgnoreCase(Schema.DisplayType.TextArea.name().toUppercase()) ||
                    DataMoverDataMappingBatchUtils.getDescribeFieldResult(sourceObjectFieldsMap.get(apiSource)).getType().name().equalsIgnoreCase(Schema.DisplayType.Integer.name().toUppercase()) ||
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
            //add package of origin to object
            populatePackageOfOriginField(newTrgtObj);
            
            //add object 
            records.add(newTrgtObj);          
        }   
        
        //if there are any objects in newRecords list insert them
        if(records.size() > 0){
            system.debug('>> ' + records.size());
            List<SObject> updatedSources = new List<SObject>();
            Database.SaveResult[] insertResults = Database.insert(records, false);
            for(Integer i = 0; i < records.size(); i++){
                jobWrapper.nrOfRecords++;
                Database.SaveResult result = insertResults[i];
                if(!result.isSuccess()){
                    system.debug('Errors: ' + result.getErrors()); 
                    //if targetExternalIdField is not N/A insert error log
                    if(targetExternalIdField != DataMoverConstants.NOT_APPLICABLE_STRING){
                        String valueOfExtId = String.valueOf(records[i].get(targetExternalIdField));
                        for(Database.Error err : result.getErrors()){                       
                            jobWrapper.errorLogs.add(new ErrorLogWrapper(err.getMessage(), err.getStatusCode().name(),
                                thesourceObj.getDescribe().getName(), targObjType.getDescribe().getName(), valueOfExtId));
                        }
                    }else{
                        for(Database.Error err : result.getErrors()){                       
                            jobWrapper.errorLogs.add(new ErrorLogWrapper(err.getMessage(), err.getStatusCode().name(),
                                thesourceObj.getDescribe().getName(), targObjType.getDescribe().getName(), ''));
                        }
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
    }
    
    /*
     * It checks if there were securities if this batch was for Assets & Liabilities, 
     * deletes them and inserts them again calling another batch
     * The insertJobAndErrorLog is called in order to insert the batch's database results 
     */
    public void finish(Database.BatchableContext BC){       
        if(jobWrapper != null){
            DataMoverDataMappingBatchUtils.insertJobAndErrorLog(jobWrapper, jobName, jobLogId, true); 
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
     * Populates field Package_of_Origin__c with
     * the current package 
     * @param SObject objToAddField: the object to which we are going to add the value
     */
    public void populatePackageOfOriginField(SObject objToAddField){
        if(objToAddField != null){
            objToAddField.put('Package_of_Origin__c', this.sourcePackage); 
        }
    }
       
}