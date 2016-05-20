/*
 * Utils class for all datamover components controllers
 * @author Ximena Lasserre
 * @since Feb 2015 
 */
public class DataMoverComponentsUtils {

    /*
     * Queries the object PackageLicense whose namespace prefix is the one that
     * was selected and checks if it is installed and active
     * @param String - namespacePref: namespace prefix to be checked 
     * @return boolean: true: the package is installed, false: the package is not installed
     */
    public static boolean checkInstalledPackage(String namespacePref){
        
        List<PackageLicense> listPackLic = [SELECT Status
                                            FROM PackageLicense
                                            WHERE NamespacePrefix = :namespacePref];
        
        if(listPackLic.size() > 0 && listPackLic[0].Status == 'Active'){            
            return true;
        }else{
            return false;
        }
    }
    
    /*
     * Checks if the selected pair of objects already exists, 
     * if so it fills them with the existing information
     * @objsToSeeIfExist - List<DataMoverObjectInfoWrapper>: list of objects to query
     */
     public static void checkIfObjectExistsAndFill(DataMoverObjectInfoWrapper objToSeeIfExist){
        
        String srcTrgLabel = objToSeeIfExist.sourceLabel + objToSeeIfExist.targetLabel;
        
        //query the objects and bring the ones that exist
        List<Mapping_Object__c> existingObject = [SELECT Id, Package_Name__c, Scheduled_Job_Id__c, Source_External_ID_Field__c,
                                                            Source_Object_API_Name__c, Source_Object_Label__c, SourceTargetLabel__c, 
                                                            Target_External_ID_Field__c, Target_Object_API_Name__c, Target_Object_Label__c,
                                                            Target_External_ID_Field_Type__c, Source_External_ID_Field_Type__c, X18_Character_Job_Id__c,
                                                            Source_External_ID_is_Name_Field__c, Target_External_ID_is_Name_Field__c, Source_External_ID_API_Name__c,
                                                            Target_External_ID_API_Name__c, Data_Mover_Scheduled_Job__c,
                                                            (SELECT Id, Field_Mapping__c.Source_Field_API_Name__c, Field_Mapping__c.Source_Field_Label__c,
                                                                    Field_Mapping__c.Source_Field_Type__c, Field_Mapping__c.Target_Field_API_Name__c,
                                                                    Field_Mapping__c.Source_Field_Required__c, Field_Mapping__c.Target_Field_Required__c,
                                                                    Field_Mapping__c.Target_Field_Label__c, Field_Mapping__c.Target_Field_Type__c, 
                                                                    Field_Mapping__c.Source_Is_Name_Field__c, Field_Mapping__c.Target_Is_Name_Field__c                                                                                                                              
                                                             FROM Mapping_Object__c.FieldsMapping__r)
                                                   FROM Mapping_Object__c
                                                   WHERE SourceTargetLabel__c = :srcTrgLabel];
                                                   
        //create a list to store the ids of the field mappings  
        List<CheckBox_Picklist_Correlation__c> chkBoxPckList;
        if(existingObject != null && existingObject.size() > 0){
            //here query the checkboxes
            chkBoxPckList = [SELECT Id, Source_Field_API_Name__c, Source_Value__c,
                                    Target_Field_API_Name__c, Target_Value__c
                             FROM CheckBox_Picklist_Correlation__c
                             WHERE Field_Mapping__c = :existingObject[0].Id];   
                    
            //fill the objectInfoWrapper with the existing info
            objToSeeIfExist.sourceApiName = existingObject[0].Source_Object_API_Name__c;
            objToSeeIfExist.sourceExtIdField = existingObject[0].Source_External_ID_Field__c + '-' + existingObject[0].Source_External_ID_Field_Type__c;
            objToSeeIfExist.sourceExtIdFieldType = existingObject[0].Source_External_ID_Field_Type__c;
            objToSeeIfExist.sourceExtIdFieldAPI = existingObject[0].Source_External_ID_API_Name__c;
            objToSeeIfExist.targetApiName = existingObject[0].Target_Object_API_Name__c;
            objToSeeIfExist.mappingObjectCreated = existingObject[0];
            objToSeeIfExist.targetExtIdField = existingObject[0].Target_External_ID_Field__c + '-' + existingObject[0].Target_External_ID_Field_Type__c;
            objToSeeIfExist.targetExtIdFieldType = existingObject[0].Target_External_ID_Field_Type__c;
            objToSeeIfExist.targetExtIdFieldAPI = existingObject[0].Target_External_ID_API_Name__c;
            objToSeeIfExist.mapppingObjectId = existingObject[0].Id;
            objToSeeIfExist.sourceExtIdFieldIsNameField = existingObject[0].Source_External_ID_is_Name_Field__c;
            objToSeeIfExist.targetExtIdFieldIsNameField = existingObject[0].Target_External_ID_is_Name_Field__c;
            objToSeeIfExist.jobId = existingObject[0].X18_Character_Job_Id__c;
            //fill the fields
            if(existingObject[0].FieldsMapping__r != null && existingObject[0].FieldsMapping__r.size() > 0){
                for(Field_Mapping__c fieldMap : existingObject[0].FieldsMapping__r){
                    DataMoverFieldInfoWrapper fieldWrap = new DataMoverFieldInfoWrapper();
                    fieldWrap.srcFieldLbl = fieldMap.Source_Field_Label__c + '-' + fieldMap.Source_Field_Type__c;
                    fieldWrap.srcFieldApiName = fieldMap.Source_Field_API_Name__c;
                    fieldWrap.srcFieldType = fieldMap.Source_Field_Type__c;
                    if(fieldMap.Source_Field_Required__c == 'true'){
                        fieldWrap.srcFieldRequired = true;
                    }else{
                        fieldWrap.srcFieldRequired = false;
                    }                           
                    fieldWrap.srcObjApi = existingObject[0].Source_Object_API_Name__c;
                    fieldWrap.srcIsNameField = fieldMap.Source_Is_Name_Field__c;
                    fieldWrap.trgFieldLbl = fieldMap.Target_Field_Label__c;
                    fieldWrap.trgFieldApiName = fieldMap.Target_Field_API_Name__c;
                    fieldWrap.trgFieldType = fieldMap.Target_Field_Type__c;
                    if(fieldMap.Target_Field_Required__c == 'true'){
                        fieldWrap.trgFieldRequired = true;
                    }else{
                        fieldWrap.trgFieldRequired = false;
                    }   
                    fieldWrap.trgObjApi = existingObject[0].Target_Object_API_Name__c;
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
                    //add the field to its corresponding map
                    if(fieldWrap.trgFieldRequired == true){
                        objToSeeIfExist.allMatchingFieldsRequired.put(fieldWrap.trgFieldApiName, fieldWrap);
                    }else{
                        objToSeeIfExist.allMatchingFieldsNotRequired.put(fieldWrap.trgFieldApiName, fieldWrap);
                    }
                }
            }
        }
    }
    
