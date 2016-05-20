@isTest
public class TestAssetsAndLiabilitiesTrigger {
    
    @testSetup static void setup(){
        
        Account oneEntity = new Account(Name = 'One Entity');
        insert oneEntity;
        
        //create the contacts
        Contact c1 = new Contact();
        Contact c2 = new Contact();
        Contact c3 = new Contact();
        c1.Email = 'John@Doe.com';
        c1.LastName = 'Doe';
        c2.Email = 'Jane@Doe.com';
        c2.LastName = 'Doe';
        c3.Email = 'Jim@Dune.com';
        c3.LastName = 'Dune';
        insert c1; 
        insert c2; 
        insert c3;
        
        //create an asset and liabilities with one RMD requirement
        XLR8_Assets_Liabilities__c assetWithRMDReq = new XLR8_Assets_Liabilities__c();
        assetWithRMDReq.Name = '2345';
        assetWithRMDReq.Entity__c = oneEntity.Id;
        assetWithRMDReq.RMD_Spouse__c = c1.Id;
        assetWithRMDReq.RMD_Member__c = c2.Id;
        insert assetWithRMDReq;
        
        RMD_Requirement__c req1 = new RMD_Requirement__c();
        req1.Financial_Account__c = assetWithRMDReq.Id;
        req1.Name = '2345-' + String.valueOf(date.today().year());
        req1.RMD_Override__c = 600.05;
        req1.RMD_Year__c = String.valueOf(date.today().year());
        req1.RMD_Calculation_Method__c = 'SINGLE';
        req1.Value_Previous_EOY__c = 2000;
        insert req1;
        
        //create one without RMD requirements
        XLR8_Assets_Liabilities__c assetWithoutRMDReq = new XLR8_Assets_Liabilities__c();
        assetWithoutRMDReq.Entity__c = oneEntity.Id;
        assetWithoutRMDReq.RMD_Spouse__c = c1.Id;
        assetWithoutRMDReq.RMD_Member__c = c2.Id;
        insert assetWithoutRMDReq;
    }
    
    @isTest static void testAssetsAndLiabilitiesTrigger(){
        
        Test.startTest();
        
        XLR8_Assets_Liabilities__c assetWithRMDReq = [SELECT Id, RMD_Spouse__c, RMD_Member__c
                                                      FROM XLR8_Assets_Liabilities__c
                                                      WHERE Total_RMD_Requirement_Records__c > 0 LIMIT 1];
        
        XLR8_Assets_Liabilities__c assetWithoutRMDReq = [SELECT Id, RMD_Spouse__c, RMD_Member__c
                                                      FROM XLR8_Assets_Liabilities__c
                                                      WHERE Total_RMD_Requirement_Records__c = 0 LIMIT 1];
        
        Contact c1 = [SELECT Id 
                      FROM Contact
                      WHERE Email = 'John@Doe.com' LIMIT 1];   
        Contact c2 = [SELECT Id 
                      FROM Contact
                      WHERE Email = 'Jane@Doe.com' LIMIT 1];
        Contact c3 = [SELECT Id 
                      FROM Contact
                      WHERE Email = 'Jim@Dune.com' LIMIT 1];                             
        system.debug('c1 ' + c1.Id + ' c2 ' + c2.Id + ' c3 ' + c3.Id);
                                                                
        //change the member and spouse on the one without rmd reqs
        assetWithRMDReq.RMD_Spouse__c = c3.Id;
        assetWithRMDReq.RMD_Member__c = c3.Id;
        try{
            update assetWithRMDReq;
        }catch(DmlException ex){
            system.debug('Could not update exception ' + assetWithRMDReq.RMD_Member__c + ' - ' + assetWithRMDReq.RMD_Spouse__c);
        }
        
        //change the member and spouse on the one with rmd reqs
        assetWithoutRMDReq.RMD_Spouse__c = c3.Id;
        assetWithoutRMDReq.RMD_Member__c = c3.Id;
        update assetWithoutRMDReq;
        
        Test.stopTest();
        
        
        XLR8_Assets_Liabilities__c finalAssetWithRMDReq = [SELECT Id, RMD_Spouse__c, RMD_Member__c
                                                           FROM XLR8_Assets_Liabilities__c
                                                           WHERE Total_RMD_Requirement_Records__c > 0 LIMIT 1];
        system.debug('before c2.Id -' + c2.Id + ' now-' + finalAssetWithRMDReq.RMD_Member__c);                                              
        system.assert(finalAssetWithRMDReq.RMD_Member__c != c3.Id, 'The member was changed, when it should have not.');
        system.assert(finalAssetWithRMDReq.RMD_Spouse__c != c3.Id, 'The spouse was changed, when it should have not.');
        
        system.assert(assetWithoutRMDReq.RMD_Spouse__c == c3.Id, 'The spouse was not changed, when it should have.');
        system.assert(assetWithoutRMDReq.RMD_Member__c == c3.Id, 'The member was not changed, when it should have.');
    }
}