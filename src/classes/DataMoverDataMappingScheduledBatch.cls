/**
 * Scheduled class to run the batch DataMoverDataMappingBatch
 * @author Ximena Lasserre
 * @since 2014-12
 */
public class DataMoverDataMappingScheduledBatch implements Schedulable{

	/*
	 * Executes the DataMoverDataMappingBatch class for 
	 * each mapping object that there is
	 * @param SchedulableContext sc
	 */ 
	 public void execute(SchedulableContext sc){ 
		List<Data_Mover_Scheduled_Job__c> scheduledJob;
		if(!Test.isRunningTest()){
			//get the job's id
			String jobId = String.ValueOf(sc.getTriggerId());
			
			//query the Data_Mover_Scheduled_Job__c for that job  
			scheduledJob = [SELECT Id, Name, Creator_Email__c, Cron_Expression__c, End_Date__c,
								   Job_Id__c, Start_Date__c,
								   (SELECT Id
								      FROM Mapping_Objects__r)
						      FROM Data_Mover_Scheduled_Job__c
							 WHERE Job_Id__c = :jobId LIMIT 1];
		}else{
			scheduledJob = [SELECT Id, Name, Creator_Email__c, Cron_Expression__c, End_Date__c,
								 Job_Id__c, Start_Date__c,
								 (SELECT Id
								    FROM Mapping_Objects__r)
				   		      FROM Data_Mover_Scheduled_Job__c LIMIT 1];
			
		}
			
			//if the current date is within the start date and end date continue 
		if(scheduledJob.size() > 0){
			if(Datetime.now().date() >= scheduledJob[0].Start_Date__c && Datetime.now().date() <= scheduledJob[0].End_Date__c){
				List<Id> mappingObjectIds = new List<Id>();
				for(Data_Mover_Scheduled_Job__c jobs : scheduledJob){
					for(Mapping_Object__c mapObj : jobs.Mapping_Objects__r){
						mappingObjectIds.add(mapObj.Id);
					}
				}
				
				if(mappingObjectIds.size() > 0){
					DataMoverDataMappingBatch sac = new DataMoverDataMappingBatch(mappingObjectIds, scheduledJob[0].Name, null);
					Database.executebatch(sac, 200);
				}
			}	
		}
	}
}