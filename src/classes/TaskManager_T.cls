@isTest
private class TaskManager_T {
    @isTest
    private static void meaningfulActivityIsCopied() {
        
        String meaningfulActivity = 'Last Estate Plan Review';
        
        Account account1 = new Account(
            Name = 'test'
        );
        insert account1;
        
        Task task1 = new Task(
            WhatId = account1.Id,
            Subject = 'test',
            ActivityDate = Date.today(),
            Meaningful_Activity__c = meaningfulActivity
        );
        
        insert task1;
        
        task1 = [SELECT Meaningful_Activity_Flat__c FROM Task WHERE Id = :task1.Id];
        System.assertEquals(meaningfulActivity, task1.Meaningful_Activity_Flat__c);
    }

    @isTest
    private static void activityDateIsCopied() {
        
        Date theDate = Date.today().addDays(-3);
        
        Account account1 = new Account(
            Name = 'test'
        );
        insert account1;
        
        Task task1 = new Task(
            WhatId = account1.Id,
            Subject = 'test',
            ActivityDate = theDate
        );
        
        insert task1;
        
        task1 = [SELECT Activity_Date__c FROM Task WHERE Id = :task1.Id];
        System.assertEquals(theDate, task1.Activity_Date__c);
        
    }

    @isTest
    private static void completionDateIsSetToToday() {
        
        Date theDate = Date.today().addDays(-3);
        
        Account account1 = new Account(
            Name = 'test'
        );
        insert account1;
        
        Task task1 = new Task(
            WhatId = account1.Id,
            Subject = 'test', 
            ActivityDate = theDate,
            Status = 'Completed'
        );
        
        insert task1;
        
        task1 = [SELECT Completion_Date__c FROM Task WHERE Id = :task1.Id];
        System.assertEquals(Date.today(), task1.Completion_Date__c);
        
    }

    @isTest
    private static void deletingMasterTaskIsRejected() {
        Process_Template__c template = new Process_Template__c(
            Name = 'test1',
            Type__c = 'Entity'
        );
        insert template;
        
        Account account1 = new Account(
            Name = 'test'
        );
        insert account1;

        Process__c process1 = new Process__c(
            Process_Template__c = template.Id,
            Name = 'test12',
            Entity__c = account1.Id
        );
        insert process1;
        
        Process_Step__c processStep = new Process_Step__c(
            Process__c = process1.Id,
            Name = 'test',
            Sequence__c = 1
        );
        insert processStep;
        
        List<Task> tasks = [SELECT Id FROM Task WHERE WhatId = :process1.Id];
        System.assertEquals(1, tasks.size());
        
        Database.DeleteResult result = Database.delete(tasks[0], false);
        System.assert(!result.isSuccess());
        System.assert(result.getErrors()[0].getMessage().contains('Cannot delete a Process Master Task'));
    }
    
    @isTest
    private static void descriptionIsModified() {
        Task task1 = new Task(
            Subject = 'test',
            ActivityDate = Date.today(),
            Description = 'abc'
        );
        insert task1;
        task1 = [Select Description FROM Task WHERE Id = :task1.Id];
        System.debug(task1.Description);
        System.assert(task1.Description.contains('abc'));
    }
    
    @isTest
    private static void createsTaskHistory() {
    	
    	// Create custom setting to use task history
    	Settings__c settings = new Settings__c();
    	settings.Name = 'Default Settings';
    	settings.UseTaskHistory__c = true;
    	insert settings;
    	
    	//Verify settings were inserted
    	system.assertNotEquals(settings.Id, null);
    	
        Task task1 = new Task(
            Subject = 'test',
            ActivityDate = Date.today(),
            Description = 'abc'
        );
        insert task1;

        List<Task_History__c> histories = [SELECT Id FROM Task_History__c];
        System.assertEquals(1, histories.size());
        
        // Turn off the settings to not to use task histories
        settings.useTaskHistory__c = false;
        update settings;
        
        Task task2 = new Task(
            Subject = 'test2',
            ActivityDate = Date.today(),
            Description = 'abc'
        );
        insert task2;
        
        // There should only be one entry in the table
        histories = [SELECT Id FROM Task_History__c];
        System.assertEquals(1, histories.size());
        
         // Turn on the settings to use task histories
        settings.useTaskHistory__c = true;
        update settings;
        
        TaskManager.taskHistoryRecordsCreated = false;
        Task task3 = new Task(
            Subject = 'teste',
            ActivityDate = Date.today(),
            Description = 'abc'
        );
        insert task3;
        
        // There should be two records in the table
        histories = [SELECT Id FROM Task_History__c];
        System.assertEquals(2, histories.size());
    }
    
     @isTest
    private static void testSubjectUpdate() {
        Task task1 = new Task(
            Subject = 'Subject',
            ActivityDate = Date.today(),
            Description = 'abc'
        );
        insert task1;
        system.assertNotEquals(task1.Id, null);
        
        Task_Timer_Activity__c taskTimer = new Task_Timer_Activity__c(
        	Task_ID__c = task1.Id,
        	Task_Subject__c = task1.Subject,
        	Date__c = system.today(),
        	Description__c = 'test'
        );
        
        insert taskTimer;
        system.assertNotEquals(taskTimer.Id, null);
        
        
        Test.startTest();
        taskTimer = [Select Id, Task_Subject__c from Task_Timer_Activity__c where Id =: taskTimer.Id];
        system.assertEquals(taskTimer.Task_Subject__c, 'Subject');
        
        task1.Subject = 'Subject Updated';
        update task1;
        
        
        taskTimer = [Select Id, Task_Subject__c, Name from Task_Timer_Activity__c where Id =: taskTimer.Id];
        system.assertEquals(taskTimer.Task_Subject__c, 'Subject Updated');
        Test.stopTest();
        
    }
}