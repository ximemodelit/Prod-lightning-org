trigger ProcessTemplateStepJunctionTrigger on Process_Template_Step_Junction__c (after delete, after insert, 
		after update) {
	if (Trigger.isInsert || Trigger.isUpdate) {
		List<Id> parentStepIds = new List<Id>();
		for (Process_Template_Step_Junction__c junction : Trigger.new) {
		  parentStepIds.add(junction.ParentStep__c);
		}
		ProcessTemplateStepManager mgr = new ProcessTemplateStepManager();
		mgr.populatePredecessorSequences(parentStepIds);
	} 

	if (Trigger.isDelete) {
		List<Id> parentStepIds = new List<Id>();
		for (Process_Template_Step_Junction__c junction : Trigger.old) {
			parentStepIds.add(junction.ParentStep__c);
		}
		ProcessTemplateStepManager mgr = new ProcessTemplateStepManager();
		mgr.populatePredecessorSequences(parentStepIds);
	} 
}