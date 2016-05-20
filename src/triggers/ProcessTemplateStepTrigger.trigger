trigger ProcessTemplateStepTrigger on Process_Template_Step__c (before insert, before update, 
		before delete) {
	ProcessTemplateStepManager mgr = new ProcessTemplateStepManager();
	if (Trigger.isInsert) {
		mgr.validateAssignedToUserOrRole(Trigger.new);
		mgr.populateSequences(Trigger.new);
	}
	if (Trigger.isUpdate) {
		mgr.validateAssignedToUserOrRole(Trigger.new);
	}
	if (Trigger.isBefore && Trigger.isDelete) {
		mgr.deleteJunctionObjectsForSteps(Trigger.old); 
	}
}