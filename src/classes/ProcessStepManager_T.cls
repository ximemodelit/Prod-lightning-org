@isTest
private class ProcessStepManager_T {

	@isTest
	private static void populatesSequence() {
		
		Settings__c settings = new Settings__c(
			Name = 'default',
			UseTaskHistory__c = true
		);
		insert settings;
		
		Process_Template__c template = new Process_Template__c(
			Name = 'template1',
			Type__c = 'Entity'
		);
		insert template;
		Account account1 = new Account(
			Name = 'testaccount'
		);
		insert account1;
		Process__c process1 = new Process__c(
			Name = 'testprocess',
			Process_Template__c = template.Id,
			Entity__c = account1.Id
		);
		insert process1;
		Process_Step__c step = new Process_Step__c(
			Process__c = process1.id,
			Name = 'somecrazyname'
		); 
		insert step;
		step = [SELECT Sequence__c FROM Process_Step__c WHERE Id = :step.Id];
		System.assertEquals(1, step.Sequence__c);
	}
	
	@isTest
	private static void populatePredecessorSequences() {
		Process_Template__c template = new Process_Template__c(
			Name = 'template1',
			Type__c = 'Entity'
		);
		insert template;
		Account account1 = new Account(
			Name = 'testaccount'
		);
		insert account1;
		Process__c process1 = new Process__c(
			Name = 'testprocess',
			Process_Template__c = template.Id,
			Entity__c = account1.Id
		);
		insert process1;
		Process_Step__c step = new Process_Step__c(
			Process__c = process1.id,
			Name = 'testprocessstep1',
			Sequence__c = 1
		); 
		insert step;
		Process_Step__c step2 = new Process_Step__c(
			Process__c = process1.id,
			Name = 'testprocessstep2',
			Sequence__c = 2
		); 
		insert step2;
		Process_Step_Junction__c junction = new Process_Step_Junction__c(
			ParentStep__c = step2.Id,
			PredecessorStep__c = step.Id
		);
		insert junction;
		step2 = [SELECT Predecessor_Steps__c FROM Process_Step__c WHERE Id = :step2.Id];
		System.assertEquals('1', step2.Predecessor_Steps__c);
	}	
	
	@isTest
	private static void updateRelatedTasks() {
		Process_Template__c template = new Process_Template__c(
			Name = 'template1',
			Type__c = 'Entity'
		);
		insert template;
		system.assertNotEquals(template.Id, null);
		
		Account account1 = new Account(
			Name = 'testaccount'
		);
		insert account1;
		
		system.assertNotEquals(account1.Id, null);
		
		Process__c process1 = new Process__c(
			Name = 'testprocess',
			Process_Template__c = template.Id,
			Entity__c = account1.Id
		);
		insert process1;
		system.assertNotEquals(process1.id, null);
		
		List<Process_Step__c> steps = new List<Process_Step__c>();
		Process_Step__c step = new Process_Step__c(
			Process__c = process1.id,
			Name = 'testprocessstep1',
			Sequence__c = 1,
			Status__c = 'Open'
		); 
		steps.add(step);
		
		Process_Step__c step2 = new Process_Step__c(
			Process__c = process1.id,
			Name = 'testprocessstep2',
			Sequence__c = 2,
			Status__c = 'N/A'
		); 
		steps.add(step2);
		
		Process_Step__c step3 = new Process_Step__c(
			Process__c = process1.id,
			Name = 'testprocessstep3',
			Sequence__c = 2,
			Status__c = 'Completed'
		); 
		steps.add(step3);
		
		insert steps;
		system.assertNotEquals(steps.get(0).Id, null);
		system.assertNotEquals(steps.get(1).Id, null);
		system.assertNotEquals(steps.get(2).Id, null);
		
		List<Task> tasks = new List<Task>();
		Task task = new Task(
			Subject = 'Test Process Step 1',
			Status = 'Not Started',
			WhatId = step.Id
		);
		tasks.add(task);
		
		Task task2 = new Task(
			Subject = 'Test Process Step 1',
			Status = 'Not Started',
			WhatId = step2.Id
		);
		tasks.add(task2);
		
		Task task3 = new Task(
			Subject = 'Test Process Step 1',
			Status = 'Not Started',
			WhatId = step3.Id
		);
		tasks.add(task3);
		
		insert tasks;
		system.assertNotEquals(tasks.get(0).Id, null);
		system.assertNotEquals(tasks.get(1).Id, null);
		system.assertNotEquals(tasks.get(2).Id, null);
		
		// verify that the tasks status is not started
		system.assertEquals([Select Id from Task where Status = 'Not Started'].size(),3);
		
		// update the step status
		step.Status__c = 'N/A'; // Open -> N/A
		step2.Status__c = 'Completed'; // N/A -> Completed
		step3.Status__c = 'Open'; // Completed -> Open
		update steps;
		
		// Verify that the tasks were updated
		Map<Id, Task> taskMap = new Map<Id,Task>([Select Id, Status from Task]);
		
		// Step is assigned to task, step status is N/A, so tasks status should be Cancelled
		system.assertEquals(taskMap.get(task.Id).Status, 'Cancelled');
				
		// Step2 is assigned to task2, step2 status is Completed, so tasks status should be Cancelled
		system.assertEquals(taskMap.get(task2.Id).Status, 'Completed');
		
		// Step3 is assigned to task3, step3 status is Open, so tasks status should be Not Started
		system.assertEquals(taskMap.get(task3.Id).Status, 'Not Started');
		
	}	
	
}