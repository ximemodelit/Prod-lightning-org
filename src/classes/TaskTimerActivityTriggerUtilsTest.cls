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
private class TaskTimerActivityTriggerUtilsTest {
	
	
	
    static testMethod void testInsert() {
        Task task = new Task(
		Subject = 'Test');
		insert task;
		system.assertNotEquals(task.Id, null);
		
		Task_Timer_Activity__c activity = new Task_Timer_Activity__c(
			Task_ID__c = task.Id,
			Task_Subject__c = task.Subject,
			Duration__c = 1,
			Description__c = 'Activity 1',
			Billable__c = true,
			Date__c = system.today()
		);
		
		insert activity;
		system.assertNotEquals(activity.Id, null);
		
		// Verify the task was updated
		task = [Select Id, Subject, Timer_Non_Billable_Hours__c, Timer_Billable_Hours__c, Timer_Total__c from Task where id =: task.Id];
		system.assertEquals(task.Timer_Non_Billable_Hours__c, null);
		system.assertEquals(task.Timer_Billable_Hours__c, 1);
		system.assertEquals(task.Timer_Total__c, 1);
		
		Task_Timer_Activity__c activity2 = new Task_Timer_Activity__c(
			Task_ID__c = task.Id,
			Task_Subject__c = task.Subject,
			Duration__c = 2,
			Description__c = 'Activity 2',
			Billable__c = true,
			Date__c = system.today()
		);
		insert activity2;
		system.assertNotEquals(activity2.Id, null);
		
		// Verify the task was updated
		task = [Select Id, Subject, Timer_Non_Billable_Hours__c, Timer_Billable_Hours__c, Timer_Total__c from Task where id =: task.Id];
		system.assertEquals(task.Timer_Non_Billable_Hours__c, null);
		system.assertEquals(task.Timer_Billable_Hours__c, 3);
		system.assertEquals(task.Timer_Total__c, 3);
		
		Task_Timer_Activity__c activity3 = new Task_Timer_Activity__c(
			Task_ID__c = task.Id,
			Task_Subject__c = task.Subject,
			Duration__c = 3,
			Description__c = 'Activity 3',
			Billable__c = false,
			Date__c = system.today()
		);
		
		insert activity3;
		system.assertNotEquals(activity3.Id, null);
		
		// Verify the task was updated
		task = [Select Id, Subject, Timer_Non_Billable_Hours__c, Timer_Billable_Hours__c, Timer_Total__c from Task where id =: task.Id];
		system.assertEquals(task.Timer_Non_Billable_Hours__c, 3);
		system.assertEquals(task.Timer_Billable_Hours__c, 3);
		system.assertEquals(task.Timer_Total__c, 6);
		
		Task_Timer_Activity__c activity4 = new Task_Timer_Activity__c(
			Task_ID__c = task.Id,
			Task_Subject__c = task.Subject,
			Duration__c = 1,
			Description__c = 'Activity 4',
			Billable__c = false,
			Date__c = system.today()
		);
		insert activity4;
		system.assertNotEquals(activity4.Id, null);
		
		// Verify the task was updated
		task = [Select Id, Subject, Timer_Non_Billable_Hours__c, Timer_Billable_Hours__c, Timer_Total__c from Task where id =: task.Id];
		system.assertEquals(task.Timer_Non_Billable_Hours__c, 4);
		system.assertEquals(task.Timer_Billable_Hours__c, 3);
		system.assertEquals(task.Timer_Total__c, 7);
		
    }
    
