@isTest
private class ProcessManager_T {

	static Account entity;
	static Process_Template__c template;
	static Process__c process1;
	static User user1;
	
	private static void setup() {
		entity = new Account(
			Name = 'testacc'
		);
		insert entity;
		
		template = new Process_Template__c(
			Name = 'testtemplate',
			Auto_Create_Tasks_Default__c = true,
			Type__c = 'Entity'
		);
		insert template;

		process1 = new Process__c(
			Name = 'testprocess',
			Auto_Create_Tasks__c = true,
			Process_Template__c = template.Id,
			Entity__c = entity.Id
		);
		insert process1;
		
		Profile profile = [Select Id from Profile where Name = 'System Administrator'];
		user1 = new User(Username= 'test9090@test.com', FirstName='Test User', LastName='9090', 
                             Email= 'test9090@test.com', Alias='t9090', CommunityNickname='test9090@test.com', 
                             IsActive=true, TimeZoneSidKey='America/Los_Angeles', 
                             LocaleSidKey='en_US', EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US', ProfileId = profile.Id); 
		insert user1;
	}

	@isTest 
	private static void test() {
		setup();
		Process__c process2 = new Process__c(
			Name = 'testprocess2',
			Process_Template__c = template.Id,
			Entity__c = entity.Id
		);
		insert process2;
		process2 = [SELECT Auto_Create_Tasks__c FROM Process__c WHERE Id = :process2.Id];
		System.assert(process2.Auto_Create_Tasks__c, 'Expected Auto_Create_Tasks__c to be true');
	}
	
	@isTest
	private static void stopProcess() {
		setup();
		
		Process_Step__c step1 = new Process_Step__c(
			Process__c = process1.Id,
			Sequence__c = 1,
			Status__c = ProcessManager.PROCESS_STEP_STATUS_OPEN
		);

		insert step1;
		ProcessManager mgr = new ProcessManager();
		mgr.stopProcess(process1.Id);
		
		Process__c tmpProcess = [Select Id, Status__c from Process__c where Id =: process1.Id];
		system.assertEquals('Cancelled', tmpProcess.Status__c);
		
		step1 = [SELECT Status__c FROM Process_Step__c WHERE Id = :step1.Id];
		system.assertEquals(ProcessManager.PROCESS_STEP_STATUS_CANCELLED, step1.Status__c);
		
	}
	
	@isTest
	private static void stopProcessNoSteps() {
		setup();

		ProcessManager mgr = new ProcessManager();
		mgr.stopProcess(process1.Id);
		
		Process__c tmpProcess = [Select Id, Status__c from Process__c where Id =: process1.Id];
		system.assertEquals('Not Started', tmpProcess.Status__c);
		
		system.assertEquals([Select id from Process_Step__c where Process__c =: process1.Id].size(), 0);
		
	}
	
	@isTest
	private static void stopProcessWitMoreThan100Steps() {
		setup();
		
		List<Process_Step__c> steps = new List<Process_Step__c>();
		for (Integer i = 0; i < 150; i++){
			Process_Step__c step = new Process_Step__c(
				Process__c = process1.Id,
				Sequence__c = i,
				Status__c = ProcessManager.PROCESS_STEP_STATUS_OPEN
			);
			steps.add(step);
		}
		
		insert steps;
		system.assertEquals([Select Id from Process_Step__c where Status__c =: ProcessManager.PROCESS_STEP_STATUS_OPEN ].size(), 150);
		
		// Cancell process1
		ProcessManager mgr = new ProcessManager();
		mgr.stopProcess(process1.Id);
		
		Process__c tmpProcess = [Select Id, Status__c from Process__c where Id =: process1.Id];
		system.assertEquals('Cancelled', tmpProcess.Status__c);
		
		steps = [SELECT Status__c FROM Process_Step__c WHERE Id IN : steps];
		system.assertEquals([Select Id from Process_Step__c where Status__c =: ProcessManager.PROCESS_STEP_STATUS_CANCELLED].size(), 150);
		
	}

	@isTest
	private static void insertProcessSteps() {
		setup();
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
		
		ProcessManager mgr = new ProcessManager();
		mgr.insertProcessSteps(template.Id, new List<Process__c> { process1 });
		
		List<Process_Step__c> steps = [SELECT Id FROM Process_Step__c 
			WHERE Process__c = :process1.Id];
		System.assertEquals(2, steps.size());
	}
	
	@isTest
	private static void insertProcessStepsAssigedToProcessOwner() {
		setup();
		Process_Template_Step__c templateStep1 = new Process_Template_Step__c(
			Process_Template__c = template.Id,
			Assign_To_Process_Owner__c = true,
			Sequence__c = 1,
			Details__c = 'details'
		);
		insert templateStep1;
		
		Process_Template_Step__c templateStep2 = new Process_Template_Step__c(
			Process_Template__c = template.Id,
			Assign_To_Process_Owner__c = true,
			Sequence__c = 1,
			Details__c = 'details'
		);
		insert templateStep2;
		
		ProcessManager mgr = new ProcessManager();
		mgr.insertProcessSteps(template.Id, new List<Process__c> { process1 });
		
		List<Process_Step__c> steps = [SELECT Id, Assigned_To__c FROM Process_Step__c 
			WHERE Process__c = :process1.Id];
		System.assertEquals(2, steps.size());
		system.assertEquals(steps.get(0).Assigned_To__c, UserInfo.getUserId());
		system.assertEquals(steps.get(1).Assigned_To__c, UserInfo.getUserId());
		
		// Verify that tasks were inserted and assigned to the process owner
		List<Task> tasks = [Select Id, OwnerId from Task where WhatId IN : steps];
		system.assertEquals(tasks.size(), 2);
		system.assertEquals(tasks.get(0).OwnerId, UserInfo.getUserId());
		system.assertEquals(tasks.get(1).OwnerId, UserInfo.getUserId());
	}
	
	@isTest
	private static void insertProcessStepsAssigedToRecordOwner() {
		setup();
		Process_Template_Step__c templateStep1 = new Process_Template_Step__c(
			Process_Template__c = template.Id,
			Assign_To_Process_Owner__c = true,
			Sequence__c = 1,
			Details__c = 'details'
		);
		insert templateStep1;
		
		Process_Template_Step__c templateStep2 = new Process_Template_Step__c(
			Process_Template__c = template.Id,
			Assign_To_Record_Owner__c = true,
			Sequence__c = 2,
			Details__c = 'details'
		);
		insert templateStep2;
		
		// Change the owner of the Entity
		entity.OwnerId = user1.Id;
		update entity;
		
		ProcessManager mgr = new ProcessManager();
		mgr.insertProcessSteps(template.Id, new List<Process__c> { process1 });
		
		List<Process_Step__c> steps = [SELECT Id, Assigned_To__c FROM Process_Step__c 
			WHERE Process__c = :process1.Id order by Sequence__c];
		System.assertEquals(2, steps.size());
		system.assertEquals(steps.get(0).Assigned_To__c, UserInfo.getUserId());
		system.assertEquals(steps.get(1).Assigned_To__c,user1.Id);
		
		// Verify that tasks were inserted and assigned to the process owner
		List<Task> tasks = [Select Id, OwnerId from Task where WhatId IN : steps];
		system.assertEquals(tasks.size(), 2);
		system.assertEquals(tasks.get(0).OwnerId, UserInfo.getUserId());
		system.assertEquals(tasks.get(1).OwnerId, user1.Id);
	}
	
	@isTest
	public static void setPredecessorsFromGenericSteps() {
		setup();
		Process_Step__c step1 = new Process_Step__c(
			Process__c = process1.Id,
			Sequence__c = 1,
			Status__c = ProcessManager.PROCESS_STEP_STATUS_OPEN
		);
		insert step1;

		Process_Step__c step2 = new Process_Step__c(
			Process__c = process1.Id,
			Sequence__c = 2,
			Status__c = ProcessManager.PROCESS_STEP_STATUS_OPEN
		);
		insert step2;
		
		Process_Step_Junction__c junction1 = new Process_Step_Junction__c(
			ParentStep__c = step1.Id,
			PredecessorStep__c = step2.Id
		); 
		insert junction1;
		
		GenericStep genericStep = new GenericStep();
		genericStep.Id = step1.Id;
		genericStep.PredecessorIds = step2.Id;

		ProcessManager mgr = new ProcessManager();
		mgr.setPredecessorsFromGenericSteps(new List<GenericStep>{ genericStep });

		List<Process_Step_Junction__c> junctions = [SELECT Id 
			FROM Process_Step_Junction__c];
		System.assertEquals(1, junctions.size());
	}
	
	@isTest
	public static void processStatusAndMasterTask(){
		setup();
		
		//Create for steps
		List<Process_Step__c> steps = new List<Process_Step__c>();
		Process_Step__c step1 = new Process_Step__c(
			Process__c = process1.Id,
			Sequence__c = 1,
			Status__c = ProcessManager.PROCESS_STEP_STATUS_OPEN
		);
		steps.add(step1);

		Process_Step__c step2 = new Process_Step__c(
			Process__c = process1.Id,
			Sequence__c = 2,
			Status__c = ProcessManager.PROCESS_STEP_STATUS_OPEN
		);
		steps.add(step2);
		
		Process_Step__c step3 = new Process_Step__c(
			Process__c = process1.Id,
			Sequence__c = 3,
			Status__c = ProcessManager.PROCESS_STEP_STATUS_OPEN
		);
		steps.add(step3);
		
		Process_Step__c step4 = new Process_Step__c(
			Process__c = process1.Id,
			Sequence__c = 4,
			Status__c = ProcessManager.PROCESS_STEP_STATUS_OPEN
		);
		steps.add(step4);
		
		insert steps;
		system.assertNotEquals(step1.Id, null);
		system.assertNotEquals(step2.Id, null);
		system.assertNotEquals(step3.Id, null);
		system.assertNotEquals(step4.Id, null);
		
		Test.startTest();
		// Query the process and ensure the status is Not started.
		
		process1 = [Select Id, Status__c, Total_Steps__c, Cancelled_Steps__c, NA_Steps__c, Completed_Steps__c from Process__c where id =: process1.Id];
		system.assertEquals(process1.Total_Steps__c, 4);
		system.assertEquals(process1.Cancelled_Steps__c, 0);
		system.assertEquals(process1.NA_Steps__c, 0);
		system.assertEquals(process1.Completed_Steps__c, 0);
		system.assertEquals(process1.Status__c, 'Not Started');
		
		// Query the master task, and ensure the stauts is Not Started.
		List<Task> masterTasks = [Select Id, status from Task where WhatId =: process1.Id];
		system.assertEquals(masterTasks.size(), 1);
		system.assertEquals(masterTasks.get(0).Status, 'Not Started');
		
		// Mark one step as N/a
		step1.Status__c = 'N/A';
		update step1;
		
		// Process status should be updated to In Progress
		process1 = [Select Id, Status__c, Total_Steps__c, Cancelled_Steps__c, NA_Steps__c, Completed_Steps__c from Process__c where id =: process1.Id];
		system.assertEquals(process1.Total_Steps__c, 4);
		system.assertEquals(process1.Cancelled_Steps__c, 0);
		system.assertEquals(process1.NA_Steps__c, 1);
		system.assertEquals(process1.Completed_Steps__c, 0);
		system.assertEquals(process1.Status__c, 'In Progress');
		
		// Master task status should be In Progress
		masterTasks = [Select Id, status from Task where WhatId =: process1.Id];
		system.assertEquals(masterTasks.size(), 1);
		system.assertEquals(masterTasks.get(0).Status, 'In Progress');
		
		
		// Mark one step as Completed
		step2.Status__c = 'Completed';
		update step2;
		
		// Process status should be updated to In Progress
		process1 = [Select Id, Status__c, Total_Steps__c, Cancelled_Steps__c, NA_Steps__c, Completed_Steps__c from Process__c where id =: process1.Id];
		system.assertEquals(process1.Total_Steps__c, 4);
		system.assertEquals(process1.Cancelled_Steps__c, 0);
		system.assertEquals(process1.NA_Steps__c, 1);
		system.assertEquals(process1.Completed_Steps__c, 1);
		system.assertEquals(process1.Status__c, 'In Progress');
		
		// Master task status should be In Progress
		masterTasks = [Select Id, status from Task where WhatId =: process1.Id];
		system.assertEquals(masterTasks.size(), 1);
		system.assertEquals(masterTasks.get(0).Status, 'In Progress');
		
		// Complete all the steps
		
		// Mark one step as N/a
		step3.Status__c = 'Completed';
		update step3;
		
		step4.Status__c = 'Completed';
		update step4;	
		
		// Process status should be updated to In Progress
		process1 = [Select Id, Status__c, Total_Steps__c, Cancelled_Steps__c, NA_Steps__c, Completed_Steps__c from Process__c where id =: process1.Id];
		system.assertEquals(process1.Total_Steps__c, 4);
		system.assertEquals(process1.Cancelled_Steps__c, 0);
		system.assertEquals(process1.NA_Steps__c, 1);
		system.assertEquals(process1.Completed_Steps__c, 3);
		system.assertEquals(process1.Status__c, 'Completed');
		
		// Master task status should be In Progress
		masterTasks = [Select Id, status from Task where WhatId =: process1.Id];
		system.assertEquals(masterTasks.size(), 1);
		system.assertEquals(masterTasks.get(0).Status, 'Completed');
		
		// Cancel one step
		step4.Status__c = 'Cancelled';
		update step4;	
		
		// Process status should be updated to In Progress
		process1 = [Select Id, Status__c, Total_Steps__c, Cancelled_Steps__c, NA_Steps__c, Completed_Steps__c from Process__c where id =: process1.Id];
		system.assertEquals(process1.Total_Steps__c, 4);
		system.assertEquals(process1.Cancelled_Steps__c, 1);
		system.assertEquals(process1.NA_Steps__c, 1);
		system.assertEquals(process1.Completed_Steps__c, 2);
		system.assertEquals(process1.Status__c, 'Cancelled');
		
		// Master task status should be In Progress
		masterTasks = [Select Id, status from Task where WhatId =: process1.Id];
		system.assertEquals(masterTasks.size(), 1);
		system.assertEquals(masterTasks.get(0).Status, 'Cancelled');
		Test.stopTest();
	}
	
	@isTest
	public static void editMasterTaskStatus(){
		setup();
		
		//Create for steps
		List<Process_Step__c> steps = new List<Process_Step__c>();
		Process_Step__c step1 = new Process_Step__c(
			Process__c = process1.Id,
			Sequence__c = 1,
			Status__c = ProcessManager.PROCESS_STEP_STATUS_OPEN
		);
		steps.add(step1);

		Process_Step__c step2 = new Process_Step__c(
			Process__c = process1.Id,
			Sequence__c = 2,
			Status__c = ProcessManager.PROCESS_STEP_STATUS_OPEN
		);
		steps.add(step2);
		
		Process_Step__c step3 = new Process_Step__c(
			Process__c = process1.Id,
			Sequence__c = 3,
			Status__c = ProcessManager.PROCESS_STEP_STATUS_OPEN
		);
		steps.add(step3);
		
		Process_Step__c step4 = new Process_Step__c(
			Process__c = process1.Id,
			Sequence__c = 4,
			Status__c = ProcessManager.PROCESS_STEP_STATUS_OPEN
		);
		steps.add(step4);
		
		insert steps;
		system.assertNotEquals(step1.Id, null);
		system.assertNotEquals(step2.Id, null);
		system.assertNotEquals(step3.Id, null);
		system.assertNotEquals(step4.Id, null);
		
		Test.startTest();
		// Query the process and ensure the status is Not started.
		
		process1 = [Select Id, Status__c, Total_Steps__c, Cancelled_Steps__c, NA_Steps__c, Completed_Steps__c from Process__c where id =: process1.Id];
		system.assertEquals(process1.Total_Steps__c, 4);
		system.assertEquals(process1.Cancelled_Steps__c, 0);
		system.assertEquals(process1.NA_Steps__c, 0);
		system.assertEquals(process1.Completed_Steps__c, 0);
		system.assertEquals(process1.Status__c, 'Not Started');
		
		// Query the master task, and ensure the stauts is Not Started.
		List<Task> masterTasks = [Select Id, status from Task where WhatId =: process1.Id];
		system.assertEquals(masterTasks.size(), 1);
		system.assertEquals(masterTasks.get(0).Status, 'Not Started');
		
		// update the master task status, and ensure you cannot set a status that differs from the process status
		masterTasks.get(0).Status = 'Complete';
		Boolean exceptionThrown = false;
		String exceptionMessage = '';
		
		try{
			update masterTasks;
		}catch (Exception ex){
			exceptionThrown = true;
			exceptionMessage = ex.getMessage();
		}
		
		system.assert(exceptionThrown);
		system.assert(exceptionMessage.contains('This task is tied to a Process, and you cannot change the status because it is controlled by the Process.'));
		Test.stopTest();
	}
	
	
	
	@isTest
	public static void processStepAndTaskStatusSync(){
		setup();
		
		//Create for steps
		List<Process_Step__c> steps = new List<Process_Step__c>();
		Process_Step__c step1 = new Process_Step__c(
			Process__c = process1.Id,
			Assigned_To__c = Userinfo.getUserId(),
			Sequence__c = 1,
			Status__c = ProcessManager.PROCESS_STEP_STATUS_OPEN
		);
		steps.add(step1);

		Process_Step__c step2 = new Process_Step__c(
			Process__c = process1.Id,
			Assigned_To__c = Userinfo.getUserId(),
			Sequence__c = 2,
			Status__c = ProcessManager.PROCESS_STEP_STATUS_OPEN
		);
		steps.add(step2);
		
		Process_Step__c step3 = new Process_Step__c(
			Process__c = process1.Id,
			Assigned_To__c = Userinfo.getUserId(),
			Sequence__c = 3,
			Status__c = ProcessManager.PROCESS_STEP_STATUS_OPEN
		);
		steps.add(step3);
		
		Process_Step__c step4 = new Process_Step__c(
			Process__c = process1.Id,
			Assigned_To__c = Userinfo.getUserId(),
			Sequence__c = 4,
			Status__c = ProcessManager.PROCESS_STEP_STATUS_OPEN
		);
		steps.add(step4);
		
		insert steps;
		system.assertNotEquals(step1.Id, null);
		system.assertNotEquals(step2.Id, null);
		system.assertNotEquals(step3.Id, null);
		system.assertNotEquals(step4.Id, null);
		
		Test.startTest();
		// Query the process and ensure the status is Not started.
		
		List<Task> tasks = [Select Id, Status, WhatId from Task where WhatId IN : steps];
		system.assertEquals(tasks.size(), 4);
		
		Map<Id, Task> stepToTask = new Map<Id,Task>();
		for (Task task : tasks){
			stepToTask.put(task.WhatId, task);
		}
		
		system.assertEquals(stepToTask.get(step1.Id).Status, 'Not Started');
		system.assertEquals(stepToTask.get(step2.Id).Status, 'Not Started');
		system.assertEquals(stepToTask.get(step3.Id).Status, 'Not Started');
		system.assertEquals(stepToTask.get(step4.Id).Status, 'Not Started');
		
		// update tasks to ensure they update the ste status
		stepToTask.get(step1.Id).Status = 'Completed';
		stepToTask.get(step2.Id).Status = 'Not Started';
		stepToTask.get(step3.Id).Status = 'In Progress';
		stepToTask.get(step4.Id).Status = 'Cancelled';
		update tasks;
		
		Map<Id, Process_Step__c>stepsMap = new Map<Id,Process_Step__c>([Select Id, Status__c, Completed_By__c, Completed_Date__c from Process_Step__c]);
		system.assertEquals(steps.size(), 4);
		system.assertEquals(stepsMap.get(step1.Id).Status__c, 'Completed');
		system.assertEquals(stepsMap.get(step2.Id).Status__c, 'Open');
		system.assertEquals(stepsMap.get(step3.Id).Status__c, 'Open');
		system.assertEquals(stepsMap.get(step4.Id).Status__c, 'N/A');
		Test.stopTest();
	}
	
}