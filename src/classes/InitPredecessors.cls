public with sharing class InitPredecessors {

	public void initPredecessors(List<Process__c> processes) {
		List<Process__c> processesAndSteps = [SELECT Id, 
			(SELECT Sequence__c FROM Process_Steps__r ORDER BY Sequence__c) 
			FROM Process__c WHERE Id IN :processes];
		
		List<Process_Step_Junction__c> junctions = new List<Process_Step_Junction__c>();
		for (Process__c process1 : processesAndSteps) {
			for (Integer i = 0; i < process1.Process_Steps__r.size(); i++) {
				Process_Step__c step = process1.Process_Steps__r.get(i);
				if (i > 0) {
					junctions.add(new Process_Step_Junction__c(
						ParentStep__c = process1.Process_Steps__r.get(i).Id,
						PredecessorStep__c = process1.Process_Steps__r.get(i - 1).Id
					));
				}
			} 
		}
		if (isProcessStepJnctionCreateable()){
			insert junctions;
		}
		
	}
	
	private Boolean isProcessStepJnctionCreateable(){
		return  Schema.sObjectType.Process_Step_Junction__c.isCreateable();
	}
}