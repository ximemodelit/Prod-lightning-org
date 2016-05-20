public with sharing class XLR8ProcessUtils {

	public static Process__c getProcessAndSteps(Id processId, String stepStatus){
		Process__c result = null;
		
		if (processId != null){
			List<Process__c> processes = [SELECT Status__c,  
												 (SELECT Status__c 
												   FROM Process_Steps__r 
												  WHERE Status__c =: stepStatus) 
											FROM Process__c 
										   WHERE Id =: processId];
			
			if (processes.size() == 1){
				result = processes.get(0);
			}
		}
		
		return result;
	}
	
	public static List<Process__c> getProcessesById(Set<Id> processIds){
		List<Process__c> processes = null;
		
		if (processIds != null && processIds.size() > 0){
			processes = [SELECT  Id, Name,
								 Auto_Create_Tasks__c,
								 Entity__c, Entity__r.Name,
								 Case__c, Case__r.CaseNumber,
								 Contact__c, Contact__r.Name,
								 Lead__c, Lead__r.Name,
								 Opportunity__c, Opportunity__r.Name,
								 Template_Type__c, Process_Template__r.Auto_Create_Tasks_Default__c
							FROM Process__c 
						   WHERE Id IN : processIds];
		}
		
		return processes;
	}
	
	public static List<Process_Step__c> getSteps(List<Process_Step__c> selectedSteps){
		List<Process_Step__c> steps = null;
		
		if (selectedSteps != null && selectedSteps.size() > 0){
			steps = [Select Name, Sequence__c,Duration_In_Days__c, Step_Details__c, 
							Predecessor_Steps__c, Assigned_To__c, Status__c, Process__c, 
							Process__r.Name
					 From Process_Step__c 
					 Where Id IN :selectedSteps];
			
			
		}
		
		return steps;
	}
	
	public static string getProcessName(Id processId){
		String processName = '';

		if (processId != null){
			List<Process__c> processes = [Select Id, Name from Process__c where id =: processId];
			if (processes.size() > 0){
				processName = processes.get(0).Name;
			}
		}
		
		return processName;
	}
}