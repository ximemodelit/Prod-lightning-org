@isTest
private class TestHandleProcessCreation 
{
    static testMethod void handleProcessCreation() 
    {
        Process_Template__c processTemplate = new Process_Template__c();
        processTemplate.Name = 'TEST PKS TEMPLATE-1';
        processTemplate.Description__c = 'TEST PKS TEMPLATE-1';
        processTemplate.Type__c = 'Entity';
        
        Test.startTest();
        Database.insert(processTemplate);
        System.assertNotEquals(processTemplate.Id, null);
        
        List<Process_Template__c> templates = Database.query('SELECT Id, Name FROM Process_Template__c WHERE name =\'TEST PKS TEMPLATE-1\'');  //
        for (Process_Template__c tmpObj: templates)
        {
            processTemplate = tmpObj;
        }
        
        Process_Template_Step__c templateStep = new Process_Template_Step__c();
        templateStep.Name = 'TEST PKS TEMPLATE STEP-1';
        templateStep.Sequence__c = 1;
        templateStep.Process_Template__c = processTemplate.Id;
        templateStep.Assign_To_Role__c = 'Primary Advisor';
        Database.insert(templateStep);
        System.assertNotEquals(templateStep.Id, null);
        
        Account tmpAccount = new Account();
        tmpAccount.Name = 'PKS TEST ACCOUNT';
        Database.insert(tmpAccount);
        List<Account> accounts = Database.query('SELECT Id, Name FROM account where name=\'PKS TEST ACCOUNT\'');
        for (Account tmpObj: accounts)
        {
            tmpAccount = tmpObj;
        }
        
        List<Process__c> processes = new List<Process__c>{};
        for (Integer i=0; i<4; i++)
        {
            Process__c tmpProcess = new Process__c();
            tmpProcess.Name = 'TEST Process: ' + (i);
            if (i == 2)
            {
                tmpProcess.Name = 'TEST Process: ' + (4 - i);
            }
            
            tmpProcess.Process_Template__c = processTemplate.Id;
            tmpProcess.Entity__c = tmpAccount.Id;
            tmpProcess.Deadline__c = Date.today();
            processes.add(tmpProcess);
        }
        
        Database.insert(processes);
        
        Test.stopTest();
        
    }
}