@isTest
private class ProcessTemplateStepManager_T {

	@isTest
	private static void populatesSequence() {
		
		Process_Template__c template = new Process_Template__c(
			Name = 'template1',
			Type__c = 'Entity'
		);
		insert template;
		Process_Template_Step__c step = new Process_Template_Step__c(
			Process_Template__c = template.id,
			Name = 'somecrazyname',
			Assign_To_Role__c = 'Primary Advisor'
		); 
		insert step;
		step = [SELECT Sequence__c FROM Process_Template_Step__c WHERE Id = :step.Id];
		System.assertEquals(1, step.Sequence__c);
	}

	@isTest
	private static void populatePredecessorSequences() {
		Process_Template__c template = new Process_Template__c(
			Name = 'template1',
			Type__c = 'Entity'
		);
		insert template;
		Process_Template_Step__c step = new Process_Template_Step__c(
			Process_Template__c = template.id,
			Name = 'stepnametest2',
			Assign_To_Role__c = 'Primary Advisor',
			Sequence__c = 1
		); 
		insert step;
		Process_Template_Step__c step2 = new Process_Template_Step__c(
			Process_Template__c = template.id,
			Name = 'stepnametest3',
			Assign_To_Role__c = 'Primary Advisor',
			Sequence__c = 2
		); 
		insert step2;
		Process_Template_Step_Junction__c junction = new Process_Template_Step_Junction__c(
			ParentStep__c = step2.Id,
			PredecessorStep__c = step.Id
		);
		insert junction;
		step2 = [SELECT Predecessor_Steps__c FROM Process_Template_Step__c 
			WHERE Id = :step2.Id];
		System.assertEquals('1', step2.Predecessor_Steps__c);
	}	

}