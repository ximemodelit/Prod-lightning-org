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
private class UpdateTaskHistoryRecords_T {
	static void initData(){
		// Create custom setting to use task history
    	Settings__c settings = new Settings__c();
    	settings.Name = 'Default Settings';
    	settings.UseTaskHistory__c = true;
    	insert settings;
    	
		//Insert tasks
		List<Task> tasks = new List<Task>();
		for (Integer i = 0; i< 200; i++){
			Task t = new Task();
			t.subject='Test task ' + i;
			t.priority = 'High';
			t.status = 'Not Started';
			tasks.add(t);
		}
		insert tasks;
		
		//Verify tasks were inserted
		system.assertEquals([Select Id from Task].size(), 200);
		
		//Verify task history records were inserted
		List<Task_History__c> histories = [Select Id, Activity_Id__c from Task_History__c];
		system.assertEquals(histories.size(), 200);
		
		for (Task_History__c th : histories){
			system.assertNotEquals(th.Activity_Id__c, null);
			system.assertEquals(th.Activity_Id__c.length(), 18);
			th.Activity_ID__c = th.Activity_ID__c.substring(0,15);
		}
		
		update histories;
		
		//Verify records were updated and id set to the 15 characters version
		for (Task_History__c th : [Select Id, Activity_Id__c from Task_History__c]){
			system.assertNotEquals(th.Activity_Id__c, null);
			system.assertEquals(th.Activity_Id__c.length(), 15);
		}
		
	}
	
	static void initData2(){
		// Create custom setting to use task history
    	Settings__c settings = new Settings__c();
    	settings.Name = 'Default Settings';
    	settings.UseTaskHistory__c = true;
    	insert settings;
		
		//Insert tasks
		List<Task> tasks = new List<Task>();
		for (Integer i = 0; i< 200; i++){
			Task t = new Task();
			t.subject='Test task ' + i;
			t.priority = 'High';
			t.status = 'Not Started';
			tasks.add(t);
		}
		insert tasks;
		
		//Verify tasks were inserted
		system.assertEquals([Select Id from Task].size(), 200);
		
		//Verify task history records were inserted
		List<Task_History__c> histories = [Select Id, Activity_Id__c from Task_History__c order by Name asc];
		system.assertEquals(histories.size(), 200);
		
		for (Task_History__c th : histories){
			system.assertNotEquals(th.Activity_Id__c, null);
			system.assertEquals(th.Activity_Id__c.length(), 18);
		}
		
		for (Integer i = 0; i < 100; i++){
			Task_History__c th = histories.get(i);
			th.Activity_ID__c = th.Activity_ID__c.substring(0,15);
		}
		
		update histories;
		
		//Verify records were updated and id set to the 15 characters version
		for (Task_History__c th : [Select Id, Activity_Id__c from Task_History__c order by Name asc limit 100]){
			system.assertNotEquals(th.Activity_Id__c, null);
			system.assertEquals(th.Activity_Id__c.length(), 15);
		}
		
	}
	
    static testMethod void testUpdate() {
        initData();
        
        //Delete Securities
		Test.startTest();
		UpdateTaskHistoryRecords b = new UpdateTaskHistoryRecords();
		Database.executeBatch(b);
		Test.stopTest();
		
		//Verify records were updated and id set to the 18 characters version
		for (Task_History__c th : [Select Id, Activity_Id__c from Task_History__c]){
			system.assertNotEquals(th.Activity_Id__c, null);
			system.assertEquals(th.Activity_Id__c.length(), 18);
		}
		
    }
    
    static testMethod void testMixedUpdate() {
        initData2();
        
        //Delete Securities
		Test.startTest();
		UpdateTaskHistoryRecords b = new UpdateTaskHistoryRecords();
		Database.executeBatch(b);
		Test.stopTest();
		
		//Verify records were updated and id set to the 18 characters version
		for (Task_History__c th : [Select Id, Activity_Id__c from Task_History__c]){
			system.assertNotEquals(th.Activity_Id__c, null);
			system.assertEquals(th.Activity_Id__c.length(), 18);
		}
		
    }
}