	static testMethod void testDelete() {
        Task task = new Task(
		Subject = 'Test');
		insert task;
		system.assertNotEquals(task.Id, null);
		
		List<Task_Timer_Activity__c> activities = new List<Task_Timer_Activity__c>();
		Task_Timer_Activity__c activity = new Task_Timer_Activity__c(
			Task_ID__c = task.Id,
			Task_Subject__c = task.Subject,
			Duration__c = 1,
			Description__c = 'Activity 1',
			Billable__c = true,
			Date__c = system.today()
		);
		activities.add(activity);
		
		Task_Timer_Activity__c activity2 = new Task_Timer_Activity__c(
			Task_ID__c = task.Id,
			Task_Subject__c = task.Subject,
			Duration__c = 2,
			Description__c = 'Activity 2',
			Billable__c = true,
			Date__c = system.today()
		);
		activities.add(activity2);
		
		Task_Timer_Activity__c activity3 = new Task_Timer_Activity__c(
			Task_ID__c = task.Id,
			Task_Subject__c = task.Subject,
			Duration__c = 3,
			Description__c = 'Activity 3',
			Billable__c = false,
			Date__c = system.today()
		);
		activities.add(activity3);
		
		Task_Timer_Activity__c activity4 = new Task_Timer_Activity__c(
			Task_ID__c = task.Id,
			Task_Subject__c = task.Subject,
			Duration__c = 1,
			Description__c = 'Activity 4',
			Billable__c = false,
			Date__c = system.today()
		);
		
		activities.add(activity4);
		insert activities;
		system.assertEquals([Select Id from Task_Timer_Activity__c].size(), 4);
		
		// Verify the task was updated
		task = [Select Id, Subject, Timer_Non_Billable_Hours__c, Timer_Billable_Hours__c, Timer_Total__c from Task where id =: task.Id];
		system.assertEquals(task.Timer_Non_Billable_Hours__c, 4);
		system.assertEquals(task.Timer_Billable_Hours__c, 3);
		system.assertEquals(task.Timer_Total__c, 7);
		
		// Delete activity 1
		delete activity;
		
		// Verify the task was updated
		task = [Select Id, Subject, Timer_Non_Billable_Hours__c, Timer_Billable_Hours__c, Timer_Total__c from Task where id =: task.Id];
		system.assertEquals(task.Timer_Non_Billable_Hours__c, 4);
		system.assertEquals(task.Timer_Billable_Hours__c, 2);
		system.assertEquals(task.Timer_Total__c, 6);
		
		delete activity3;
		// Verify the task was updated
		task = [Select Id, Subject, Timer_Non_Billable_Hours__c, Timer_Billable_Hours__c, Timer_Total__c from Task where id =: task.Id];
		system.assertEquals(task.Timer_Non_Billable_Hours__c, 1);
		system.assertEquals(task.Timer_Billable_Hours__c, 2);
		system.assertEquals(task.Timer_Total__c, 3);
		
		delete activity2;
		// Verify the task was updated
		task = [Select Id, Subject, Timer_Non_Billable_Hours__c, Timer_Billable_Hours__c, Timer_Total__c from Task where id =: task.Id];
		system.assertEquals(task.Timer_Non_Billable_Hours__c, 1);
		system.assertEquals(task.Timer_Billable_Hours__c, 0);
		system.assertEquals(task.Timer_Total__c, 1);
		
		delete activity4;
		// Verify the task was updated
		task = [Select Id, Subject, Timer_Non_Billable_Hours__c, Timer_Billable_Hours__c, Timer_Total__c from Task where id =: task.Id];
		system.assertEquals(task.Timer_Non_Billable_Hours__c, 0);
		system.assertEquals(task.Timer_Billable_Hours__c, 0);
		system.assertEquals(task.Timer_Total__c, 0);
    }
    
