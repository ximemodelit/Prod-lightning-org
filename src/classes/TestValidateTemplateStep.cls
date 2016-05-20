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
private class TestValidateTemplateStep {

    static testMethod void validateTemplateStep() 
    {
        Process_Template__c processTemplate = new Process_Template__c();
        processTemplate.Name = 'Test Template';
        processTemplate.Description__c = 'Test Template';
        processTemplate.Category__c = 'Sales';
        processTemplate.Type__c = 'Entity';
        Test.startTest();
        Database.insert(processTemplate);
        List<Process_Template__c> templates = Database.query('SELECT Id FROM Process_Template__c WHERE Name = \'Test Template\'');
        for(Process_Template__c tmpObj: templates)
        {
       		processTemplate = tmpObj;
        }
        
        List<Process_Template_Step__c> stepList = new List<Process_Template_Step__c>();
        Process_Template_Step__c templateStep = new Process_Template_Step__c();
        templateStep.Name = 'TEST Step 1';
        templateStep.Process_Template__c = processTemplate.Id;
        templateStep.Details__c = 'TEST';
        templateStep.Sequence__c = 1;
        templateStep.Assign_To_Role__c = 'Primary Advisor';
        stepList.add(templateStep);
        
        templateStep = new Process_Template_Step__c();
        templateStep.Name = 'TEST Step 1';
        templateStep.Process_Template__c = processTemplate.Id;
        templateStep.Details__c = 'TEST';
        templateStep.Sequence__c = 2;
        templateStep.Assign_To_Role__c = 'Primary Advisor';
        stepList.add(templateStep);
        
        templateStep = new Process_Template_Step__c();
        templateStep.Name = 'TEST Step 2';
        templateStep.Process_Template__c = processTemplate.Id;
        templateStep.Details__c = 'TEST';
        templateStep.Sequence__c = 1;
        templateStep.Assign_To_Role__c = 'Primary Advisor';
        stepList.add(templateStep);
        
        templateStep = new Process_Template_Step__c();
        templateStep.Name = 'TEST Step 2';
        templateStep.Process_Template__c = processTemplate.Id;
        templateStep.Details__c = 'TEST';
        templateStep.Sequence__c = 2;
        templateStep.Assign_To_Role__c = 'Primary Advisor';
        stepList.add(templateStep);
        
        for (Process_Template_Step__c tmpObj: stepList) 	
   		{
   			try
   			{
   				Database.insert(tmpObj);
   			}
   			catch (Exception ex){}
   		}
        
        List<Process_Template_Step__c> steps = [SELECT Id, Name, Sequence__c FROM Process_Template_Step__c WHERE Process_Template__c =: processTemplate.Id];
        Database.update(steps);
        
        Test.stopTest();
    }
}