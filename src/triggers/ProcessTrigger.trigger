trigger ProcessTrigger on Process__c (before insert, before update, after insert, after update) {
	
	if (Trigger.isBefore && Trigger.isInsert) {
		ProcessManager mgr = new ProcessManager();
		mgr.beforeInsert(Trigger.new, null);
	}
	
	if (Trigger.isBefore && Trigger.isUpdate) {
		ProcessManager mgr = new ProcessManager();
		mgr.beforeUpdate(Trigger.new, Trigger.oldMap);
	}
	
/* shouldn't be needed anymore
	if (Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate)) {
		AutoCreateTasks.processSteps(Trigger.newMap.keySet());
	}
*/	
	if (Trigger.isAfter && Trigger.isInsert) { 
		ProcessManager mgr = new ProcessManager();
		mgr.afterInsert(Trigger.newMap);
	}
	
	if (Trigger.isAfter && Trigger.isUpdate) {
		ProcessManager mgr = new ProcessManager();
		mgr.afterUpdate(Trigger.oldMap, Trigger.newMap);
	}
}