    /*
     * Returns a list of Mapping objects that have that related job id
     *
     *
     */
    public static List<Mapping_Object__c> queryForTheMappingObjectWithThatJob(List<Id> idsOfJobs){
        
        Map<String, String> srcTrgMap = new Map<String, String>();
        List<Mapping_Object__c> mappingObjects;
        if(idsOfJobs != null && idsOfJobs.size() > 0){
            
            mappingObjects = [SELECT Id, Source_Object_Label__c, Target_Object_Label__c, Data_Mover_Scheduled_Job__c
                                FROM Mapping_Object__c
                               WHERE Data_Mover_Scheduled_Job__c IN :idsOfJobs];                                           
        }

        return mappingObjects;
    }
    
    /*
     * Aborts the scheduled jobs whose ids are stored in the job objects passed as a parameter
     * @param List<Id> jobsIds: list of ids whose job wants to be aborted
     */
    public static void abortJobs(List<Id> jobsIds){
        //query the job object for the cron trigger id
        List<Data_Mover_Scheduled_Job__c> jobObjects;
        if(jobsIds.size() > 0){
            jobObjects = [SELECT Job_Id__c
                            FROM Data_Mover_Scheduled_Job__c
                           WHERE Id IN :jobsIds];
        }
        //get the cron trigger and put it in a list
        if(jobObjects != null && jobObjects.size() > 0){
            List<Id> scheduledJobIds =  new List<Id>();
            for(Data_Mover_Scheduled_Job__c job : jobObjects){
                scheduledJobIds.add(job.Job_Id__c);
            }
            //query the cron triggers to abort them
            List<CronTrigger> cronTriggers = [SELECT Id, CronJobDetail.Name
                                                FROM CronTrigger 
                                               WHERE Id IN :scheduledJobIds];
            
            if(cronTriggers.size() > 0){
                for(CronTrigger cron : cronTriggers){
                    system.abortJob(cron.Id);
                }
            }  
        }                   
    }
    
