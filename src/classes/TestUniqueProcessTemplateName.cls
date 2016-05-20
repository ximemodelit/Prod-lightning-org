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
private class TestUniqueProcessTemplateName {

    static testMethod void uniqueProcessTemplateName() 
    {
        Process_Template__c processTemplate = new Process_Template__c();
        processTemplate.Name = 'Test Template';
        processTemplate.Description__c = 'Test Template';
        processTemplate.Category__c = 'Sales';
        processTemplate.Type__c = 'Entity';
        
        Process_Template__c processTemplate2 = null;
        
        Test.startTest();
        Database.insert(processTemplate);
        System.assertNotEquals(processTemplate.Id, null);
        //Database.insert(processTemplate2);
        
        processTemplate2 = new Process_Template__c();
        processTemplate2.Name = 'Test Template2';
        processTemplate2.Description__c = 'Test Template';
        processTemplate2.Category__c = 'Sales';
        processTemplate2.Type__c = 'Entity';
        Database.insert(processTemplate2);
        System.assertNotEquals(processTemplate2.Id, null);
        List<Process_Template__c> templates = Database.query('SELECT Id, Name FROM Process_Template__c WHERE Name=\'Test Template2\'');
        for(Process_Template__c template: templates)
        {
            template.Name = 'Test Template3';
        }
        Database.update(templates);
        
        
        Test.stopTest();
        
    }
}