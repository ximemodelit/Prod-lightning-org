/* 
 *Batchable class to delete DM securities
 *@author Ximena Lasserre
 *@since September 2015
 */ 
global class DataMoverDeleteSecuritiesBatch implements Database.Batchable<sObject> {

	private String query;
	private String jobName;
	private Id jobLogId;
	private Mapping_Object__c securitiesMapObj;
	
	public DataMoverDeleteSecuritiesBatch(Mapping_Object__c securitiesMapObj, String jobName, Id jobLogId){
		this.query = 'SELECT Id FROM ' + securitiesMapObj.get('Target_Object_API_Name__c') + ' WHERE Package_of_Origin__c = \'' + securitiesMapObj.Package_Name__c + '\'';
		this.jobName = jobName;
		this.jobLogId = jobLogId;
		this.securitiesMapObj = securitiesMapObj;
	}
	
	global Database.QueryLocator start(Database.BatchableContext context) {
	    return Database.getQueryLocator(query);
	}
	  
	global void execute(Database.BatchableContext context, List<SObject> records) {
		delete records;
	}
	  
	global void finish(Database.BatchableContext context){
	  	//execute the batch to insert securities
	  	executeSecuritiesBatch(securitiesMapObj, jobName, jobLogId);
	}
	
	/*
     *Executes the batch class DataMoverSecuritiesDataMappingBatch
     *@param Mapping_Object__c mapObj
     *@param String jobName
     *@param Id jobLogId
     */
    private void executeSecuritiesBatch(Mapping_Object__c mapObj, String jobName, Id jobLogId){
    	List<Field_Mapping__c> fieldMappingForMapObj = mapObj.FieldsMapping__r;
											   
		Integer times = 0;
		String query = '';
		//iterate over fieldMappingForMapObj to create the query 
		if (fieldMappingForMapObj != null && fieldMappingForMapObj.size() > 0){
			query += 'SELECT ';
			for(Field_Mapping__c field : fieldMappingForMapObj){
				if(times < fieldMappingForMapObj.size() - 1){ 
					query += field.Source_Field_API_Name__c + ', ';
					times += 1;
				}
				else{ 
					query += field.Source_Field_API_Name__c;
				}				
			}			
			query += ' FROM ' + mapObj.Source_Object_API_Name__c;
		
			system.debug('### ' + query + '-' + 
				                  mapObj.Source_External_ID_API_Name__c + '-' + 
				                  mapObj.Target_External_ID_API_Name__c + '-' + 
				                  mapObj.Source_Object_API_Name__c + '-' + 
				                  mapObj.Target_Object_API_Name__c  + '-'+ 
				                  mapObj.Id + '-'+
				                  mapObj.Source_External_ID_is_Name_Field__c +'-'+
				                  mapObj.Target_External_ID_is_Name_Field__c +'-'+ 
				                  jobName + '-' + jobLogId + '-' + mapObj.Package_Name__c);

		}

		if (query != '' && query.length() > 0){
			DataMoverSecuritiesDataMappingBatch batch = new DataMoverSecuritiesDataMappingBatch(query, mapObj.Source_External_ID_API_Name__c,
									mapObj.Target_External_ID_API_Name__c, mapObj.Source_Object_API_Name__c, mapObj.Target_Object_API_Name__c,
									mapObj.Id, mapObj.Source_External_ID_is_Name_Field__c, mapObj.Target_External_ID_is_Name_Field__c,
									jobName, jobLogId, mapObj.Package_Name__c);
									
			//execute the batch	
			Database.executebatch(batch, 200);	
		}else{
			JobLogWrapper jobWrapper = new JobLogWrapper();
			ErrorLogWrapper error = new ErrorLogWrapper();
			error.errorDescription = 'Securities were not loaded because the mapping between Account Positions and Securities is not defined';
			jobWrapper.errorLogs.add(error);    
			DataMoverDataMappingBatchUtils.insertJobAndErrorLog(jobWrapper, jobName, jobLogId, true);         
		}
    }
}