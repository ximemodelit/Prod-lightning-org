/**
 *Utils class for DataMoverDataMappingBatch class
 *@author Ximena Lasserre
 *@since 2014-12
 */
public class DataMoverDataMappingBatchUtils { 
	  
	//constants
    private static final String CHECKBOX_STRING = 'BOOLEAN';
    private static final String PICKLIST_STRING = 'PICKLIST';
    
	/** 
	 *Casts a value of the type DateTime to Date type 
	 *@param DateTime, dtValue - value to be casted
	 *@return Date - casted value
	 */
	public static Date castDateTimeValueToDate(DateTime dtValue){
		if(dtValue != null) 
			return dtValue.Date();
		return null;
	}
	 
	/*
	 * Reduce the length of the string to the indicated value
	 * @param String, txtToReduce - text that will be reduced 
	 * @param Integer, newLength - new length of the text
	 * @return String - reduced text
	 */
	public static String reduceStringLength(String txtToReduce, Integer newLength){
		if(txtToReduce != null){
			return txtToReduce.subString(0, newLength);
		}
		else{
			return null;
		}
	}
	
	/*
	 * Checks if both of the passed fields is a checkbox or a picklist
	 * @param String sourceFieldType: the type of the source field
	 * @param String targetFieldType: the type of the target field
	 * @return boolean: true if both are a checkbox or picklist, false if not
	 */
	public static boolean checkIfAnyFieldIsCheckboxOrPicklist(String sourceFieldType, String targetFieldType){
		if((sourceFieldType == CHECKBOX_STRING || sourceFieldType == PICKLIST_STRING) && 
        (targetFieldType == CHECKBOX_STRING || targetFieldType == PICKLIST_STRING)){
        	return true;    	
        }
        return false;
	}
	
	/*
	 * Returns the DescribeFieldResult of the SObjectField
	 * @param Schema.SObjectField field: the field whose describe we want
	 * @return Schema.DescribeFieldResult: the describe field result of the field
	 */
	public static Schema.DescribeFieldResult getDescribeFieldResult(Schema.SObjectField field){
		if(field != null)
			return field.getDescribe();
		else
			return null;	
	}
		