    /*
     * Deletes the scheduled jobs gotten from the query
     * @param List<Id> jobsIds
     * @return Database.DeleteResult[]
     */
    public static Database.DeleteResult[] deleteOldJobs(List<Id> jobsIds){
        List<Data_Mover_Scheduled_Job__c> scheduledJobs;
        if(jobsIds != null && jobsIds.size() > 0){
            scheduledJobs = [SELECT Id, Name
                               FROM Data_Mover_Scheduled_Job__c
                              WHERE Id IN :jobsIds];
        }
        if(scheduledJobs != null){
            return Database.delete(scheduledJobs, true);
        }
        return null;
    }
    
    /*
     * Checks if the name of the job passed as a parameter already exists
     * @param String jobName: Name of the job
     * @return boolean: true if exists, else false
     */
    public static boolean checkIfJobNameAlreadyExists(String jobName){
        List<CronTrigger> cronTrigger = [SELECT Id,  CronJobDetail.Name
                                           FROM CronTrigger 
                                          WHERE CronJobDetail.Name = :jobName];
        if(cronTrigger.size() > 0){
            return true;
        }else{
            return false;
        }               
                    
    }
    
   /*
    * Checks if the set has a string that contains the other string passed
    * @param Set<String> stringSet
    * @param String name
    * @return boolean
    */
   public static boolean setContainsString(Set<String> stringSet, String name){
       for(String str : stringSet){
           if(str.contains(name)){
               return true;
           }
        }
        return false;
    }
    
    /*
     * Deletes the field mapping that has the source api name and target api name
     * passed as params
     * @param String srcFieldApi
     * @param String trgFieldApi
     */
    public static void deleteExternalIdFieldMapping(String srcFieldApi, String trgFieldApi){
        String query = 'SELECT Id FROM Field_Mapping__c WHERE Source_Field_API_Name__c LIKE \'';
        query += srcFieldApi + '\' AND Target_Field_API_Name__c LIKE \'' + trgFieldApi + '\'';
        List<SObject> fieldMappingDelete = Database.query(query); 
        
        if(fieldMappingDelete != null && fieldMappingDelete.size() > 0){ 
            //delete the Field_Mapping__c
            Database.DeleteResult[] deleteResults = Database.delete(fieldMappingDelete, false);
            List<String> errors = new List<String>();
            for(Database.DeleteResult dr : deleteResults){
                if(!dr.isSuccess()){
                    for(Database.Error err : dr.getErrors()){
                        errors.add(err.getMessage());
                    }
                }
            }
            if(errors.size() > 0){
                for(String error : errors){
                    system.debug(error);
                }
            }
        }
    }
    
}