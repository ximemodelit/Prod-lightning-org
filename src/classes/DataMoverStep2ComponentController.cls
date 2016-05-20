/*
 * Controller for Step 2 component (DataMover)
 *
 * @author - Ximena Lasserre
 * @since - Jan 2015
 */
public with sharing class DataMoverStep2ComponentController extends DataMoverComponentControllerBase{
    
    public String[] TO_BE_MAPPED_XLR8_OBJECTS {get;set;}
    public boolean securitiesChecked {get;set;}
    public DataMoverObjectInfoWrapper securitiesObject {get;set;}
    
    /*
     * Constructor
     */
    public DataMoverStep2ComponentController(){ 
        
    } 
    
    
    public DataMoverPageController pageController{
        get;
        set {
            if (value != null && value.initStep2Component){
                securitiesChecked = false;
                pageController = value; 
                TO_BE_MAPPED_XLR8_OBJECTS = getCustomSettingsOfObjectsToBeMapped();
                pageController.onlyXlr8Objects = retrieveXlr8Objs();
                pageController.onlySourceObjects = retrieveSrcObjects();                
                createMappingWrappersOnlySources();
                securitiesObject = new DataMoverObjectInfoWrapper();
                fillSecuritiesObjectWithApiAndLabels();
                pageController.initStep2Component = false;
            }
        }
    }
    
    /*
     * Gets the custom settings of the xlr8 objects that should be used in Data Mover
     * and returns them in a list of strings
     * @return String[]: list of the api names of the objects that should be used
     */
    public String[] getCustomSettingsOfObjectsToBeMapped(){
        String[] listOfObjects = new List<String>();
        //get all the objects
        Map<String, Data_Mover_XLR8_Objects__c> customSettings = Data_Mover_XLR8_Objects__c.getAll();
        if(customSettings != null && customSettings.size() > 0){
            for(Data_Mover_XLR8_Objects__c cSet : customSettings.values()){
                //fill the list
                listOfObjects.add(cSet.API_Name__c);
            }           
        }
        return listOfObjects;
    }
    
    /*
     * Fills the securities object with target information 
     * (api name and label)
     */
    public void fillSecuritiesObjectWithApiAndLabels(){
        DataMoverOneObjectWrapper obj = pageController.onlyXlr8Objects.get('Security');
        securitiesObject.targetApiName = (pageController.onlyXlr8Objects.get('Security')).objApiName;
        securitiesObject.targetLabel = 'Security';
    }
    
    /*
     * It gets all the objects and fields that 
     * belong to xlr8, returns their labels in a string
     * and add the objects to a map 
     * @return Map<String, DataMoverOneObjectWrapper> - Map of xlr8 objects
     */
    public Map<String, DataMoverOneObjectWrapper> retrieveXlr8Objs(){ 
        //create a set with the object names that should not appear
        Set<String> xlr8ObjectsToUse = new Set<String>(TO_BE_MAPPED_XLR8_OBJECTS);

        //initialize the map onlyXlr8Objects
        pageController.onlyXlr8Objects = new Map<String, DataMoverOneObjectWrapper>();
        
        //use the global describe to find the objects belonging to xlr8
        Map<String, DataMoverOneObjectWrapper> xlr8Objs = new Map<String, DataMoverOneObjectWrapper>();
        for(Schema.SObjectType sobjType : pageController.globalDescribe.values()){
                    
            DataMoverOneObjectWrapper xlr8ObjWrap = new DataMoverOneObjectWrapper();
            
            //if the object is within the set of objects that should appear, create it
            if(DataMoverComponentsUtils.setContainsString(xlr8ObjectsToUse, sobjType.getDescribe().getName())){
                if(sobjType.getDescribe().isCustom()){  //check that it is a custom object, and not standard
                    xlr8ObjWrap.objApiName = sobjType.getDescribe().getName().toLowerCase();
                    xlr8ObjWrap.objLabel = sobjType.getDescribe().getLabel();
                        
                    //fill the list of fields for each obj in xlr8 and add it to xlr8Fields
                    Map<String, Schema.SObjectField> xlr8FieldMap = sobjType.getDescribe().fields.getMap();
                    for(Schema.SObjectField field : xlr8FieldMap.values()){
                        //add the field only if it is createable
                        Schema.DescribeFieldResult describeFieldResult = DataMoverDataMappingBatchUtils.getDescribeFieldResult(field);
                        if(describeFieldResult.isCreateable()){
                            //add the field to objectFields, key = apiname
                            xlr8ObjWrap.objectFields.put(describeFieldResult.getName().toLowercase(), createDataMoverOneFieldWrapper(describeFieldResult, sobjType));
                        }       
                    } 
                    system.debug('>>> ' + xlr8Objs);
                    xlr8Objs.put(xlr8ObjWrap.objLabel, xlr8ObjWrap);
                }   
            }               
        }           
        return xlr8Objs;
    }
    
    /*
     * Creates DataMoverOneObjectWrapper objects and the fields that belong to the source objects
     * and returns them in a map. It also initializes the packageDescribe map, adds the objects
     * belonging to the package to it 
     * @return Map<String, DataMoverOneObjectWrapper>: a map of all the DataMoverOneObjectWrapper objects
     */
    public Map<String, DataMoverOneObjectWrapper> retrieveSrcObjects(){ 
        
        Map<String, DataMoverOneObjectWrapper> wrap = new Map<String, DataMoverOneObjectWrapper>();
        pageController.packageDescribe = new Map<String, Schema.SObjectType>();
        
        if (pageController != null){
            if(!Test.isRunningTest()){
                String selectedPackPref = pageController.packagesMap.get(pageController.selectedPackage); 
                for(Schema.SObjectType sobjType : pageController.globalDescribe.values()){
                    
                    if((sobjType.getDescribe().getName()).contains(selectedPackPref)){
                        //add it to the package describe map
                        pageController.packageDescribe.put(sobjType.getDescribe().getName().toLowercase(), sobjType);
                        //create the object wrapper
                        DataMoverOneObjectWrapper dmObjWrapp = new DataMoverOneObjectWrapper();
                        dmObjWrapp.objApiName = sobjType.getDescribe().getName().toLowercase();
                        dmObjWrapp.objLabel = sobjType.getDescribe().getLabel();
                        
                        //fill the list of fields for each obj in the selected package and add it to its list of fields
                        Map<String, Schema.SObjectField> selPackFieldMap = sobjType.getDescribe().fields.getMap();  
                        for(Schema.SObjectField field : selPackFieldMap.values()){
                            
                            Schema.DescribeFieldResult describeFieldResult = DataMoverDataMappingBatchUtils.getDescribeFieldResult(field);
                            //add the field to objectFields, key = apiname
                            dmObjWrapp.objectFields.put(describeFieldResult.getName().toLowercase(), createDataMoverOneFieldWrapper(describeFieldResult, sobjType));
                        }
                        //add the object to wrap list
                        wrap.put(dmObjWrapp.objLabel, dmObjWrapp);
                        
                    }
                }
            }else{ //this is for when a test is running and we cannot have it for granted that there will be a package
                for(Schema.SObjectType sobjType : pageController.globalDescribe.values()){ //iterate over the global describe
                    //add it to the package describe map
                    pageController.packageDescribe.put(sobjType.getDescribe().getName().toLowercase(), sobjType);
                    //create the object wrapper
                    DataMoverOneObjectWrapper dmObjWrapp = new DataMoverOneObjectWrapper();
                    dmObjWrapp.objApiName = sobjType.getDescribe().getName().toLowercase();
                    dmObjWrapp.objLabel = sobjType.getDescribe().getLabel();
                    
                    //fill the list of fields for each obj in the selected package and add it to its list of fields
                    Map<String, Schema.SObjectField> selPackFieldMap = sobjType.getDescribe().fields.getMap();  
                    for(Schema.SObjectField field : selPackFieldMap.values()){
                        
                        Schema.DescribeFieldResult describeFieldResult = DataMoverDataMappingBatchUtils.getDescribeFieldResult(field);
                        //add the field to objectFields, key = apiname
                        dmObjWrapp.objectFields.put(describeFieldResult.getName().toLowercase(), createDataMoverOneFieldWrapper(describeFieldResult, sobjType));
                    }
                    //add the object to wrap list
                    wrap.put(dmObjWrapp.objLabel, dmObjWrapp);
                }
            }
        }
        system.debug('>>>> ' + wrap);
        return wrap;
    }
    
    /*
     * Creates and returns a DataMoverOneFieldWrapper based on the passed Schema.DescribeFieldResult
     * @param Schema.DescribeFieldResult describeFieldResult: describe field result of the wrapper to be created
     * @param Schema.SObjectType sobjType: sObject type of the current object
     * @return DataMoverOneFieldWrapper: wrapper to be returned, based on the describe field result
     */
    public DataMoverOneFieldWrapper createDataMoverOneFieldWrapper(Schema.DescribeFieldResult describeFieldResult, Schema.SObjectType sobjType){
        
        //create the wrapper
        DataMoverOneFieldWrapper fieldWrap = new DataMoverOneFieldWrapper();
        
        //fill its fields
        fieldWrap.objectApiName = sobjType.getDescribe().getName().toLowercase();
        fieldWrap.fieldLabel = describeFieldResult.getLabel();
        fieldWrap.fieldApiName = describeFieldResult.getName().toLowercase();
        fieldWrap.fieldType = String.valueOf(describeFieldResult.getType());
        if(describeFieldResult.isNameField()){
            fieldWrap.isNameField = true;
        }
        if((!describeFieldResult.isNillable() && describeFieldResult.isCreateable() &&
        !describeFieldResult.isDefaultedOnCreate()) || (describeFieldResult.isNameField() && !describeFieldResult.isAutoNumber())){
            fieldWrap.isFieldRequired = true;
        }
        
        //check if the type is picklist and add the values
        if(fieldWrap.fieldType == 'PICKLIST'){
            List<Schema.PicklistEntry> listOfValues = describeFieldResult.getPickListValues();
            for(Schema.PicklistEntry pickEntry : listOfValues){
                if(pickEntry.isActive()){
                    DataMoverOneValueWrapper value = new DataMoverOneValueWrapper(pickEntry.getValue());
                    value.fieldApi = fieldWrap.fieldApiName;
                    fieldWrap.listOfValues.add(value);
                }
            }
        }   
        
        //check if the type is boolean and add the values
        if(fieldWrap.fieldType == 'BOOLEAN'){
            DataMoverOneValueWrapper firstValue = new DataMoverOneValueWrapper('True');
            firstValue.fieldApi = fieldWrap.fieldApiName;
            fieldWrap.listOfValues.add(firstValue);
            DataMoverOneValueWrapper secondValue = new DataMoverOneValueWrapper('False');
            secondValue.fieldApi = fieldWrap.fieldApiName;
            fieldWrap.listOfValues.add(secondValue);
        }
        system.debug('>>> ' + fieldWrap);
        return fieldWrap;
    }
    
     /*
      * Takes the user to the third step
      * if at least one object was selected 
      */
     public void goToStep3From2(){
        
        if(!checkIfAtLeastOneObjectSelected()){
            pageController.noObjectSelected = true;
        }else{
            pageController.noObjectSelected = false;
            removeNotSelectedObjectsOrFillApi();
            pageController.currentObject = pageController.srcTrgWrappers[0];
            pageController.goToStep3();
        }
     }  
     
     /*
      * Check if there was at least one object selection on step 2, if at least one 
      * object has its targetLabel populated
      * boolean: True if there is at least one targetLabel not 'N/A', false otherwise
      */
     public boolean checkIfAtLeastOneObjectSelected(){
        if(pageController.srcTrgWrappers.size() > 0){
            for(DataMoverObjectInfoWrapper objectWrapper : pageController.srcTrgWrappers){
                if(objectWrapper.targetLabel != DataMoverConstants.NOT_APPLICABLE_STRING){
                    return true;
                }
            }
        }
        return false;
     }
    
     /*
      * Creates the first instance of srcTrgWrappers
      * which only has the info about the sources
      */
     public void createMappingWrappersOnlySources(){
          pageController.srcTrgWrappers = new List<DataMoverObjectInfoWrapper>();
          for(DataMoverOneObjectWrapper wrapper : pageController.onlySourceObjects.values()){
              DataMoverObjectInfoWrapper objInfoWrap = new DataMoverObjectInfoWrapper(wrapper.objApiName.toLowercase(), wrapper.objLabel);
              pageController.srcTrgWrappers.add(objInfoWrap);
          }     
      }
      
     /*
     * Iterates over the list of object info wrappers 
     * and removes the objects whose target label 
     * is 'N/A', if not removed, their api
     * name is added
     */
     public void removeNotSelectedObjectsOrFillApi(){
        if(pageController.srcTrgWrappers != null && pageController.srcTrgWrappers.size() > 0){
            //iterate over srcTrgWrappers and get the labels to see if they already exist as an object
            List<DataMoverObjectInfoWrapper> objectsToSeeIfExist = new List<DataMoverObjectInfoWrapper>();
            for(DataMoverObjectInfoWrapper objWrap : pageController.srcTrgWrappers){
                if(objWrap.targetLabel != 'N/A'){
                    objectsToSeeIfExist.add(objWrap);
                }
            }
            //fill and add securities object to objectsToSeeIfExist
            if(securitiesObject.sourceLabel != null && securitiesObject.sourceLabel != DataMoverPageController.NOT_APPLICABLE_STRING){
                //add its api name
                securitiesObject.sourceApiName = pageController.onlySourceObjects.get(securitiesObject.sourceLabel).objApiName;
                //add it to objectsToSeeIfExist
                objectsToSeeIfExist.add(securitiesObject);
            }
            //if the list has items, check if its objects exist
            if(objectsToSeeIfExist.size() > 0){
                checkIfObjectsAlreadyExistAndFillThem(objectsToSeeIfExist);
                //iterate over objectsToSeeIfExist to see if they are already filled or not
                for(DataMoverObjectInfoWrapper objInfoWrap : objectsToSeeIfExist){
                    if(objInfoWrap.targetApiName == null){              
                        //if sourceApiName is null there is no existing object, so fill it with the available info
                        fillTrgApiNameInObjectWrapper(objInfoWrap); 
                    }
                }
                
            }
            //replace srcTrgWrappers with the objs of the new list
            pageController.srcTrgWrappers = null;
            pageController.srcTrgWrappers = objectsToSeeIfExist;                
        }   
    }
    
    /*
     * Checks if the selected pair of objects already exists, 
     * if so it fills them with the existing information
     * @objsToSeeIfExist - List<DataMoverObjectInfoWrapper>: list of objects to query
     */
     public void checkIfObjectsAlreadyExistAndFillThem(List<DataMoverObjectInfoWrapper> objsToSeeIfExist){
        List<String> srcTrgLabel = new List<String>();
        for(DataMoverObjectInfoWrapper objInfoWrap : objsToSeeIfExist){
            srcTrgLabel.add(objInfoWrap.sourceLabel + objInfoWrap.targetLabel);
        }
        //query the objects and bring the ones that exist
        List<Mapping_Object__c> existingObjects = [SELECT Id, Package_Name__c, Scheduled_Job_Id__c, Source_External_ID_Field__c,
                                                            Source_Object_API_Name__c, Source_Object_Label__c, SourceTargetLabel__c, 
                                                            Target_External_ID_Field__c, Target_Object_API_Name__c, Target_Object_Label__c,
                                                            Target_External_ID_Field_Type__c, Source_External_ID_Field_Type__c, X18_Character_Job_Id__c,
                                                            Source_External_ID_is_Name_Field__c, Target_External_ID_is_Name_Field__c, Target_External_ID_API_Name__c, 
                                                            Source_External_ID_API_Name__c, Data_Mover_Scheduled_Job__r.Id, Data_Mover_Scheduled_Job__r.Name,
                                                            Data_Mover_Scheduled_Job__r.Creator_Email__c, Data_Mover_Scheduled_Job__r.Cron_Expression__c,
                                                            Data_Mover_Scheduled_Job__r.End_Date__c, Data_Mover_Scheduled_Job__r.Job_Id__c, 
                                                            Data_Mover_Scheduled_Job__r.Start_Date__c, Data_Mover_Scheduled_Job__c,
                                                            (SELECT Id, Field_Mapping__c.Source_Field_API_Name__c, Field_Mapping__c.Source_Field_Label__c,
                                                                    Field_Mapping__c.Source_Field_Type__c, Field_Mapping__c.Target_Field_API_Name__c,
                                                                    Field_Mapping__c.Source_Field_Required__c, Field_Mapping__c.Target_Field_Required__c,
                                                                    Field_Mapping__c.Target_Field_Label__c, Field_Mapping__c.Target_Field_Type__c, 
                                                                    Field_Mapping__c.Source_Is_Name_Field__c, Field_Mapping__c.Target_Is_Name_Field__c                                                                                                                              
                                                             FROM Mapping_Object__c.FieldsMapping__r)
                                                   FROM Mapping_Object__c
                                                   WHERE SourceTargetLabel__c IN :srcTrgLabel];
                                                   
        //create a list to store the ids of the field mappings                                         
        List<Id> listOfFieldMapIds = new List<Id>();                                           
        for(Mapping_Object__c mapObjs : existingObjects){
            for(Field_Mapping__c fieldMap : mapObjs.FieldsMapping__r){
                listOfFieldMapIds.add(fieldMap.Id);
            }
        }
        List<CheckBox_Picklist_Correlation__c> chkBoxPckList;
        //here query the checkboxes
        if(listOfFieldMapIds.size() > 0){
            chkBoxPckList = [SELECT Id, Source_Field_API_Name__c, Source_Value__c,
                                    Target_Field_API_Name__c, Target_Value__c
                             FROM CheckBox_Picklist_Correlation__c
                             WHERE Field_Mapping__c IN :listOfFieldMapIds];     
        }                                                                      
        //if the query brought any object check that it matches the ones selected
        if(existingObjects != null && existingObjects.size() > 0){
            for(DataMoverObjectInfoWrapper objInfoWrap : objsToSeeIfExist){
                for(Mapping_Object__c objMap : existingObjects){
                    String srcTrgLbl = objInfoWrap.sourceLabel + objInfoWrap.targetLabel;
                    //if objInfoWrap is the same as the queried Mapping_Object__c 
                    if(srcTrgLbl.equalsIgnoreCase(objMap.SourceTargetLabel__c)){
                        //if there is a match fill the objectInfoWrapper with the existing info
                        objInfoWrap.sourceApiName = objMap.Source_Object_API_Name__c.toLowercase();
                        objInfoWrap.sourceExtIdField = objMap.Source_External_ID_Field__c + '-' + objMap.Source_External_ID_Field_Type__c + '-' + objMap.Source_External_ID_API_Name__c.toLowercase();
                        objInfoWrap.sourceExtIdFieldType = objMap.Source_External_ID_Field_Type__c;
                        objInfoWrap.sourceExtIdFieldAPI = objMap.Source_External_ID_API_Name__c.toLowercase();
                        objInfoWrap.targetApiName = objMap.Target_Object_API_Name__c.toLowercase();
                        objInfoWrap.mappingObjectCreated = objMap;
                        objInfoWrap.targetExtIdField = objMap.Target_External_ID_Field__c + '-' + objMap.Target_External_ID_Field_Type__c + '-' + objMap.Target_External_ID_API_Name__c.toLowercase();
                        objInfoWrap.targetExtIdFieldType = objMap.Target_External_ID_Field_Type__c;
                        objInfoWrap.targetExtIdFieldAPI = objMap.Target_External_ID_API_Name__c.toLowercase();
                        objInfoWrap.mapppingObjectId = objMap.Id;
                        objInfoWrap.sourceExtIdFieldIsNameField = objMap.Source_External_ID_is_Name_Field__c;
                        objInfoWrap.targetExtIdFieldIsNameField = objMap.Target_External_ID_is_Name_Field__c;
                        objInfoWrap.jobId = objMap.X18_Character_Job_Id__c;
                        //fill the fields
                        if(objMap.FieldsMapping__r != null && objMap.FieldsMapping__r.size() > 0){
                            for(Field_Mapping__c fieldMap : objMap.FieldsMapping__r){
                                
                                DataMoverFieldInfoWrapper fieldWrap = new DataMoverFieldInfoWrapper();
                                fieldWrap.srcFieldLbl = fieldMap.Source_Field_Label__c + '-' + fieldMap.Source_Field_Type__c + '-' + fieldMap.Source_Field_API_Name__c.toLowercase();
                                fieldWrap.srcFieldApiName = fieldMap.Source_Field_API_Name__c.toLowercase();
                                fieldWrap.srcFieldType = fieldMap.Source_Field_Type__c;
                                if(fieldMap.Source_Field_Required__c == 'true'){
                                    fieldWrap.srcFieldRequired = true;
                                }                           
                                fieldWrap.srcObjApi = objMap.Source_Object_API_Name__c.toLowercase();
                                fieldWrap.srcIsNameField = fieldMap.Source_Is_Name_Field__c;
                                fieldWrap.trgFieldLbl = fieldMap.Target_Field_Label__c;
                                fieldWrap.trgFieldApiName = fieldMap.Target_Field_API_Name__c.toLowercase();
                                fieldWrap.trgFieldType = fieldMap.Target_Field_Type__c;
                                if(fieldMap.Target_Field_Required__c == 'true'){
                                    fieldWrap.trgFieldRequired = true;
                                }   
                                fieldWrap.trgObjApi = objMap.Target_Object_API_Name__c.toLowercase();
                                fieldWrap.trgIsNameField = fieldMap.Target_Is_Name_Field__c;
                                fieldWrap.fieldMappingCreated = fieldMap;
                                fieldWrap.fieldMappingId = fieldMap.Id;
                                //add the values if there are any
                                if(chkBoxPckList != null && chkBoxPckList.size() > 0){
                                    for(CheckBox_Picklist_Correlation__c chkPick : chkBoxPckList){
                                        //if the field api name of both is the same as the fields created, create value                                     
                                        if(chkPick.Source_Field_API_Name__c == fieldWrap.srcFieldApiName && chkPick.Target_Field_API_Name__c == fieldWrap.trgFieldApiName){
                                            DataMoverValueInfoWrapper valueWrap = new DataMoverValueInfoWrapper();
                                            valueWrap.srcValue = chkPick.Source_Value__c;
                                            valueWrap.trgValue = chkPick.Target_Value__c;   
                                            valueWrap.checkboxPicklistId = chkPick.Id;
                                            fieldWrap.matchingValues.add(valueWrap);    
                                        }                                                                       
                                    }
                                }
                                fieldWrap.checkIfThereAreMoreThanOneCheckboxPicklist();
                                //add the field to its corresponding map or as ext id
                                if(fieldMap.Source_Field_API_Name__c.equalsIgnoreCase(objMap.Source_External_ID_API_Name__c.toLowercase())){
                                    system.debug('>>>>> objMap.Source_External_ID_API_Name__c' + objMap.Source_External_ID_API_Name__c);
                                    objInfoWrap.externalIdFieldMapping = fieldWrap;
                                }else{
                                    if(fieldWrap.trgFieldRequired == true){
                                        objInfoWrap.allMatchingFieldsRequired.put(fieldWrap.trgFieldApiName.toLowercase(), fieldWrap);
                                    }else{
                                        objInfoWrap.allMatchingFieldsNotRequired.put(fieldWrap.trgFieldApiName.toLowercase(), fieldWrap);
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }   
     }
     
    
    /*
     * It uses the object describe from the package
     * to fill the target api name of the new object with 
     * corresponding value from onlyXlr8Objects
     * @params DataMoverObjectInfoWrapper, objWrap: the object whose api name will be added
     */
     public void fillTrgApiNameInObjectWrapper(DataMoverObjectInfoWrapper objWrap){
        for(DataMoverOneObjectWrapper wrapper : pageController.onlyXlr8Objects.values()){
            if(wrapper.objLabel == objWrap.targetLabel){
                objWrap.targetApiName = wrapper.objApiName.toLowercase();
            }
        }   
     } 
     
     /*
      * It takes the user back to step 1,
      * and makes null the maps and lists
      * created in step 1 and in the instantiation 
      * of component 2
      */
     public void goBackToStep1(){
        pageController.noObjectSelected = false;
        pageController.initStep2Component = true;
        pageController.onlyXlr8Objects = null;
        pageController.onlySourceObjects = null;
        pageController.srcTrgWrappers = null;
        pageController.selectedPackage = null;
        pageController.goToStep1();
     }
     
    
}