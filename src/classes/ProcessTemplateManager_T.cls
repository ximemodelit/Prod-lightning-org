@isTest
private class ProcessTemplateManager_T {

	@isTest
	private static void clonesRecords() {
		Process_Template__c template = new Process_Template__c(
			Name = 'test',
			Type__c = 'Entity'
		);
		insert template;
		
		Process_Template_Step__c templateStep = new Process_Template_Step__c(
			Process_Template__c = template.Id,
			Assign_To_Role__c = 'Primary Advisor',
			Sequence__c = 1,
			Details__c = 'details'
		);
		insert templateStep;

		Process_Template_Step__c templateStep2 = new Process_Template_Step__c(
			Process_Template__c = template.Id,
			Assign_To_Role__c = 'Primary Advisor',
			Sequence__c = 2,
			Details__c = 'details'
		);
		insert templateStep2;
		
		Process_Template_Step_Junction__c junction = new Process_Template_Step_Junction__c(
			ParentStep__c = templateStep2.Id,
			PredecessorStep__c = templateStep.Id
		);
		insert junction;

		ProcessTemplateManager mgr = new ProcessTemplateManager();
		mgr.deepClone(template.Id);
		
		List<Process_Template__c> templates = [SELECT Id, Name FROM Process_Template__c 
			WHERE Id != :template.Id];
		System.assertEquals(1, templates.size());
	}
	
	@isTest
	private static void stepWithoutUserOrRoleThrowsException() {
		Process_Template__c template = new Process_Template__c(
			Name = 'test',
			Type__c = 'Entity'
		);
		insert template;
		
		Process_Template_Step__c templateStep = new Process_Template_Step__c(
			Process_Template__c = template.Id,
			Sequence__c = 1,
			Details__c = 'details'
		);
		
		Boolean exceptionThrown = false;
		try {
			insert templateStep;
		}
		catch(DMLException e) {
			exceptionThrown = true;
		}
		System.assert(exceptionThrown, 'Expected a DML exception to be thrown for the need to have'
			+ ' a user or role assigned');
	}
	
	@isTest
	public static void setPredecessorsFromGenericSteps() {
		Process_Template__c template = new Process_Template__c(
			Name = 'test',
			Type__c = 'Entity'
		);
		insert template;

		Process_Template_Step__c templateStep1 = new Process_Template_Step__c(
			Process_Template__c = template.Id,
			Assign_To_Role__c = 'Primary Advisor',
			Sequence__c = 1,
			Details__c = 'details'
		);
		insert templateStep1;
		
		Process_Template_Step__c templateStep2 = new Process_Template_Step__c(
			Process_Template__c = template.Id,
			Assign_To_Role__c = 'Primary Advisor',
			Sequence__c = 1,
			Details__c = 'details'
		);
		insert templateStep2;
		
		Process_Template_Step_Junction__c junction1 = new Process_Template_Step_Junction__c(
			ParentStep__c = templateStep1.Id,
			PredecessorStep__c = templateStep2.Id
		); 
		insert junction1;
		
		GenericStep genericStep = new GenericStep();
		genericStep.Id = templateStep1.Id;
		genericStep.PredecessorIds = templateStep2.Id;

		ProcessTemplateManager mgr = new ProcessTemplateManager();
		mgr.setPredecessorsFromGenericSteps(new List<GenericStep>{ genericStep });

		List<Process_Template_Step_Junction__c> junctions = [SELECT Id 
			FROM Process_Template_Step_Junction__c];
		System.assertEquals(1, junctions.size());
	}
	
}