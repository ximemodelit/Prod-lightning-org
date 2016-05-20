/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class TaskTimerActivityListController_T {
	
	private static void initData(){
		Task task = new Task(Subject='Test');
		insert task;
		system.assertNotEquals(task.Id, null);
		
		List<Task_Timer_Activity__c>activities = new List<Task_Timer_Activity__c>();
		for (Integer i = 0; i < 20; i++){
			activities.add(new Task_Timer_Activity__c(Description__c = 'Test' + i, Date__c = system.today(), Task_ID__c = task.Id, Task_Subject__c = 'Subject'));
		}
		insert activities;
		system.assertEquals([Select Id from Task_Timer_Activity__c].size(), 20);
	}

    static testMethod void myUnitTest() {
        initData();
        Test.startTest();
        
        Task task = [Select id from Task limit 1];
        ApexPages.StandardController stdController = new ApexPages.StandardController(task);
       	TaskTimerActivitiesListController controller = new TaskTimerActivitiesListController(stdController);
       	
       	// It is the inital load, so previous should be disabled, and last buttons enabled
       	system.assertEquals(controller.getrecordsCount(), 20);
       	system.assertEquals(controller.getDisablePrevious(), true);
       	system.assertEquals(controller.getDisableNext(), false);
       	system.assertEquals(controller.getTotalPages(), 4);
       	system.assertEquals(controller.getPageNumber(), 1);
       	
       	// Retrieve the first page of records
       	List<Task_Timer_Activity__c>activities = controller.getActivities();
       	system.assertEquals(activities.size(), 5);
        
        // Go to next page
        controller.nextPage();
        system.assertEquals(controller.getPageNumber(), 2);
       	system.assertEquals(controller.getDisablePrevious(), false);
       	system.assertEquals(controller.getDisableNext(), false);
       	
       	controller.nextPage();
        system.assertEquals(controller.getPageNumber(), 3);
       	system.assertEquals(controller.getDisablePrevious(), false);
       	system.assertEquals(controller.getDisableNext(), false);
       	
       	controller.nextPage();
        system.assertEquals(controller.getPageNumber(), 4);
       	system.assertEquals(controller.getDisablePrevious(), false);
       	system.assertEquals(controller.getDisableNext(), true);
       	
       	controller.previousPage();
        system.assertEquals(controller.getPageNumber(), 3);
       	system.assertEquals(controller.getDisablePrevious(), false);
       	system.assertEquals(controller.getDisableNext(), false);
       	
       	controller.firstPage();
       	system.assertEquals(controller.getPageNumber(), 1);
       	system.assertEquals(controller.getDisablePrevious(), true);
       	system.assertEquals(controller.getDisableNext(), false);
        
        controller.lastPage();
       	system.assertEquals(controller.getPageNumber(), 5);
       	system.assertEquals(controller.getDisablePrevious(), false);
       	system.assertEquals(controller.getDisableNext(), true);
        
        // Delete a task
        ApexPages.currentPage().getParameters().put('activityId', activities.get(0).Id);
        controller.deleteTaskTimer();
        activities = [Select Id from Task_Timer_Activity__c where Id =: activities.get(0).Id];
        system.assertEquals(activities.size(), 0);
        
        // Create new
        String url = controller.getCreateNewURL();
        system.assertEquals(url, Page.TaskTimer.getURL() + '?Id=' + task.Id);
        
        controller.getIsTaskActivityTimerDeletable();
        Test.stopTest();
    }
}