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
private class TestProcessStepOperation {

    static testMethod void processStepOperation() 
    {

		Process_Template__c template = new Process_Template__c(
			Name = 'testtemplate',
			Auto_Create_Tasks_Default__c = true,
			Type__c = 'Entity'
		);
		insert template;
		System.assertNotEquals(template.Id, null);
		
        Date tmpDate = Date.today();
		Account entity = new Account(
			Name = 'testacc'
		);
		insert entity;
		System.assertNotEquals(entity.Id, null);
		
        Process__c tmpProcess = new Process__c();
        tmpProcess.Name = 'TEST PROCESS PKS';
        tmpProcess.Description__c = 'TEST PROCESS PKS';
        tmpProcess.Deadline__c = (tmpDate + 5);
        tmpProcess.Process_Template__c = template.Id;
        tmpProcess.Entity__c = entity.Id;
        
        Test.startTest();
        Database.insert(tmpProcess);
        System.assertNotEquals(tmpProcess.Id, null);
        
        tmpProcess = null;
        List<Process__c> processes = Database.query('SELECT name, id,Description__c, Process_Template__c,Entity__c,Deadline__c FROM Process__c WHERE name=\'TEST PROCESS PKS\'');
        for (Process__c tmpObj: processes)
        {
            tmpProcess = tmpObj;
        }
        Process_Step__c step = new Process_Step__c();
        step.Name = ' TEST PROCESS STEP 1';
        step.Status__c = 'Open';
        step.Process__c = tmpProcess.Id;
        step.Sequence__c = 1;
        
        Database.insert(step);
        System.assertNotEquals(step.Id, null);
        /*
        */
        Integer idx = 0;
        List<Process_Step__c> steps = Database.query('SELECT Id, Name,Completed_By__c,Status__c,Completed_Date__c FROM Process_Step__c WHERE Process__c = \'' + tmpProcess.Id + '\'');
        for (Process_Step__c tmpObj: steps)
        {
        	Task sfTask = new Task();
	        sfTask.OwnerId = Userinfo.getUserId(); //AssignedTo field for SF Task Obj
	        sfTask.ActivityDate = tmpProcess.Deadline__c;  //Deadline of SF Task Obj
	        sfTask.Subject = 'Process Step: ' + tmpProcess.Name;
	        sfTask.Status = 'Not Started';
	        sfTask.Description = tmpProcess.Description__c;
	        sfTask.WhatId = tmpProcess.Id;
	        sfTask.Priority = 'Normal';  
	        sfTask.Process_ID__c = tmpProcess.Id;
	        sfTask.Process_Step_ID__c = tmpObj.Id;
	       
	        Database.insert(sfTask);
            /**/
        }
        for (Process_Step__c tmpObj: steps)
        {
        	tmpObj.Status__c = 'Complete';
        }
        Database.update(steps);
        Test.stopTest();
    }
    
    static testMethod void processStepOperation1() 
    {
		Process_Template__c template = new Process_Template__c(
			Name = 'testtemplate',
			Auto_Create_Tasks_Default__c = true,
			Type__c = 'Entity'
		);
		insert template;
		System.assertNotEquals(template.Id, null);
		
		Account entity = new Account(
			Name = 'testacc'
		);
		insert entity;
		System.assertNotEquals(entity.Id, null);
		
        Date tmpDate = Date.today();
        Process__c tmpProcess = new Process__c();
        tmpProcess.Name = 'TEST PROCESS PKS';
        tmpProcess.Description__c = 'TEST PROCESS PKS';
        tmpProcess.Deadline__c = (tmpDate + 5);
        tmpProcess.Process_Template__c = template.Id;
        tmpProcess.Entity__c = entity.Id;
        
        Test.startTest();
        Database.insert(tmpProcess);
        System.assertNotEquals(tmpProcess.Id, null);
        
        tmpProcess = null;
        List<Process__c> processes = Database.query('SELECT name, id,Description__c, Process_Template__c,Entity__c,Deadline__c FROM Process__c WHERE name=\'TEST PROCESS PKS\'');
        for (Process__c tmpObj: processes)
        {
            tmpProcess = tmpObj;
        }
        Process_Step__c step = new Process_Step__c();
        step.Name = ' TEST PROCESS STEP 1';
        step.Status__c = 'Open';
        step.Process__c = tmpProcess.Id;
        step.Sequence__c = 1;
        
        Database.insert(step);
        System.assertNotEquals(step.Id, null);
        /*
        */
        Integer idx = 0;
        List<Process_Step__c> steps = Database.query('SELECT Id, Name,Completed_By__c,Status__c,Completed_Date__c FROM Process_Step__c WHERE Process__c = \'' + tmpProcess.Id + '\'');
        for (Process_Step__c tmpObj: steps)
        {
        	Task sfTask = new Task();
	        sfTask.OwnerId = Userinfo.getUserId(); //AssignedTo field for SF Task Obj
	        sfTask.ActivityDate = tmpProcess.Deadline__c;  //Deadline of SF Task Obj
	        sfTask.Subject = 'Process Step: ' + tmpProcess.Name;
	        sfTask.Status = 'Not Started';
	        sfTask.Description = tmpProcess.Description__c;
	        sfTask.WhatId = tmpProcess.Id;
	        sfTask.Priority = 'Normal';  
	        sfTask.Process_ID__c = tmpProcess.Id;
	        sfTask.Process_Step_ID__c = tmpObj.Id;
	       
	        Database.insert(sfTask);
            /**/
        }
        for (Process_Step__c tmpObj: steps)
        {
        	tmpObj.Status__c = 'N/A';
        }
        Database.update(steps);
        Test.stopTest();
    }
    
    static testMethod void processStepOperation2() 
    {
		Process_Template__c template = new Process_Template__c(
			Name = 'testtemplate',
			Auto_Create_Tasks_Default__c = true,
			Type__c = 'Entity'
		);
		insert template;
		System.assertNotEquals(template.Id, null);
		
		Account entity = new Account(
			Name = 'testacc'
		);
		insert entity;
		System.assertNotEquals(entity.Id, null);
        Date tmpDate = Date.today();
        Process__c tmpProcess = new Process__c();
        tmpProcess.Name = 'TEST PROCESS PKS';
        tmpProcess.Description__c = 'TEST PROCESS PKS';
        tmpProcess.Deadline__c = (tmpDate + 5);
        tmpProcess.Process_Template__c = template.Id;
        tmpProcess.Entity__c = entity.Id;
        
        Test.startTest();
        Database.insert(tmpProcess);
        System.assertNotEquals(tmpProcess.Id, null);
        tmpProcess = null;
        List<Process__c> processes = Database.query('SELECT name, id,Description__c, Process_Template__c,Entity__c,Deadline__c FROM Process__c WHERE name=\'TEST PROCESS PKS\'');
        for (Process__c tmpObj: processes)
        {
            tmpProcess = tmpObj;
        }
        Process_Step__c step = new Process_Step__c();
        step.Name = ' TEST PROCESS STEP 1';
        step.Status__c = 'N/A';
        step.Process__c = tmpProcess.Id;
        step.Sequence__c = 1;
        Database.insert(step);
        
        List<Process_Step__c> steps = Database.query('SELECT Id, Name,Completed_By__c,Status__c,Completed_Date__c FROM Process_Step__c WHERE Process__c = \'' + tmpProcess.Id + '\'');
        
        for (Process_Step__c tmpObj: steps)
        {
        	tmpObj.Status__c = 'Open';
        }
        Database.update(steps);
        Test.stopTest();
    }    
}