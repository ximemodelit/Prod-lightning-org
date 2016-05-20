@isTest
private class InitPredecessors_T {

	@isTest
	private static void test() {
		Account account1 = new Account(
			Name = 'testacc123'
		);
		insert account1;
		
		Process_Template__c template = new Process_Template__c(
			Type__c = 'Entity'
		);
		insert template;
		
		Process__c process1 = new Process__c(
			Process_Template__c = template.Id,
			Entity__c = account1.Id,
			name = 'test'
		);
		insert process1;
		
		Process_Step__c step1 = new Process_Step__c(
			Process__c = process1.Id,
			Sequence__c = 1
		);
		insert step1;
		
		Process_Step__c step2 = new Process_Step__c(
			Process__c = process1.Id,
			Sequence__c = 2
		);
		insert step2;

		InitPredecessors init = new InitPredecessors();
		init.initPredecessors(new List<Process__c> { process1 });
		
		List<Process_Step_Junction__c> junctions = [SELECT Id 
			FROM Process_Step_Junction__c];
		System.assertEquals(1, junctions.size());
	}

}