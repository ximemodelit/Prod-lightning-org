@isTest
private class ProcessTemplateBatchable_T {
	
	@isTest
	private static void test() {
		Process_Template__c template = new Process_Template__c(
			Name = 'testtemplatename123',
			Type__c = 'Entity'
		);
		insert template;
		
		Test.startTest();
		
		ProcessTemplateBatchable b = new ProcessTemplateBatchable();
		Database.executeBatch(b);
		Test.stopTest();
		
		template = [SELECT Type__c FROM Process_Template__c WHERE Id = :template.Id];
		System.assertEquals('Entity', template.Type__c);
	}

}