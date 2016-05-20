trigger ProcessTemplateTrigger on Process_Template__c (before insert, before update) {
	if (Trigger.isBefore) {
		if (Trigger.isInsert) {
			ProcessTemplateManager mgr = new ProcessTemplateManager();
			mgr.beforeInsert(Trigger.new);
		}
		if (Trigger.isUpdate) {
			ProcessTemplateManager mgr = new ProcessTemplateManager();
			mgr.beforeUpdate(Trigger.new, Trigger.oldMap);
		}
	}
}