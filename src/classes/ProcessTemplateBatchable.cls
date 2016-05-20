global class ProcessTemplateBatchable implements Database.Batchable<sObject> {
	
	global Database.QueryLocator start(Database.BatchableContext context) {
		return Database.getQueryLocator([SELECT Id FROM Process_Template__c WHERE Type__c = null]);
	}
	
	global void execute(Database.BatchableContext context, List<Process_Template__c> templates) {
		for (Process_Template__c template : templates) {
			template.Type__c = 'Entity';
		}
		if (isProcessTemplateUpdateable()){
			update templates;
		}
	}
	
	global void finish(Database.BatchableContext context) {
		
	}
	
	private Boolean isProcessTemplateUpdateable(){
    	return (Schema.sObjectType.Process_Template__c.isUpdateable() && Process_Template__c.Type__c.getDescribe().isUpdateable());
    }
}