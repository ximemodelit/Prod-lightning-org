/**
 * This class contains unit tests for validating the behavior of Apex classes HandleMassComplete
 *
 */

@isTest
private class HandleMassComplete_T {

    static testMethod void testHandleMassComplete() 
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

        Date tmpDate = Date.today();
        Process__c tmpProcess = new Process__c();
        tmpProcess.Name = 'TEST PROCESS PKS';
        tmpProcess.Deadline__c = (tmpDate + 5);
        tmpProcess.Process_Template__c = template.Id;
        tmpProcess.Entity__c = entity.Id;
        
        Test.startTest();
        Database.insert(tmpProcess);
        
        tmpProcess = null;
        List<Process__c> processes = Database.query('SELECT name, id, Process_Template__c,Entity__c FROM Process__c WHERE name=\'TEST PROCESS PKS\'');
        for (Process__c tmpObj: processes)
        {
            tmpProcess = tmpObj;
        }
        
        List<Process_Step__c> stepList = new List<Process_Step__c>(); 
        Process_Step__c step = new Process_Step__c();
        step.Name = ' TEST PROCESS STEP 1';
        step.Status__c = 'Open';
        step.Process__c = tmpProcess.Id;
        step.Sequence__c = 1;
        
        //Database.insert(step);
        stepList.add(step);
        
        step = new Process_Step__c();
        step.Name = ' TEST PROCESS STEP 2';
        step.Status__c = 'Open';
        step.Process__c = tmpProcess.Id;
        step.Sequence__c = 2;
        
        stepList.add(step);
        
        Database.insert(stepList);
        Integer idx = 0;
        List<Process_Step__c> steps = Database.query('SELECT Id, Name,Completed_By__c,Status__c,Completed_Date__c FROM Process_Step__c WHERE Process__c = \'' + tmpProcess.Id + '\'');
        Apexpages.currentPage().getParameters().put('retURL', tmpProcess.Id);
        ApexPages.StandardSetController setController = new ApexPages.StandardSetController(steps);
        setController.setSelected(steps);
        HandleMassComplete obj = new HandleMassComplete(setController);
        obj.firstItem();
        test.stopTest();
    }
}