	/*
	 * Inser or updates the Data_Mover_Job_Log__c object, along with the Data_Mover_Error_Log__c
	 * objects it may be related to.
	 * @param JobLogWrapper jobWrapper: object to use the information from
	 * @param String scheduledJobName: name of the created job to query the Data_Mover_Scheduled_Job__c
	 * @param Id jobLogId id of the job log object
	 * @param boolean finalBatch: true if it is the final batch, false if not
	 * @return Id: id of the job log object
	 */
	public static Id insertJobAndErrorLog(JobLogWrapper jobWrapper, String scheduledJobName, Id jobLogId, boolean finalBatch){
		//get the scheduled job associated to the job
		String jobNameTrimmed = scheduledJobName.trim(); 
		List<Data_Mover_Scheduled_Job__c> scheduledJobs = [SELECT Id, Name, Creator_Email__c, Cron_Expression__c, 
																  End_Date__c, Job_Id__c, Start_Date__c
													   		 FROM Data_Mover_Scheduled_Job__c
													        WHERE Name = :jobNameTrimmed LIMIT 1];
													        
		Data_Mover_Job_Log__c jobLog = new Data_Mover_Job_Log__c();	
		
		system.debug(jobLogId);									        
		if(jobLogId != null){
			//if the jobLogId is not null, query the Data_Mover_Job_Log__c it belongs to											        
			List<Data_Mover_Job_Log__c> jobLogs = [SELECT Id, Name, Number_of_Errors__c, 
														  Number_of_Processed_Records__c, Start_DateTime__c
											   		   FROM Data_Mover_Job_Log__c
											          WHERE Id = :jobLogId LIMIT 1];
		
			if(jobLogs.size() > 0){
				
				jobLog = jobLogs[0];
				jobLog.Number_of_Processed_Records__c += jobWrapper.nrOfRecords;	
				
				Database.SaveResult updateResult = Database.update(jobLog, false);
				//if the insertion was successful, insert the errors
				if(updateResult.isSuccess()){
					jobLogId = updateResult.getId();
					List<Data_Mover_Error_Log__c> errors = new List<Data_Mover_Error_Log__c>();
					if(jobWrapper.errorLogs.size() > 0){
						for(ErrorLogWrapper error : jobWrapper.errorLogs){
							Data_Mover_Error_Log__c errorLog = new Data_Mover_Error_Log__c();
							errorLog.Error_Description__c = error.errorDescription;
							errorLog.Created_Date__c = error.createdDate;
							errorLog.Data_Mover_Job_Log__c = jobLog.Id;
							errorLog.Status__c = error.status;
							errorLog.Source_Object__c = error.sourceObj;
							errorLog.Target_Object__c = error.targetObj;
							errorLog.Value_of_Object_External_Id_Field__c = error.valueOfObjectExtId;
							errors.add(errorLog);
						}
					}	
					//insert the errors
					Database.insert(errors, true);	
				}
			}
		}else{
			//create and insert new joblog
			jobLog.Number_of_Processed_Records__c = jobWrapper.nrOfRecords;		
			jobLog.Start_DateTime__c = jobWrapper.startDateTime;
			jobLog.Data_Mover_Scheduled_Job__c = scheduledJobs[0].Id;
		
			Database.SaveResult insertResult = Database.insert(jobLog, false); 
			
			//if the insertion was successful, insert the errors and get its id
			if(insertResult.isSuccess()){
				jobLogId = insertResult.getId();
				List<Data_Mover_Error_Log__c> errors = new List<Data_Mover_Error_Log__c>();
				if(jobWrapper.errorLogs.size() > 0){
					for(ErrorLogWrapper error : jobWrapper.errorLogs){
						Data_Mover_Error_Log__c errorLog = new Data_Mover_Error_Log__c();
						errorLog.Error_Description__c = error.errorDescription;
						errorLog.Created_Date__c = error.createdDate;
						errorLog.Data_Mover_Job_Log__c = jobLog.Id;
						errorLog.Status__c = error.status;
						errorLog.Source_Object__c = error.sourceObj;
						errorLog.Target_Object__c = error.targetObj;
						errorLog.Value_of_Object_External_Id_Field__c = error.valueOfObjectExtId;
						errors.add(errorLog);
					}
				}	
				//insert the errors
				Database.insert(errors, true);	
			}
		}
		if(finalBatch){ //if its the final batch, send email
			//query the updated job log
			List<Data_Mover_Job_Log__c> finalJobList = [SELECT Id, Name, Number_of_Errors__c, 
														  Number_of_Processed_Records__c, Start_DateTime__c
											   		   FROM Data_Mover_Job_Log__c
											          WHERE Id = :jobLogId LIMIT 1];
			system.debug('******************* ' + finalJobList.size());								          
			if(finalJobList.size() > 0){								          
				sendEmailNotification(finalJobList[0], scheduledJobs[0], Integer.valueOf(finalJobList[0].Number_of_Errors__c));
			}
		}
		return jobLogId;
	}
	/*
	 * Sends an email notification to the user email on the Data_Mover_Scheduled_Job__c
	 * @param Data_Mover_Job_Log__c jobLog: Log object of the current job batch
	 * @param Data_Mover_Scheduled_Job__c jobObject: Scheduled job object
	 * @param Integer nrErrors: Nr of errors had in the batch
	 */
	private static void sendEmailNotification(Data_Mover_Job_Log__c jobLog, Data_Mover_Scheduled_Job__c jobObject, Integer nrErrors){
		
		//instantiate email
		Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
		
		String userTimeZone = UserInfo.getTimeZone().toString();
		String dateTimeInString = jobLog.Start_DateTime__c.format('MM/dd/yyyy HH:mm:ss', userTimeZone);
		
		//create subject
		String subject = 'Batch for job ' + jobObject.Name + ' has executed on ' + dateTimeInString + '.';
		email.setSubject(subject);
		
		//create url
		String link = URL.getSalesforceBaseURL().toExternalForm() + '/' + jobLog.Id; 
		
		//create body
		String body = '<div><p>The batch for job "' + jobObject.Name + '" has executed on ' + dateTimeInString + '.';
		body+= ' There were ' + jobLog.Number_of_Processed_Records__c + ' processed records.';
		body+= ' Of those, ' + nrErrors + ' record(s) failed.</p>';
		body+= ' <p>Please click <a href=\'' + link +'\'>here</a> for more information.</p></div>';
		email.setHtmlBody(body); 
		
		//add addresses
		String[] listEmails = new List<String>();
		listEmails.add(jobObject.Creator_Email__c);
		email.setToAddresses(listEmails); 
		
		//send email
		List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
		emails.add(email);
		Messaging.sendEmail(emails);
	}
	
		
	/*
	 *It retrieves the values of the external id field passed as sourceExternalIDApi
	 *in the object passed as sourceApi
	 *@param String sourceExternalIDApi
	 *@param String sourceApi
	 *@return List<String>
	 */
	static public List<String> getValuesOfExternalIdFieldsFromSource(String sourceExternalIDApi, String sourceApi){
		List<String> valuesFromSourceObjects = new List<String>();
		String query = 'SELECT ' + sourceExternalIDApi + ' FROM ' + sourceApi;
		List<SObject> sourceObjects = Database.query(query);
		if(sourceObjects.size() > 0){
			for(SObject sourceObject : sourceObjects){
				valuesFromSourceObjects.add(String.valueOf(sourceObject.get(sourceExternalIDApi)));
			}
		}
		return valuesFromSourceObjects;
	}
	
	
	/*
	 *Queries for a mapping object whose target object is securities and package name is Schwab's
	 *and if there were assets & liabilities mapped in this job
	 *@List<Id> mappingObjectsIdsForThisPckg
	 *@param String packageName
	 *@return Mapping_Object__c
	 */
	static public Mapping_Object__c checkIfSecuritiesExistForPackage(List<Id> mappingObjectsIdsForThisPckg, String packageName){
		List<Mapping_Object__c> mappingObjects = [SELECT Id, Package_Name__c, Source_External_ID_Field__c, Source_Object_API_Name__c, 
												         Source_Object_Label__c, Target_External_ID_Field__c, Target_Object_API_Name__c,
												  		 Target_Object_Label__c, X18_Character_Job_Id__c, Source_External_ID_Field_Type__c,
												  		 Source_External_ID_is_Name_Field__c, SourceTargetLabel__c, Target_External_ID_Field_Type__c,
												  		 Target_External_ID_is_Name_Field__c, Source_External_ID_API_Name__c, Target_External_ID_API_Name__c, 
												  		 (SELECT Id, Object_Mapping__c, Source_Field_API_Name__c,
			  								  			  		 Source_Field_Label__c, Source_Field_Required__c, Source_Field_Type__c,
			  								              		 Source_Is_Name_Field__c, Target_Field_API_Name__c, Target_Field_Label__c, 
				   							              		 Target_Field_Type__c, Target_Field_Required__c, Target_Is_Name_Field__c  
				                                     	    FROM FieldsMapping__r) 
				                                    FROM Mapping_Object__c
												   WHERE Target_Object_API_Name__c LIKE '%Securities%'
													 AND Package_Name__c = :packageName];
		List<Mapping_Object__c> assets = [SELECT Id
										    FROM Mapping_Object__c
										   WHERE Id IN :mappingObjectsIdsForThisPckg
										     AND Target_Object_API_Name__c LIKE '%Assets_Liabilities%'];	
		if(assets.size() > 0){								     										 
			if(mappingObjects.size() == 1){
				return mappingObjects[0];
			}else{
				return null;
			}
		}else{
			return null;
		}											
	}
	
	
	/*
	 * Queries a mapping object whose id is one of the ones in the list and has not been synced
	 * @param List<Id> mappingObjIds
	 * @return Mapping_Object__c
	 */
	static public Mapping_Object__c retrieveMappingObjectToRunBatch(List<Id> mappingObjIds){
		system.debug(mappingObjIds); 
		List<Mapping_Object__c> mapObjToReturnList = [SELECT Id, Synced__c, Package_Name__c, Source_External_ID_Field__c, Source_Object_API_Name__c, 
														         Source_Object_Label__c, Target_External_ID_Field__c, Target_Object_API_Name__c,
														  		 Target_Object_Label__c, X18_Character_Job_Id__c, Source_External_ID_Field_Type__c,
														  		 Source_External_ID_is_Name_Field__c, SourceTargetLabel__c, Target_External_ID_Field_Type__c,
														  		 Target_External_ID_is_Name_Field__c, Source_External_ID_API_Name__c, Target_External_ID_API_Name__c, 
														  		 (SELECT Id, Object_Mapping__c, Source_Field_API_Name__c,
					  								  			  		 Source_Field_Label__c, Source_Field_Required__c, Source_Field_Type__c,
					  								              		 Source_Is_Name_Field__c, Target_Field_API_Name__c, Target_Field_Label__c, 
						   							              		 Target_Field_Type__c, Target_Field_Required__c, Target_Is_Name_Field__c  
						                                     	    FROM FieldsMapping__r) 
		                                      FROM Mapping_Object__c 
			  							     WHERE Id IN :mappingObjIds
			  							       AND Synced__c = false
			  							       AND (NOT Target_Object_API_Name__c LIKE '%Securities%') LIMIT 1];
		
		if(mapObjToReturnList.size() > 0){
			return mapObjToReturnList[0];
		}else{
			return null;
		} 
	}
	
