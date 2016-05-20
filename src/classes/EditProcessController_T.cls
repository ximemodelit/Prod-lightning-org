@isTest
private class EditProcessController_T {
	
	@isTest
	private static void test() {
		Account entity = new Account(
			Name = 'testacc'
		);
		insert entity;
		
		Process_Template__c template = new Process_Template__c(
			Name = 'testtemplate',
			Auto_Create_Tasks_Default__c = true,
			Type__c = 'Entity'
		);
		insert template;
		System.assertNotEquals(template.Id, null);

		Process__c process1 = new Process__c(
			Name = 'testprocess',
			Auto_Create_Tasks__c = true,
			Process_Template__c = template.Id,
			Entity__c = entity.Id
		);
		
		EditProcessController cont = new EditProcessController(
			new ApexPages.StandardController(process1));
		cont.selectTemplate(); 
		cont.save();
		cont.getProcessName();
	}
	
		@isTest
	private static void testContact() {
		Contact entity = new Contact(
			FirstName = 'Contact',
			LastName = 'Test'
		);
		insert entity;
		System.assertNotEquals(entity.Id, null);
		
		Process_Template__c template = new Process_Template__c(
			Name = 'testtemplate',
			Auto_Create_Tasks_Default__c = true,
			Type__c = 'Contact'
		);
		insert template;
		System.assertNotEquals(template.Id, null);
		
		Process__c process1 = new Process__c(
			Name = 'testprocess',
			Auto_Create_Tasks__c = true,
			Process_Template__c = template.Id,
			Contact__c = entity.Id
		);
		
		EditProcessController cont = new EditProcessController(
			new ApexPages.StandardController(process1));
		cont.selectTemplate(); 
		cont.save();
		System.assertEquals(cont.getTemplateType(), 'Contact');
		System.assertEquals([Select Id from Process__c].size(),1);
		System.assertEquals(cont.getProcessName(), 'testprocess');
	}
	
	@isTest
	private static void testLead() {
		Lead entity = new Lead(
			FirstName = 'Lead',
			LastName = 'Test',
			Company = 'Test Co',
			Status = 'Open'
		);
		insert entity;
		System.assertNotEquals(entity.Id, null);
		
		Process_Template__c template = new Process_Template__c(
			Name = 'testtemplate',
			Auto_Create_Tasks_Default__c = true,
			Type__c = 'Lead'
		);
		insert template;
		System.assertNotEquals(template.Id, null);
		
		Process__c process1 = new Process__c(
			Name = 'testprocess',
			Auto_Create_Tasks__c = true,
			Process_Template__c = template.Id,
			Lead__c = entity.Id
		);
		
		EditProcessController cont = new EditProcessController(
			new ApexPages.StandardController(process1));
		cont.selectTemplate(); 
		cont.save();

		System.assertEquals(cont.getTemplateType(), 'Lead');
		System.assertEquals([Select Id from Process__c].size(),1);
		System.assertEquals(cont.getProcessName(), 'testprocess');
	}
	
	@isTest
	private static void testCase() {
		Case entity = new Case(
			Status = 'Open',
			Origin = 'Web'
		);
		insert entity;
		System.assertNotEquals(entity.Id, null);
		
		Process_Template__c template = new Process_Template__c(
			Name = 'testtemplate',
			Auto_Create_Tasks_Default__c = true,
			Type__c = 'Case'
		);
		insert template;
		System.assertNotEquals(template.Id, null);
		
		Process__c process1 = new Process__c(
			Name = 'testprocess',
			Auto_Create_Tasks__c = true,
			Process_Template__c = template.Id,
			Case__c = entity.Id
		);
		
		EditProcessController cont = new EditProcessController(
			new ApexPages.StandardController(process1));
		cont.selectTemplate(); 
		cont.save();

		System.assertEquals(cont.getTemplateType(), 'Case');
		System.assertEquals([Select Id from Process__c].size(),1);
		System.assertEquals(cont.getProcessName(), 'testprocess');
	}
	
	@isTest
	private static void testOpportunity() {
		Opportunity entity = new Opportunity(
			Name = 'Oppty test',
			CloseDate = System.today(),
			StageName = 'Open'
		);
		insert entity;
		System.assertNotEquals(entity.Id, null);
		
		Process_Template__c template = new Process_Template__c(
			Name = 'testtemplate',
			Auto_Create_Tasks_Default__c = true,
			Type__c = 'Opportunity'
		);
		insert template;
		System.assertNotEquals(template.Id, null);
		
		Process__c process1 = new Process__c(
			Name = 'testprocess',
			Auto_Create_Tasks__c = true,
			Process_Template__c = template.Id,
			Opportunity__c = entity.Id
		);
		
		EditProcessController cont = new EditProcessController(
			new ApexPages.StandardController(process1));
		cont.selectTemplate(); 
		cont.save();

		System.assertEquals(cont.getTemplateType(), 'Opportunity');
		System.assertEquals([Select Id from Process__c].size(),1);
		System.assertEquals(cont.getProcessName(), 'testprocess');
	}
}