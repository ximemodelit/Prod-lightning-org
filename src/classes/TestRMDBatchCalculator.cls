/*
 * Test class for RMDBatchCalculator class
 * @author Ximena Lasserre
 * @since Mar 2015
 */
 @isTest
public with sharing class TestRMDBatchCalculator {

	@testSetup static void setup(){
		
		//create the Account
		Account oneEntity = new Account(Name = 'One Entity');
        insert oneEntity;
        
        //create the contacts
        Contact c1 = new Contact();
        Contact c2 = new Contact();
        Contact c3 = new Contact();
        c1.Email = 'John@Doe.com';
        c1.LastName = 'Doe';
        c1.Birthdate = date.newInstance(1956, 4, 23);
        c2.Email = 'Jane@Doe.com';
        c2.LastName = 'Doe';
        c2.Birthdate = date.newInstance(1950, 9, 26); 
        c3.Email = 'Jim@Dune.com';
        c3.LastName = 'Dune';
        c3.Birthdate = date.newInstance(1940, 8, 28);
        insert c1; 
        insert c2; 
        insert c3;
        
        //create the RMD Factors
        RMD_Factors__c factor1 = new RMD_Factors__c();
        factor1.Age_EOY__c = 65; 
        factor1.Age_EOY_2__c = 59; 
        factor1.Calculation_Type__c = 'JOINT';
        factor1.RMD_Factor__c = 30.4;
        RMD_Factors__c factor2 = new RMD_Factors__c();
        factor2.Age_EOY__c = 63;
        factor2.Age_EOY_2__c = 57;
        factor2.Calculation_Type__c = 'JOINT';
        factor2.RMD_Factor__c = 31.3;
        RMD_Factors__c factor3 = new RMD_Factors__c();
        factor3.Age_EOY__c = 72;
        factor3.Calculation_Type__c = 'SINGLE';
        factor3.RMD_Factor__c = 15.5;
        RMD_Factors__c factor4 = new RMD_Factors__c();
        factor4.Age_EOY__c = 75;
        factor4.Calculation_Type__c = 'UNIFORM';
        factor4.RMD_Factor__c = 23.8;
        
        insert factor1;
        insert factor2;
        insert factor3;
        insert factor4;
        
		//create 2 assets and Liabilities 
		XLR8_Assets_Liabilities__c asset1 = new XLR8_Assets_Liabilities__c();
        asset1.Name = '2344';
        asset1.Entity__c = oneEntity.Id;
        asset1.RMD_Spouse__c = c1.Id;
        asset1.RMD_Member__c = c2.Id;
        insert asset1;
        
        RMD_Requirement__c req1 = new RMD_Requirement__c();
        req1.Financial_Account__c = asset1.Id;
        req1.Name = '2344-2015';
        req1.RMD_Override__c = 600.05;
        req1.RMD_Year__c = '2015'; //c1 59 c2 65
        req1.RMD_Calculation_Method__c = 'JOINT';
        req1.Value_Previous_EOY__c = 2000;
        insert req1;
        
        RMD_Requirement__c req2 = new RMD_Requirement__c();
        req2.Financial_Account__c = asset1.Id;
        req2.Name = '2344-2014';
        req2.RMD_Override__c = 200.05;
        req2.RMD_Year__c = '2014'; //c1 58 c2 64
        req2.RMD_Calculation_Method__c = 'UNIFORM';
        req2.Value_Previous_EOY__c = 2000;
        insert req2;
        
        XLR8_Assets_Liabilities__c asset2 = new XLR8_Assets_Liabilities__c();
        asset2.Name = '2345';
        asset2.Entity__c = oneEntity.Id;
        asset2.RMD_Member__c = c3.Id;
        insert asset2;
        
        RMD_Requirement__c req3 = new RMD_Requirement__c();
        req3.Financial_Account__c = asset2.Id;
        req3.Name = '2345-2013';
        req3.RMD_Override__c = 200.05;
        req3.RMD_Year__c = '2013'; //c1 56 c3 72
        req3.RMD_Calculation_Method__c = 'SINGLE';
        req3.Value_Previous_EOY__c = 2000;
        insert req3;
        
        RMD_Requirement__c req4 = new RMD_Requirement__c();
        req4.Financial_Account__c = asset2.Id;
        req4.Name = '2345-2015';
        req4.RMD_Override__c = 200.05;
        req4.RMD_Year__c = '2015'; //c1 59 c3 75
        req4.RMD_Calculation_Method__c = 'UNIFORM';
        req4.Value_Previous_EOY__c = 2000;
        insert req4;
	}
	
	@isTest static void TestRMDBatchCalculatorController(){
		
		Test.startTest();
		
		//instantiate the page
		PageReference pageRef = Page.RMDBatchCalculator;
		Test.setCurrentPage(pageRef);
		
		//instantiate the controller and calculate without setting the year
		RMDBatchCalculatorController batchCalcController = new RMDBatchCalculatorController();
		batchCalcController.calculateRMDAmount();
		
		//verify that there was an error
		system.assert(batchCalcController.errors.size() > 0, 'There were errors when not passing a year to the controller.');
		
		//set the year
		batchCalcController.year = '2015';
		batchCalcController.calculateRMDAmount();
		
		List<CronTrigger> ctBefore = [SELECT Id, TimesTriggered, NextFireTime 
                		    		    FROM CronTrigger
                		    		   WHERE CronJobDetail.Name LIKE 'RMD Calculator%'];
       
        //verify the batch has been scheduled        		    
        system.assert(ctBefore.size() == 1, 'There is no scheduled cron trigger.');  
        system.assert(ctBefore[0].TimesTriggered == 0, 'The batch has run or there is no batch scheduled.');  
        						      
        Test.stopTest(); 
        
	}
	
	@isTest static void TestRMDBatchCalculator(){
		
		Test.startTest();
		
		Id batchId = Database.executeBatch(new RMDAmountBatchCalculator('2015'));
        
		Test.stopTest();
		
		//verify the batch has already run
        List<RMD_Requirement__c> rmdReqs = [SELECT RMD_Member_Age_EOY__c, RMD_Spouse_Age_EOY__c, RMD_Year__c, 
       											   RMD_Factor__c, RMD_Last_Updated_Date__c, RMD_Calculated__c, RMD_Calculation_Method__c
       									      FROM RMD_Requirement__c
       									     WHERE RMD_Year__c = '2015'];
       									      
        for(RMD_Requirement__c req : rmdReqs){
        	system.assert(req.RMD_Factor__c != null, 'RMD Factor was not updated.');
        	system.assert(req.RMD_Last_Updated_Date__c != null, 'RMD Last Updated Date was not updated.');  
        	system.assert(req.RMD_Calculated__c != null, 'RMD Calculated was not updated.');  
        }	
        
        system.assert(rmdReqs.size() == 2, 'There were not 2 updated RMD Requirements');     
        
	}
	
}