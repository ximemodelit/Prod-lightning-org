@isTest
private class ProcessTaskManager_T {

	static Account account1;
	static Contact contact1;

	private static void setup() {
		account1 = new Account(
				Name = 'testacc'
		);
		insert account1;
		
		contact1 = new Contact(
			LastName = 'lastcontact-test',
			FirstName = 'asdf',
			AccountId = account1.Id
		);
		insert contact1;
	}
	
	@isTest
	private static void testEntity() {
		setup();
		
		Process_Template__c template = new Process_Template__c(
			Name = 'testtemplate',
			Auto_Create_Tasks_Default__c = true,
			Type__c = 'Entity'
		);
		insert template;

		Process__c process1 = new Process__c(
			Name = 'testprocess',
			Auto_Create_Tasks__c = true,
			Process_Template__c = template.Id,
			Entity__c = account1.Id
		);
		insert process1;

		ProcessTaskManager mgr = new ProcessTaskManager();
		// Save error: An unexpected error occurred. Please include this ErrorId if you contact support: 807432288-27579 (28584409)	ProcessTaskManager_T.cls	/XLR8Prod/src/classes	line 0	Force.com save problem
		// mgr.createMasterTasks(new Map<Id, Process__c> (process1));  

		Map<Id, Process__c> processMap = new Map<Id, Process__c>();
		processMap.put(process1.Id, process1);
		mgr.createMasterTasks(processMap);
		
		Task task1 = [SELECT WhoId FROM Task LIMIT 1];
		System.assertEquals(contact1.Id, task1.WhoId);
	}

	@isTest
	private static void testContact() {
		setup();
		
		Process_Template__c template = new Process_Template__c(
			Name = 'testtemplate',
			Auto_Create_Tasks_Default__c = true,
			Type__c = 'Contact'
		);
		insert template;

		Process__c process1 = new Process__c(
			Name = 'testprocess',
			Auto_Create_Tasks__c = true,
			Process_Template__c = template.Id,
			Contact__c = contact1.Id
		);
		insert process1;

		ProcessTaskManager mgr = new ProcessTaskManager();
		// Save error: An unexpected error occurred. Please include this ErrorId if you contact support: 807432288-27579 (28584409)	ProcessTaskManager_T.cls	/XLR8Prod/src/classes	line 0	Force.com save problem
		// mgr.createMasterTasks(new Map<Id, Process__c> (process1));  

		Map<Id, Process__c> processMap = new Map<Id, Process__c>();
		processMap.put(process1.Id, process1);
		mgr.createMasterTasks(processMap);
		
		Task task1 = [SELECT WhoId FROM Task LIMIT 1];
		System.assertEquals(contact1.Id, task1.WhoId);
	}

	@isTest
	private static void testOpportunity() {
		setup();
		
		Opportunity opp = new Opportunity(
			Name = 'testopp',
			AccountId = account1.Id,
			StageName = 'Closed/Won',
			CloseDate = Date.today(),
			Amount = 200
		);
		insert opp;
		
		Process_Template__c template = new Process_Template__c(
			Name = 'testtemplate',
			Auto_Create_Tasks_Default__c = true,
			Type__c = 'Opportunity'
		);
		insert template;

		Process__c process1 = new Process__c(
			Name = 'testprocess',
			Auto_Create_Tasks__c = true,
			Process_Template__c = template.Id,
			Opportunity__c = opp.Id
		);
		insert process1;

		ProcessTaskManager mgr = new ProcessTaskManager();
		// Save error: An unexpected error occurred. Please include this ErrorId if you contact support: 807432288-27579 (28584409)	ProcessTaskManager_T.cls	/XLR8Prod/src/classes	line 0	Force.com save problem
		// mgr.createMasterTasks(new Map<Id, Process__c> (process1));  

		Map<Id, Process__c> processMap = new Map<Id, Process__c>();
		processMap.put(process1.Id, process1);
		mgr.createMasterTasks(processMap);
		
		Task task1 = [SELECT WhoId FROM Task LIMIT 1];
		System.assertEquals(contact1.Id, task1.WhoId);
	}
}