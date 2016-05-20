trigger ProcessStepJunctionTrigger on Process_Step_Junction__c (after insert, after update, 
		after delete) {
	if (Trigger.isInsert || Trigger.isUpdate) {
		List<Id> parentStepIds = new List<Id>();
		for (Process_Step_Junction__c junction : Trigger.new) {
			parentStepIds.add(junction.ParentStep__c);
		}
		ProcessStepManager mgr = new ProcessStepManager();
		mgr.populatePredecessorSequences(parentStepIds);
	} 

	if (Trigger.isDelete) {
		List<Id> parentStepIds = new List<Id>();
		for (Process_Step_Junction__c junction : Trigger.old) {
			parentStepIds.add(junction.ParentStep__c);
		}
		ProcessStepManager mgr = new ProcessStepManager();
		mgr.populatePredecessorSequences(parentStepIds);
	} 

}