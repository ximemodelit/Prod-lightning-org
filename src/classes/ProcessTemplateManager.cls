public with sharing 	class ProcessTemplateManager {

	public void beforeInsert(List<Process_Template__c> templates) {
		validateNew(templates);
	}
	
	public void beforeUpdate(List<Process_Template__c> templates, Map<Id, 
			Process_Template__c> oldMap) {
		validateChange(templates, oldMap);
	}
	
	private void validateNew(List<Process_Template__c> templates) {
		for (Process_Template__c template : templates) {
			if (template.Type__c == null) {
				template.addError('Please select the Type.');
			}
		}
	}
	
	private void validateChange(List<Process_Template__c> templates, 
			Map<Id, Process_Template__c> oldTemplateMap) {
		for (Process_Template__c template : templates) {
			Process_Template__c oldTemplate = oldTemplateMap.get(template.Id);
			if (template.Type__c != oldTemplate.Type__c && oldTemplate.Type__c != null) {
				template.addError('The Type cannot be changed.');
				return;
			}
		}
		List<Process_Template_Step__c> steps = [SELECT Assign_To_User__c, Assign_To_Role__c, 
			Assign_To_Lead_Role__c, Assign_To_Contact_Role__c, Assign_To_Opportunity_Role__c, 
			Assign_To_Case_Role__c, Process_Template__c, Assign_To_Process_Owner__c, Assign_To_Record_Owner__c
			FROM Process_Template_Step__c 
			WHERE Process_Template__c IN :templates];
		ProcessTemplateStepManager stepManager = new ProcessTemplateStepManager();
		Map<Id, Process_Template__c> templateMap = new Map<Id, Process_Template__c>(templates);
		for (Process_Template_Step__c step : steps) {
			Process_Template__c template = templateMap.get(step.Process_Template__c);
			if (!stepManager.stepIsAssignedToUserOrRole(template.Type__c, 
			template.Auto_Create_Tasks_Default__c, step)) {
				template.addError('If Auto Create Tasks is turned on, all steps must be assigned to'
				+ ' a user or role.');
			}
		}
	}
	
	
	public Id deepClone(String processTemplateId) {
		Process_Template__c template = [select Id, OwnerId, IsDeleted, Name, CreatedDate, 
			CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, Category__c, 
			Description__c, Auto_Create_Tasks_Default__c, Type__c,
			(select Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, 
			LastModifiedById, SystemModstamp, LastActivityDate, Assign_To_Role__c, 
			Assign_to_User__c, Details__c, Process_Template__c, Assign_To_Case_Role__c, 
			Assign_To_Contact_Role__c, Assign_To_Lead_Role__c, Assign_To_Opportunity_Role__c, 
			Assign_To_Process_Owner__c, Assign_to_Record_Owner__c,
			Sequence__c, Duration_In_Days__c
			from Process_Template_Steps__r)
			from Process_Template__c WHERE Id = :processTemplateId];
		Process_Template__c clonedTemplate = template.clone(false, true, false, false);
		String name = 'Copy of ' + clonedTemplate.Name;
		Integer nameCounter = 2;
		while (templateNameExists(name)) {
			name = 'Copy of ' + clonedTemplate.Name + ' ' + nameCounter;
			nameCounter++;
		}
		clonedTemplate.Name = name;
		clonedTemplate.OwnerId  = UserInfo.getUserId();
		if (isProcessTemplateCreateable()){
			insert clonedTemplate;
		}
		
		List<Process_Template_Step__c> clonedTemplateSteps = new List<Process_Template_Step__c>(); 
		for (Process_Template_Step__c step : template.Process_Template_Steps__r) {
			Process_Template_Step__c clonedStep = step.clone(false, true, false, false);
			clonedStep.Process_Template__c = clonedTemplate.Id;
			clonedStep.OwnerId = UserInfo.getUserId();
			clonedTemplateSteps.add(clonedStep);
		}
		if (isProcessTemplateStepCreateable()){
			insert clonedTemplateSteps;
		}
		setTemplateStepPredecessors(template.Process_Template_Steps__r, clonedTemplateSteps);
		return clonedTemplate.Id;
	}
	
	public void setPredecessorsFromGenericSteps(List<GenericStep> genericSteps) {
		Boolean isDeleteable = Schema.sObjectType.Process_Template_Step_Junction__c.isDeletable();
		List<Id> parentStepIds = new List<Id>();
		List<Process_Template_Step_Junction__c> junctions = 
			new List<Process_Template_Step_Junction__c>();
		for (GenericStep step : genericSteps) {
			System.debug(step);
			parentStepIds.add(step.Id);
			if (String.isEmpty(step.PredecessorIds)) {
				continue;
			}
			String[] predecessorIds = step.PredecessorIds.split(';');
			for (String predecessorId : predecessorIds) {
				Process_Template_Step_Junction__c junction = new Process_Template_Step_Junction__c(
					ParentStep__c = step.Id,
					PredecessorStep__c = predecessorId
				);
				junctions.add(junction);
			}
		}
		List<Process_Template_Step_Junction__c> junctionsToDelete = [SELECT Id 
			FROM Process_Template_Step_Junction__c
			WHERE ParentStep__c IN :parentStepIds];
		if (isDeleteable){
			delete junctionsToDelete;
		}
		
		if (!junctions.isEmpty()) {
			if (isProcessTemplateStepJunctionCreateable()){
				insert junctions;
			}
			
		}
	}
	
	private void setTemplateStepPredecessors(List<Process_Template_Step__c> oldSteps, 
			List<Process_Template_Step__c> newSteps) {
		Boolean isCreateable = Schema.sObjectType.Process_Template_Step_Junction__c.isCreateable();
		Map<Id, Id> newStepIdByOldStepId = new Map<Id, Id>();
		for (Integer i = 0; i < newSteps.size(); i++) {
			Process_Template_Step__c newStep = newSteps[i];
			Process_Template_Step__c oldStep = oldSteps[i];
			newStepIdByOldStepId.put(oldStep.Id, newStep.Id);
		}
		List<Process_Template_Step_Junction__c> junctions = [SELECT ParentStep__c, 
			PredecessorStep__c FROM Process_Template_Step_Junction__c 
			WHERE ParentStep__c IN :oldSteps];
		List<Process_Template_Step_Junction__c> newJunctions = 
			new List<Process_Template_Step_Junction__c>();
		for (Process_Template_Step_Junction__c junction : junctions) {
			newJunctions.add(new Process_Template_Step_Junction__c(
				ParentStep__c = newStepIdByOldStepId.get(junction.ParentStep__c),
				PredecessorStep__c = newStepIdByOldStepId.get(junction.PredecessorStep__c)
			));
		}
		if (isProcessTemplateStepJunctionCreateable()){
			insert newJunctions;
		}
	}
	
	private Boolean templateNameExists(String name) {
		return ![SELECT Id FROM Process_Template__c WHERE Name = :name].isEmpty();
	}
	
	public static Boolean isProcessTemplateCreateable(){
		return (Schema.sObjectType.Process_Template__c.isCreateable() && Process_Template__c.Category__c.getDescribe().isCreateable() &&
				Process_Template__c.Description__c.getDescribe().isCreateable() && Process_Template__c.Auto_Create_Tasks_Default__c.getDescribe().isCreateable() &&
				Process_Template__c.Type__c.getDescribe().isCreateable() );
	}
	
	public static Boolean isProcessTemplateStepCreateable(){
		return (Schema.sObjectType.Process_Template_Step__c.isCreateable() && Process_Template_Step__c.Process_Template__c.getDescribe().isCreateable());
	}
	
	public static Boolean isProcessTemplateStepJunctionCreateable(){
		return (Schema.sObjectType.Process_Template_Step_Junction__c.isCreateable() && Process_Template_Step_Junction__c.ParentStep__c.getDescribe().isCreateable() &&
		Process_Template_Step_Junction__c.PredecessorStep__c.getDescribe().isCreateable());
	}
}