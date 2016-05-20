trigger TaskTrigger on Task (after delete, after insert, after update, before insert, before update, 
		before delete) {
	
	if (Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)) {
		new TaskManager().beforeInsertUpdate(Trigger.oldMap, Trigger.new); 
	}
	
	if (Trigger.isBefore && Trigger.isDelete) {
		System.debug('** in trigger');
		TaskManager taskManager = new TaskManager();
		taskManager.beforeDelete(Trigger.old);
	}

	if (Trigger.isAfter) {
		if (Trigger.isUpdate || Trigger.isInsert) {
 			new MeaningfulActivityManager.MeaningfulTaskManager(Trigger.oldMap, Trigger.newMap);
		}
		if (Trigger.isInsert) {
			new TaskManager().afterInsert(Trigger.newMap);
		}		
		if (Trigger.isUpdate) {
			new TaskManager().afterUpdate(Trigger.oldMap, Trigger.newMap);
		}		
		if (Trigger.isDelete) {
			new MeaningfulActivityManager.MeaningfulTaskManager(null, Trigger.oldMap);
			new TaskManager().afterDelete(Trigger.old);
		}
	}
}