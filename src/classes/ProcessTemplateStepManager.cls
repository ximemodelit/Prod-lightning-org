public with sharing class ProcessTemplateStepManager {

	private static final String ERROR_MESSAGE = 'Step must be assigned to a user, role, process owner or record owner.';
	
	public void beforeInsert(List<Process_Template_Step__c> steps) {
		validateAssignedToUserOrRole(steps);
	}
	
	public void beforeUpdate(List<Process_Template_Step__c> steps) {
		validateAssignedToUserOrRole(steps);
	}
	
	public void afterDelete(List<Process_Template_Step__c> steps) {
		deleteJunctionObjectsForSteps(steps);
	}
	
	public void validateAssignedToUserOrRole(List<Process_Template_Step__c> steps) {
		Set<Id> templateIds = new Set<Id>();
		for (Process_Template_Step__c step : steps) {
			templateIds.add(step.Process_Template__c);
		}
		Map<Id, Process_Template__c> templates = new Map<Id, Process_Template__c>([SELECT Type__c,
			Auto_Create_Tasks_Default__c
			FROM Process_Template__c WHERE Id IN :templateIds]);
		for (Process_Template_Step__c step : steps) {
			Boolean isStepAssigned = isStepAssigned(step);
			Boolean isRoleAssigned = false;
			
			if (isStepAssigned){
				Process_Template__c template = templates.get(step.Process_Template__c);
				isRoleAssigned = isRoleAssigned(step, template.Type__c);
			}
			
			if (!isStepAssigned || ! isRoleAssigned){
				step.addError(ERROR_MESSAGE);
			}
		}
	}
	
	public Boolean isStepAssigned(Process_Template_Step__c step){
		Integer assigneesCount = 0;
		if (step != null){
			if (step.Assign_to_User__c != null){
				assigneesCount++;
			}
			if (step.Assign_To_Role__c != null ||
				step.Assign_To_Case_Role__c != null ||
				step.Assign_To_Lead_Role__c != null ||
				step.Assign_To_Contact_Role__c != null ||
				step.Assign_To_Opportunity_Role__c != null){
				assigneesCount++;
			}
			
			if (step.Assign_To_Process_Owner__c){
				assigneesCount++;
			}
			if (step.Assign_to_Record_Owner__c){
				assigneesCount++;
			}
			
		}
		
		return assigneesCount == 1;
	}
	
	public Boolean isRoleAssigned(Process_Template_Step__c step, String templateType){
		Boolean result = true;
		
		if (step == null ){
			result = false;
		}
		
		if (result){
			if (step.Assign_To_Role__c != null ||
				step.Assign_To_Case_Role__c != null ||
				step.Assign_To_Lead_Role__c != null ||
				step.Assign_To_Contact_Role__c != null ||
				step.Assign_To_Opportunity_Role__c != null){
					
				if ((templateType == 'Entity' && step.Assign_To_Role__c == null) ||
					 (templateType == 'Case' && step.Assign_To_Case_Role__c == null) ||
					 (templateType == 'Lead' && step.Assign_To_Lead_Role__c == null) ||
					 (templateType == 'Contact' && step.Assign_To_Contact_Role__c == null) ||
					 (templateType == 'Opportunity' && step.Assign_To_Opportunity_Role__c == null)) {
					 
					 result = false;
				}	
			}	
		}
		
		return result;
	}
	public Boolean stepIsAssignedToUserOrRole(String templateType, Boolean autoCreateTasks, 
			Process_Template_Step__c step) { 			
		Boolean result = true;	
		Boolean isRoleAssigned = false;	
		Boolean isStepAssigned = false;
		
		if (autoCreateTasks){
			isStepAssigned = isStepAssigned(step);
			if (isStepAssigned){
				isRoleAssigned = isRoleAssigned(step, templateType);
			}
			
			if (!isStepAssigned || ! isRoleAssigned){
				result = false;
			}
		}
		return result;
	}

	public void populateSequences(List<Process_Template_Step__c> steps) {
		Set<Id> processTemplateIds = new Set<Id>();
		for (Process_Template_Step__c step : steps) {
			processTemplateIds.add(step.Process_Template__c);
		}
		AggregateResult[] results = [SELECT Process_Template__c TemplateId, MAX(Sequence__c) MaxSeq 
			FROM Process_Template_Step__c 
			WHERE Process_Template__c IN :processTemplateIds GROUP BY Process_Template__c ];
		Map<Id, Double> maxSequenceByTemplate = new Map<Id, Double>();
		for (AggregateResult result : results) {
			maxSequenceByTemplate.put((Id) result.get('TemplateId'), 
				(Double) result.get('MaxSeq'));
		}
		for (Process_Template_Step__c step : steps) {
			if (step.Sequence__c == null) {
				Double maxSequence = maxSequenceByTemplate.get(step.Process_Template__c);
				if (maxSequence == null) {
					maxSequence = 0;
				}
				step.Sequence__c = maxSequence + 1;
			}
		}
	}
	
	public void populatePredecessorSequences(List<Id> newStepIds) {
		List<Process_Template_Step__c> newSteps = [SELECT Process_Template__c, Sequence__c,
			(SELECT ParentStep__c, PredecessorStep__c, PredecessorStep__r.Sequence__c 
			FROM Template_Step_Junctions_Parent__r ORDER BY PredecessorStep__r.Sequence__c)
			FROM Process_Template_Step__c WHERE Id IN :newStepIds];
		Map<Id, Process_Template_Step__c> mapNewSteps = new Map<Id, Process_Template_Step__c>(
			newSteps);
		Set<Id> templateIds = new Set<Id>();
		for (Process_Template_Step__c step : newSteps) {
			templateIds.add(step.Process_Template__c);
		}
		List<Process_Template_Step__c> steps = [SELECT Process_Template__c, Sequence__c,
			(SELECT ParentStep__c, PredecessorStep__c, PredecessorStep__r.Sequence__c 
			FROM Template_Step_Junctions_Parent__r ORDER BY PredecessorStep__r.Sequence__c)
			FROM Process_Template_Step__c WHERE Process_Template__c IN :templateIds];
		Map<Id, Map<Id, Process_Template_Step__c>> templateMap = 
				new Map<Id, Map<Id, Process_Template_Step__c>>(); 
		for (Process_Template_Step__c step : newSteps) {
			if (step.Template_Step_Junctions_Parent__r == null) {
				step.Predecessor_Steps__c = null;
				continue;
			}
			List<String> sequences = new List<String>();
			for (Process_Template_Step_Junction__c junction : step.Template_Step_Junctions_Parent__r) {
				sequences.add(String.valueOf(junction.PredecessorStep__r.Sequence__c));
			}			
			step.Predecessor_Steps__c = String.join(sequences, ', ');
		}
		if (isProcessTemplateStepUpdateable()){
			update newSteps;
		}
	}
	
	public void deleteJunctionObjectsForSteps(List<Process_Template_Step__c> steps) {
		System.debug(steps);
		List<Process_Template_Step_Junction__c> junctions = [SELECT Id 
			FROM Process_Template_Step_Junction__c 
			WHERE PredecessorStep__c IN :steps];
		Boolean isDeleteable = Schema.sObjectType.Process_Template_Step_Junction__c.isDeletable();
		if (isDeleteable){
			delete junctions;
		}
	}
	
	private Boolean isProcessTemplateStepUpdateable(){
    	return (Schema.sObjectType.Process_Template_Step__c.isUpdateable() && Process_Template_Step__c.Predecessor_Steps__c.getDescribe().isUpdateable());
    }
}