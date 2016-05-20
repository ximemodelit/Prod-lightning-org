trigger EventTrigger on Event (after delete, after insert, after update, before insert, before update) {
	
	if (Trigger.isAfter) {
		if (Trigger.isUpdate || Trigger.isInsert) {
 			new MeaningfulActivityManager.MeaningfulEventManager(Trigger.oldMap, Trigger.newMap);
		}
		if (Trigger.isDelete) {
			new MeaningfulActivityManager.MeaningfulEventManager(null, Trigger.oldMap);
		}
		
	}
	
	if (Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)) {
		
		EventManager mgr = new EventManager();
		mgr.beforeInsertUpdate(Trigger.oldMap, Trigger.new); 
		new MeaningfulActivityManager.MeaningfulEventManager().closeEvents(trigger.new, trigger.oldMap);
	}
}