	/* 
	 * Updates the Synced__c field of the mapping object passed as param to true
	 * @param Mapping_Object__c mapObjToUpdate
	 */
	static public void changeSyncedToTrueForMappingObject(Mapping_Object__c mapObjToUpdate){
		mapObjToUpdate.Synced__c = true;
		Database.saveResult result = Database.update(mapObjToUpdate);
		if(!result.isSuccess()){
			for(Database.Error e : result.getErrors()){
				system.debug('Error: ' + e);
			}
		}
		
	}
	
	/*
	 * Updates all the mapping objects retrieved with their id,
	 * so that their Synced__c field is set to false
	 * @param List<Id> mappingObjectsIds
	 */
	static public void changeSyncedToFalseForAll(List<Id> mappingObjectsIds){
		List<Mapping_Object__c> mappingObjectsList = [SELECT Id, Synced__c
														FROM Mapping_Object__c
													   WHERE Id IN :mappingObjectsIds];
		if(mappingObjectsList != null && mappingObjectsIds.size() > 0){
			for(Mapping_Object__c mapObj : mappingObjectsList){
				mapObj.Synced__c = false;
			}
		}								
		//update mapping objects
		Database.saveResult[] results = Database.update(mappingObjectsList);		
		for(Database.saveResult res : results){
			if(!res.isSuccess()){
				for(Database.Error e : res.getErrors()){
					system.debug('Error: ' + e);
				}
			}
		}	    
	}
	
}