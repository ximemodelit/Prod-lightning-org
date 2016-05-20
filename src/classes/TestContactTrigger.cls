/*
 * Test class for ContactTrigger
 * @author Ximena Lasserre
 * @since Mar 2015
 */
 @isTest
public with sharing class TestContactTrigger {

	@testSetup static void setup(){
        Account oneEntity = new Account(Name = 'One Entity');
        insert oneEntity;
        
        //create the contacts
        Contact c1 = new Contact();
        Contact c2 = new Contact();
        Contact c3 = new Contact();
        Contact c4 = new Contact();
        c1.Email = 'John@Doe.com';
        c1.LastName = 'Doe';
        c2.Email = 'Jane@Doe.com';
        c2.LastName = 'Doe';
        c3.Email = 'Jim@Dune.com';
        c3.LastName = 'Dune';
        c4.Email = 'Jan@Dune.com';
        c4.LastName = 'Dune';
        insert c1; 
        insert c2; 
        insert c3;
        insert c4;
        
        //create an asset and liabilities with one RMD requirement
        XLR8_Assets_Liabilities__c assetWithRMDReq = new XLR8_Assets_Liabilities__c();
        assetWithRMDReq.Name = '2345';
        assetWithRMDReq.Entity__c = oneEntity.Id;
        assetWithRMDReq.RMD_Spouse__c = c1.Id;
        assetWithRMDReq.RMD_Member__c = c2.Id;
        insert assetWithRMDReq;
        
        RMD_Requirement__c req1 = new RMD_Requirement__c();
        req1.Financial_Account__c = assetWithRMDReq.Id;
        req1.Name = '2345-2015';
        req1.RMD_Override__c = 600.05;
        req1.RMD_Year__c = '2015';
        req1.RMD_Calculation_Method__c = 'SINGLE';
        req1.Value_Previous_EOY__c = 2000;
        insert req1;
        
        //create one without RMD requirements
        XLR8_Assets_Liabilities__c assetWithoutRMDReq = new XLR8_Assets_Liabilities__c();
        assetWithoutRMDReq.Entity__c = oneEntity.Id;
        assetWithoutRMDReq.RMD_Spouse__c = c3.Id;
        assetWithoutRMDReq.RMD_Member__c = c4.Id;
        insert assetWithoutRMDReq;
    
    }
    
    @isTest static void testContactTrigger(){
        //query the contacts
        Contact c1 = [SELECT Id 
                      FROM Contact
                      WHERE Email = 'John@Doe.com' LIMIT 1];   
        Contact c2 = [SELECT Id 
                      FROM Contact
                      WHERE Email = 'Jane@Doe.com' LIMIT 1];
        Contact c3 = [SELECT Id 
                      FROM Contact
                      WHERE Email = 'Jim@Dune.com' LIMIT 1]; 
        Contact c4 = [SELECT Id 
                      FROM Contact
                      WHERE Email = 'Jan@Dune.com' LIMIT 1]; 
        try{
            delete c1;
        }catch(DmlException ex){
            System.debug(ex.getMessage());
        }  
        try{
            delete c2;
        }catch(DmlException ex){
            System.debug(ex.getMessage());
        }  
        try{
            delete c3;
        }catch(DmlException ex){
            System.debug(ex.getMessage());
        }  
        try{
            delete c4; 
        }catch(DmlException ex){
            System.debug(ex.getMessage());
        }              
        
        //query te contacts again after the deletion
        List<Contact> c1again = new List<Contact>();
        c1again = [SELECT Id 
                   FROM Contact
                   WHERE Email = 'John@Doe.com'];   
        List<Contact> c2again = new List<Contact>();
        c2again = [SELECT Id 
                   FROM Contact
                   WHERE Email = 'Jane@Doe.com'];
        List<Contact> c3again = new List<Contact>();
        c3again = [SELECT Id 
                   FROM Contact
                   WHERE Email = 'Jim@Dune.com']; 
        List<Contact> c4again = new List<Contact>();
        c4again = [SELECT Id 
                   FROM Contact
                   WHERE Email = 'Jan@Dune.com'];
                          
        system.assert(c1again[0] == c1, 'The contact has been deleted when it should have not.');  
        system.assert(c2again[0] == c2, 'The contact has been deleted when it should have not.');
        system.assert(c3again.size() == 0, 'The contact has not been deleted when it should have.');
        system.assert(c3again.size() == 0, 'The contact has not been deleted when it should have.');               
    }
}