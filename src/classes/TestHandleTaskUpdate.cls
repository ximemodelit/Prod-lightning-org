@isTest
private class TestHandleTaskUpdate
{
    static testMethod void testTaskUpdate()
    {
		Account entity = new Account(
			Name = 'testacc'
		);
		insert entity;
		System.assertNotEquals(entity.Id, null);
		
		Process_Template__c template = new Process_Template__c(
			Name = 'testtemplate',
			Auto_Create_Tasks_Default__c = true,
			Type__c = 'Entity'
		);
		insert template;
		System.assertNotEquals(template.Id, null);
		
        Date tmpDate = Date.today();
	    Process__c tmpProcess = new Process__c(
	        Name = 'TEST PROCESS PKS',
	        Deadline__c = (tmpDate + 5),
	        Process_Template__c = template.Id,
	        Entity__c = entity.Id
        );
        insert tmpProcess;
        System.assertNotEquals(tmpProcess.Id, null);
        
        Process_Step__c step = new Process_Step__c(
	        Name = 'TEST PROCESS STEP 1',
	        Status__c = 'Open',
	        Process__c = tmpProcess.Id,
	        Sequence__c = 1,
	        Assigned_To__c = Userinfo.getUserId()
        );
        insert step;
        System.assertNotEquals(step.Id, null);
        
        Task sfTask = new Task(
	        OwnerId = Userinfo.getUserId(),
	        ActivityDate = tmpProcess.Deadline__c,
	        Subject = 'Process: ' + tmpProcess.Name,
	        Status = 'Not Started',
	        Description = tmpProcess.Description__c,
	        WhatId = tmpProcess.Id,
	        Priority = 'Normal',   
	        Process_ID__c = tmpProcess.Id,
	        Process_Step_ID__c = step.id
        );
        insert sfTask;
        System.assertNotEquals(sfTask.Id, null);
        
        Test.startTest();
        
       	sfTask.Status = 'Completed';
        update sfTask;
        
        User objUser = [Select Id from User Limit 1];
        
        sfTask.OwnerID = objUser.Id;      
        
       	update sfTask;
        
        Test.stopTest();
    }
}