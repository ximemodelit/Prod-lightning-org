/**
 * This class contains unit tests for validating the behavior of HandleOwnerNotification
*/
@isTest
private class HandleOwnerNotification_T {
	
	private static void initData(){
		
		// Insert a process Template
		Process_Template__c template = new Process_Template__c(
			Name = 'testtemplate',
			Auto_Create_Tasks_Default__c = true,
			Type__c = 'Entity'
		);
		insert template;
		System.assertNotEquals(template.Id, null);
		
		// Insert an Account
		Account entity = new Account(
			Name = 'testacc'
		);
		insert entity;
		System.assertNotEquals(entity.Id, null);

		// Insert a process using the previously created acccont and template
        Process__c tmpProcess = new Process__c();
        tmpProcess.Name = 'TEST PROCESS PKS';
        tmpProcess.Deadline__c = Date.today().addDays(5);
        tmpProcess.Process_Template__c = template.Id;
        tmpProcess.Entity__c = entity.Id;
        insert tmpProcess;
        System.assertNotEquals(tmpProcess.Id, null);
		
		Process_Step__c step = new Process_Step__c();
        step.Name = 'TEST PROCESS STEP 1';
        step.Status__c = 'Open';
        step.Process__c = tmpProcess.Id;
        step.Sequence__c = 1;
        step.Assigned_To__c = Userinfo.getUserId();
        
		insert step;
        System.assertNotEquals(step.Id, null);
	}
    static testmethod void testOwnerNotification()
    {
    	initData();
        test.startTest();
        Process__c tmpProcess = [Select id from Process__c];
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(tmpProcess);
        HandleOwnerNotification controller = new HandleOwnerNotification(stdController);
        
        controller.handleMailNotification();
        
        // Verify that there were no errors
		system.assertNotEquals(controller.errors,null);
		system.assertEquals(controller.errors.size(),0);
		
		// Get the steps
		List<Process_Step__c> steps = [Select Id, Status__c from Process_Step__c];
		system.assertEquals(steps.size(),1);
		
		// Cancel the step
		ProcessActionsController.setCancelProcessStartedForTest();
		steps.get(0).Status__c = 'Cancelled';
		update steps.get(0);
		
		controller = new HandleOwnerNotification(stdController);
		controller.handleMailNotification();
		
		// Verify that there were errors
		system.assertNotEquals(controller.errors,null);
		system.assertEquals(controller.errors.size(),1);
		system.assertEquals(controller.errors.get(0),'This process is Cancelled, owners will not be notified.');
		
		// Complete the steps
		steps.get(0).Status__c = 'Completed';
		update steps.get(0);
		controller = new HandleOwnerNotification(stdController);
		controller.handleMailNotification();
        
        // Verify that there were errors
		system.assertNotEquals(controller.errors,null);
		system.assertEquals(controller.errors.size(),1);
		system.assertEquals(controller.errors.get(0),'This process is Completed, owners will not be notified.');
		
		update steps.get(0);
		// Instantiate the controller with a process that does not exist in the DB
		tmpProcess = new Process__c();
		stdController = new ApexPages.StandardController(tmpProcess);
		controller = new HandleOwnerNotification(stdController);
		
		controller.handleMailNotification();
		system.assertNotEquals(controller.errors,null);
		system.assertEquals(controller.errors.size(),1);
		system.assertEquals(controller.errors.get(0),'Process ID cannot be blank.');
        test.stopTest();
    }  
}