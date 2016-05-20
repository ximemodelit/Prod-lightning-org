@isTest
private class CloneTemplateController_T {

	@isTest
	private static void test() {
		Process_Template__c template = new Process_Template__c(
			Name = 'testtemplate',
			Auto_Create_Tasks_Default__c = true,
			Type__c = 'Entity'
		);
		insert template;
		
		CloneTemplateController cont = new CloneTemplateController(
			new ApexPages.StandardController(template));	
		PageReference pr = Page.CloneTemplate;
		pr.getParameters().put('id', template.Id);
		Test.setCurrentPage(pr);
		cont.init();
		
	}
}