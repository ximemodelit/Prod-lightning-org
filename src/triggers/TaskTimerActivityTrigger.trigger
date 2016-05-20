trigger TaskTimerActivityTrigger on Task_Timer_Activity__c (after delete, after insert, after update) {
	if (trigger.isAfter){
		TaskTimerActivityTriggerUtils triggerUtils = new TaskTimerActivityTriggerUtils();
		if (trigger.isInsert){
			triggerUtils.afterInsert(trigger.new);	
		}
		
		if (trigger.isUpdate){
			triggerUtils.afterUpdate(trigger.new, trigger.oldMap);
		}
		
		if (trigger.isDelete){
			triggerUtils.afterDelete(trigger.old);
		}
	}
}