trigger ProcessStepTrigger on Process_Step__c (before insert, before update, before delete,
	after update) {
	if (Trigger.isBefore && Trigger.isInsert) {
		ProcessStepManager mgr = new ProcessStepManager();
		mgr.populateSequences(Trigger.new);
		mgr.validateUniqueName(Trigger.new);
	}
	if (Trigger.isBefore && Trigger.isUpdate) {
		ProcessStepManager mgr = new ProcessStepManager();
		mgr.populateSequences(Trigger.new);
		mgr.handleStatusChange(Trigger.new, Trigger.oldMap);
		mgr.validateUniqueName(Trigger.new);
	}
	if (Trigger.isBefore && Trigger.isDelete) {
		ProcessStepManager mgr = new ProcessStepManager();
		mgr.deleteJunctionObjectsForSteps(Trigger.old);
	}
	if (Trigger.isAfter && Trigger.isUpdate) {
		ProcessStepManager mgr = new ProcessStepManager();
		mgr.updateRelatedTasks(Trigger.newMap, Trigger.oldMap);
		mgr.autoCreateTasks(Trigger.new);
	}
}