    static testMethod void testUpdate() {
        Task task = new Task(
		Subject = 'Test');
		insert task;
		system.assertNotEquals(task.Id, null);
		
		List<Task_Timer_Activity__c> activities = new List<Task_Timer_Activity__c>();
		Task_Timer_Activity__c activity = new Task_Timer_Activity__c(
			Task_ID__c = task.Id,
			Task_Subject__c = task.Subject,
			Duration__c = 1,
			Description__c = 'Activity 1',
			Billable__c = true,
			Date__c = system.today()
		);
		activities.add(activity);
		
		Task_Timer_Activity__c activity2 = new Task_Timer_Activity__c(
			Task_ID__c = task.Id,
			Task_Subject__c = task.Subject,
			Duration__c = 2,
			Description__c = 'Activity 2',
			Billable__c = true,
			Date__c = system.today()
		);
		activities.add(activity2);
		
		Task_Timer_Activity__c activity3 = new Task_Timer_Activity__c(
			Task_ID__c = task.Id,
			Task_Subject__c = task.Subject,
			Duration__c = 3,
			Description__c = 'Activity 3',
			Billable__c = false,
			Date__c = system.today()
		);
		activities.add(activity3);
		
		Task_Timer_Activity__c activity4 = new Task_Timer_Activity__c(
			Task_ID__c = task.Id,
			Task_Subject__c = task.Subject,
			Duration__c = 1,
			Description__c = 'Activity 4',
			Billable__c = false,
			Date__c = system.today()
		);
		
		activities.add(activity4);
		insert activities;
		system.assertEquals([Select Id from Task_Timer_Activity__c].size(), 4);
		
		// Verify the task was updated
		task = [Select Id, Subject, Timer_Non_Billable_Hours__c, Timer_Billable_Hours__c, Timer_Total__c from Task where id =: task.Id];
		system.assertEquals(task.Timer_Non_Billable_Hours__c, 4);
		system.assertEquals(task.Timer_Billable_Hours__c, 3);
		system.assertEquals(task.Timer_Total__c, 7);
		
		//update activity
		activity.duration__c = 10;
		update activity;
		
		// Verify the task was updated
		task = [Select Id, Subject, Timer_Non_Billable_Hours__c, Timer_Billable_Hours__c, Timer_Total__c from Task where id =: task.Id];
		system.assertEquals(task.Timer_Non_Billable_Hours__c, 4);
		system.assertEquals(task.Timer_Billable_Hours__c, 12);
		system.assertEquals(task.Timer_Total__c, 16);
		
		//update activity 3
		activity3.duration__c = 10;
		update activity3;
		
		// Verify the task was updated
		task = [Select Id, Subject, Timer_Non_Billable_Hours__c, Timer_Billable_Hours__c, Timer_Total__c from Task where id =: task.Id];
		system.assertEquals(task.Timer_Non_Billable_Hours__c, 11);
		system.assertEquals(task.Timer_Billable_Hours__c, 12);
		system.assertEquals(task.Timer_Total__c, 23);
		
		// update activity 2
		activity2.duration__c = 0.5;
		update activity2;
		
		// Verify the task was updated
		task = [Select Id, Subject, Timer_Non_Billable_Hours__c, Timer_Billable_Hours__c, Timer_Total__c from Task where id =: task.Id];
		system.assertEquals(task.Timer_Non_Billable_Hours__c, 11);
		system.assertEquals(task.Timer_Billable_Hours__c, 10.5);
		system.assertEquals(task.Timer_Total__c, 21.5);
		
		// update activity 4
		activity4.duration__c = 0.25;
		update activity4;
		
		// Verify the task was updated
		task = [Select Id, Subject, Timer_Non_Billable_Hours__c, Timer_Billable_Hours__c, Timer_Total__c from Task where id =: task.Id];
		system.assertEquals(task.Timer_Non_Billable_Hours__c,10.25);
		system.assertEquals(task.Timer_Billable_Hours__c, 10.5);
		system.assertEquals(task.Timer_Total__c, 20.75);
		
		// update billable from true to false
		activity.Billable__c = false;
		update activity;
		
		task = [Select Id, Subject, Timer_Non_Billable_Hours__c, Timer_Billable_Hours__c, Timer_Total__c from Task where id =: task.Id];
		system.assertEquals(task.Timer_Non_Billable_Hours__c,20.25);
		system.assertEquals(task.Timer_Billable_Hours__c, 0.5);
		system.assertEquals(task.Timer_Total__c, 20.75);
		
		// update billable from false to true
		activity4.Billable__c = true;
		update activity4;
		
		task = [Select Id, Subject, Timer_Non_Billable_Hours__c, Timer_Billable_Hours__c, Timer_Total__c from Task where id =: task.Id];
		system.assertEquals(task.Timer_Non_Billable_Hours__c,20);
		system.assertEquals(task.Timer_Billable_Hours__c, 0.75);
		system.assertEquals(task.Timer_Total__c, 20.75);
		
		// update billable and duration at the same time
		activity3.Billable__c = true;
		update activity3;
		
		task = [Select Id, Subject, Timer_Non_Billable_Hours__c, Timer_Billable_Hours__c, Timer_Total__c from Task where id =: task.Id];
		system.assertEquals(task.Timer_Non_Billable_Hours__c,10);
		system.assertEquals(task.Timer_Billable_Hours__c, 10.75);
		system.assertEquals(task.Timer_Total__c, 20.75);
    }
}