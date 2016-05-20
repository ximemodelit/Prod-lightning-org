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
private class TestRMDAssetAndLiabilityCalculatorCntrl {
	private static Map<String,Schema.RecordTypeInfo> rtMapByName = Schema.SObjectType.XLR8_Assets_Liabilities__c.getRecordTypeInfosByName();
	
	
	private static void initData(){
		// Insert an account
		Account account = TestUtility.createAccount('Test Account');
		insert account;
		system.assertNotEquals(account.Id, null);
		
		// Insert contacts
		List<Contact> contacts = new List<Contact>();
		Contact spouse = TestUtility.createContact('Pam', 'Concenter');
		spouse.Birthdate = date.newInstance(1956, 4, 23);
		contacts.add(spouse);
		Contact member = TestUtility.createContact('Michael', 'Concenter');		
		member.Birthdate = date.newInstance(1950, 9, 26); 
		contacts.add(member);
		insert contacts;
		system.assertNotEquals(spouse.Id, null);
		system.assertNotEquals(member.Id, null);
		
		// Insert RMD Factors
		List<RMD_Factors__c> factors = new List<RMD_Factors__c>();
        RMD_Factors__c factor1 = TestUtility.createFactor(65, 59, 'JOINT', 30.4);
        factors.add(factor1);
        RMD_Factors__c factor2 = TestUtility.createFactor(64, 58, 'SINGLE', 31.3);
        factors.add(factor2);
        RMD_Factors__c factor3 = TestUtility.createFactor(73, NULL, 'SINGLE', 15.5);
        factors.add(factor3);
        RMD_Factors__c factor4 = TestUtility.createFactor(75, NULL, 'UNIFORM', 23.8);
        factors.add(factor4);
        insert factors;
        system.assertNotEquals(factor1.Id, null);
        system.assertNotEquals(factor2.Id, null);
        system.assertNotEquals(factor3.Id, null);
        system.assertNotEquals(factor4.Id, null);
        
        // Insert A&L
		List<XLR8_Assets_Liabilities__c> assets = new List<XLR8_Assets_Liabilities__c>();
		XLR8_Assets_Liabilities__c asset2 = TestUtility.createAsset(account.Id);
		assets.add(asset2);
		XLR8_Assets_Liabilities__c asset3 = TestUtility.createAsset(account.Id);
		asset3.Name = '2344';
		asset3.Entity__c = account.Id;
        asset3.RMD_Spouse__c = spouse.Id;
        asset3.RMD_Member__c = member.Id;
		assets.add(asset3);
		insert assets;
		system.assertNotEquals(asset.Id, null);
		system.assertNotEquals(asset2.Id, null);
		system.assertNotEquals(asset3.Id, null);
        
        // Insert requirements
        List<RMD_Requirement__c> requiremetns = new List<RMD_Requirement__c>();
        RMD_Requirement__c req1 = new RMD_Requirement__c();
        req1.Financial_Account__c = asset3.Id;
        req1.Name = '2344-2015';
        req1.RMD_Year__c = '2015'; //c1 58 c2 64
        req1.RMD_Calculation_Method__c = 'JOINT';
        req1.Value_Previous_EOY__c = 1000;
        requiremetns.add(req1);
        
        RMD_Requirement__c req2 = new RMD_Requirement__c();
        req2.Financial_Account__c = asset3.Id;
        req2.Name = '2344-2015';
        req2.RMD_Year__c = '2015'; //c1 57 c2 63
        req2.RMD_Calculation_Method__c = 'JOINT';
        req2.Value_Previous_EOY__c = 2000;
        requiremetns.add(req2);
        insert requiremetns;
        system.assertNotEquals(req1.Id, null);
        system.assertNotEquals(req2.Id, null);
	}
	
    static testMethod void testErrors() {
        initData();
        
        Test.startTest();
       	
       	XLR8_Assets_Liabilities__c asset = new XLR8_Assets_Liabilities__c();
        ApexPages.StandardController stdController = new ApexPages.StandardController(asset);
        RMDAssetAndLiabilityCalculatorController controller = new RMDAssetAndLiabilityCalculatorController(stdController);
        
        // Calculate RMD without setting the asset
        system.assertEquals(controller.errors.size(), 1);
        system.assertEquals(controller.errors.get(0),'Asset And Liability not found.');
        
        // Fetch a retirement asset without requirements
        asset = [Select Id from XLR8_Assets_Liabilities__c where RMD_Member__c = NULL limit 1];
        stdController = new ApexPages.StandardController(asset);
        controller = new RMDAssetAndLiabilityCalculatorController(stdController);
        
        // The year is not specified. 
        controller.year = null;
        controller.calculateRMDAmount();
        system.assertEquals(controller.errors.size(), 1);
        system.assertEquals(controller.errors.get(0),'Year cannot be blank.');
        
        // Set the year, but the asset doesn't have requirements
        controller.year = '2015';
        // The year is specified. 
        controller.calculateRMDAmount();
        system.assertEquals(controller.errors.size(), 1);
        system.assertEquals(controller.errors.get(0),'No RMD Requirements were found');
        
         // Fetch a retirement asset with requirements
        asset = [Select Id from XLR8_Assets_Liabilities__c where RMD_Member__c != NULL limit 1];
        stdController = new ApexPages.StandardController(asset);
        controller = new RMDAssetAndLiabilityCalculatorController(stdController);
        
        // The asset has two requirements for the same year
        controller.year = '2015';
        controller.calculateRMDAmount();
        system.assertEquals(controller.errors.size(), 1);
        system.assertEquals(controller.errors.get(0),'This Retirment Asset & Liability has more than one RMD Requirement record for 2015' + 
							'. Please review your records to proceed with the calculation.');
        
        // Delete one requirement
        delete [select id from RMD_Requirement__c where Value_Previous_EOY__c = 1000];
        
        asset = [Select Id from XLR8_Assets_Liabilities__c where RMD_Member__c != NULL limit 1];
        stdController = new ApexPages.StandardController(asset);
        controller = new RMDAssetAndLiabilityCalculatorController(stdController);
        
        controller.year = String.valueOf(system.today().addYears(1).year());
        controller.calculateRMDAmount();
      	system.assertEquals(controller.errors.size(), 1);
        system.assertEquals(controller.errors.get(0),'Year must be a four digitis number between 2000 and current year.');
		
        // Verify that the amount was calculated
        controller.year = '2015';
        controller.calculateRMDAmount();
        system.assertEquals(controller.errors.size(), 0);
        RMD_Requirement__c requirement = [Select Id, RMD_Calculated__c from RMD_Requirement__c where Value_Previous_EOY__c = 2000];
        Decimal rmdCalculated = 2000 / 30.4;
        system.assertEquals(rmdCalculated, requirement.RMD_Calculated__c);
        				
        // delete the factors
        delete [Select id from RMD_Factors__c];
        controller.calculateRMDAmount();
        system.assertEquals(controller.errors.size(), 1);
        system.assertEquals(controller.errors.get(0),'There was no entry found for this RMD Member\'s age on the RMD Factor table.');
        
        Test.stopTest();
    }
}