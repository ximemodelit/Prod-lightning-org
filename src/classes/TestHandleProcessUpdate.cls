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
private class TestHandleProcessUpdate {

    static testMethod void handleProcessUpdate() 
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
        System.assertNotEquals(tmpAccount.Id, null);
        List<Account> accounts = Database.query('SELECT Id, Name FROM account where name=\'PKS TEST ACCOUNT\'');
        for (Account tmpObj: accounts)
        {
            tmpAccount = tmpObj;
        }
        
        Date tmpDate = Date.today();
        Process__c tmpProcess = new Process__c();
        tmpProcess.Name = 'TEST PROCESS PKS';
        tmpProcess.Process_Template__c = processTemplate.Id;
        tmpProcess.Entity__c = tmpAccount.Id;
        tmpProcess.Deadline__c = (tmpDate + 5);

        Database.insert(tmpProcess);
        System.assertNotEquals(tmpProcess.Id, null);
        tmpProcess = null;
        List<Process__c> processes = Database.query('SELECT Id, Name, Deadline__c FROM Process__c WHERE Name = \'TEST PROCESS PKS\''); 
        
        for (Process__c tmpObj: processes)
        {
            tmpObj.Name = 'TEST PROCESS PKS 1';
            tmpObj.Deadline__c = tmpDate;
            tmpObj.Description__c = 'TEST PROCESS PKS 1';
            tmpProcess = tmpObj;
        }
        Database.update(tmpProcess);
        Test.stopTest();
    }
}