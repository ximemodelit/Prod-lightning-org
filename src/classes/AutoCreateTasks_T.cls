@isTest
private class AutoCreateTasks_T {

	static Account entity;
	static Process_Template__c template;
	static Process__c process1;

	private static void setup() {
		entity = new Account(
			Name = 'testacc'
		);
		insert entity;
		System.assertNotEquals(entity.Id, null);
		
		template = new Process_Template__c(
			Name = 'testtemplate',
			Auto_Create_Tasks_Default__c = true,
			Type__c = 'Entity'
		);
		insert template;
		System.assertNotEquals(template.Id, null);
		
		process1 = new Process__c(
			Name = 'testprocess',
			Auto_Create_Tasks__c = true,
			Process_Template__c = template.Id,
			Entity__c = entity.Id,
			Exclude_From_Auto_Create_Tasks__c = true
		);
		insert process1;
		System.assertNotEquals(process1.Id, null);
	}

	@isTest
	private static void test() {
		setup();
		Process_Template_Step__c templateStep1 = new Process_Template_Step__c(
			Process_Template__c = template.Id,
			Assign_To_Role__c = 'Primary Advisor',
			Sequence__c = 1,
			Details__c = 'details'
		);
		insert templateStep1;
		System.assertNotEquals(templateStep1.Id, null);
		
		Process_Template_Step__c templateStep2 = new Process_Template_Step__c(
			Process_Template__c = template.Id,
			Assign_To_Role__c = 'Primary Advisor',
			Sequence__c = 2,
			Details__c = 'details'
		);
		insert templateStep2;
		System.assertNotEquals(templateStep2.Id, null);
		
		Process_Template_Step_Junction__c junction = new Process_Template_Step_Junction__c(
			ParentStep__c = templateStep2.Id,
			PredecessorStep__c = templateStep1.Id
		); 
		insert junction;
		System.assertNotEquals(junction.Id, null);
		
		ProcessManager mgr = new ProcessManager();
		mgr.insertProcessSteps(template.Id, new List<Process__c> { process1 });
		
		process1.Exclude_From_Auto_Create_Tasks__c = false;
		update process1;
		System.assertNotEquals(process1.Id, null);
	}
}