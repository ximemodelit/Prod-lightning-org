@isTest
private class MassCreateProcesses_T {
	
	@isTest
	private static void test() {
		Process_Template__c template = new Process_Template__c(
			Name = 'testtemplate',
			Auto_Create_Tasks_Default__c = true,
			Type__c = 'Entity'
		);
		insert template;
		
		Process_Template_Step__c templateStep = new Process_Template_Step__c(
			Process_Template__c = template.Id,
			Assign_To_Role__c = 'Primary Advisor',
			Sequence__c = 1,
			Details__c = 'details'
		);
		insert templateStep;
		
		Account entity1 = new Account(
			Name = 'testentity'
		);
		insert entity1;
		
		MassCreateProcesses massCreate = new MassCreateProcesses();
		Date deadline = system.today().Adddays(5);
		massCreate.createProcesses(template.Id, new List<Id> { entity1.Id}, deadline);
		
		List<Process__c> processes = [SELECT Name, (Select Name FROM Process_Steps__r), Deadline__c 
			FROM Process__c WHERE Entity__c = :entity1.Id];
		System.assertEquals(1, processes.size());
		Process__c process1 = processes.get(0);
		system.assertEquals(deadline, process1.Deadline__c);
		System.assertEquals(1, process1.Process_Steps__r.size());
	}
}