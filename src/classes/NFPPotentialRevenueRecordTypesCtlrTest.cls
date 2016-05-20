/*
 *Test class for NFPPotentialRevenueRecordTypesController
 *@author Ximena Lasserre
 *@since October 2015
 */
 @isTest
public class NFPPotentialRevenueRecordTypesCtlrTest {

    @testSetup static void setup(){
        //insert accounts
        List<Account> accountsList = new List<Account>();
        Id cliHousehold = null;
        Id cliBusiness = null;
        
        List<RecordTypeInfo> recordTypes = Account.SObjectType.getDescribe().getRecordTypeInfos();
        
        if (recordTypes != null && recordTypes.size() > 0){
            for (RecordTypeInfo rt : recordTypes){
                if (rt.isAvailable()){
                    if (rt.getName() == 'Client Business'){
                        cliBusiness = rt.getRecordTypeId();
                    }
                    
                    if (rt.getName() == 'Client Household'){
                        cliHousehold = rt.getRecordTypeId();
                    }
                }            
            }
        }
        
        if (cliBusiness != null){
            Account clientBusiness = new Account(Name = 'Business', RecordTypeId = cliBusiness);
            accountsList.add(clientBusiness);        
        }
        
        if (cliHousehold != null){
            Account clientHousehold = new Account(Name = 'Household', RecordTypeId = cliHousehold);
            accountsList.add(clientHousehold);
        }
        
        Account normalAcc = new Account(Name = 'Normal');
        accountsList.add(normalAcc);
        insert accountsList;
        
        //insert entity__c id
        Potential_Revenue_Fields_Ids__c potRevField = new Potential_Revenue_Fields_Ids__c();
        potRevField.Name = 'Potential_Revenue__c';
        potRevField.Entity_c__c = '00NG000000EvGI2MAN';
        insert potRevField;
    }
    
    static testmethod void testPotentialRevenueRecordTypesCtrlClientHousehold(){
        List<Account> accHouseholds = [SELECT Id, Name, RecordTypeId FROM Account WHERE Name = 'Household'];
        
        if (accHouseholds.size() == 1){
            Account accHousehold = accHouseholds.get(0);
            RecordType recordTypeHousehold = [SELECT Id, Name FROM RecordType WHERE Id = :accHousehold.RecordTypeId];
            PageReference currentPage = Page.NFPPotentialRevenueRecordTypes;
            Test.setCurrentPage(currentPage);
            
            ApexPages.currentPage().getParameters().put('entityRecType', recordTypeHousehold.Name); 
            ApexPages.currentPage().getParameters().put('entityName', accHousehold.Name); 
            ApexPages.currentPage().getParameters().put('entityId', accHousehold.Id); 
            NFPPotentialRevenueRecordTypesController controller = new NFPPotentialRevenueRecordTypesController();
            controller.loadRecordTypes();
            List<SelectOption> availableOpts = controller.getCorrectSelectList();
            
            
            // Get the list of available potential revenuew record types
            List<RecordTypeInfo> recordTypes = Potential_Revenue__c.SObjectType.getDescribe().getRecordTypeInfos();
            List<String> potentialRevenuewRecordTypes = new List<String>();
            if (recordTypes != null && recordTypes.size() > 0){
                for (RecordTypeInfo rt : recordTypes){
                    if (rt.isAvailable() && (rt.getName().equalsIgnoreCase('Individual Life Insurance') ||
                        rt.getName().equalsIgnoreCase('Individual Other Insurance') 
                        || rt.getName().equalsIgnoreCase('Wealth Mgmt'))){ 
                        potentialRevenuewRecordTypes.add(rt.getName());
                    }            
                }
            }
            system.assert(availableOpts.size() == potentialRevenuewRecordTypes.size(), 'The select list does not contain ' + potentialRevenuewRecordTypes.size() + ' options. It has ' + availableOpts.size() + ' options.');
            
            test.startTest();
            
            if (potentialRevenuewRecordTypes.size() > 0){
                //get potentieal revenue record type id
                Id potRevRecordTypeId = Schema.SObjectType.Potential_Revenue__c.getRecordTypeInfosByName().get(potentialRevenuewRecordTypes.get(0)).getRecordTypeId();
                controller.selectedPotentialRevenueRecordType = potRevRecordTypeId ;
                PageReference editPotentialRev = controller.openNewPotentialRevenueRecord();
                test.stopTest();
                String potentialRevenueKeyPref = Potential_Revenue__c.SObjectType.getDescribe().getKeyPrefix();
                
                Potential_Revenue_Fields_Ids__c potRevField = Potential_Revenue_Fields_Ids__c.getAll().values().get(0);
                    
                system.assert(editPotentialRev.getUrl().contains(potRevRecordTypeId), 'The current url does not have the expected potential revenue record type id');
                system.assert(editPotentialRev.getUrl().contains(accHousehold.Id), 'The current url does not have the expected account id');
                system.assert(editPotentialRev.getUrl().contains(potentialRevenueKeyPref), 'The current url does not have the expected potential revenue prefix');
                system.assert(editPotentialRev.getUrl().contains(accHousehold.Name), 'The current url does not have the expected account name');
                system.assert(editPotentialRev.getUrl().contains(potRevField.Entity_c__c), 'The current url does not have the expected entity field id');
            }
        }
    }
    
    static testmethod void testPotentialRevenueRecordTypesCtrlClientBusiness(){
        List<Account> accBusinesses = [SELECT Id, Name, RecordTypeId FROM Account WHERE Name = 'Business'];
        
        if (accBusinesses.size() == 1){
            Account accBusiness = accBusinesses.get(0);
            RecordType recordTypeHousehold = [SELECT Id, Name FROM RecordType WHERE Id = :accBusiness.RecordTypeId];
            PageReference currentPage = Page.NFPPotentialRevenueRecordTypes;
            Test.setCurrentPage(currentPage);
            
            ApexPages.currentPage().getParameters().put('entityRecType', recordTypeHousehold.Name); 
            ApexPages.currentPage().getParameters().put('entityName', accBusiness.Name); 
            ApexPages.currentPage().getParameters().put('entityId', accBusiness.Id); 
            NFPPotentialRevenueRecordTypesController controller = new NFPPotentialRevenueRecordTypesController();
            controller.loadRecordTypes();
            List<SelectOption> availableOpts = controller.getCorrectSelectList();
            
            
            // Get the list of available potential revenuew record types
            List<RecordTypeInfo> recordTypes = Potential_Revenue__c.SObjectType.getDescribe().getRecordTypeInfos();
            List<String> potentialRevenuewRecordTypes = new List<String>();
            if (recordTypes != null && recordTypes.size() > 0){
                for (RecordTypeInfo rt : recordTypes){
                    if (rt.isAvailable() && (rt.getName().equalsIgnoreCase('Individual Life Insurance') ||
                        rt.getName().equalsIgnoreCase('Group Benefits') ||
                        rt.getName().equalsIgnoreCase('Executive Benefits') ||
                        rt.getName().equalsIgnoreCase('Commercial Insurance') ||
                        rt.getName().equalsIgnoreCase('Wealth Mgmt') ||
                        rt.getName().equalsIgnoreCase('Retirement Plans'))){
                        potentialRevenuewRecordTypes.add(rt.getName());
                    }            
                }
            }
            system.assert(availableOpts.size() == potentialRevenuewRecordTypes.size(), 'The select list does not contain ' + potentialRevenuewRecordTypes.size() + ' options. It has ' + availableOpts.size() + ' options.');
            
            test.startTest();
            
            if (potentialRevenuewRecordTypes.size() > 0){
                //get potentieal revenue record type id
                Id potRevRecordTypeId = Schema.SObjectType.Potential_Revenue__c.getRecordTypeInfosByName().get(potentialRevenuewRecordTypes.get(0)).getRecordTypeId();
                controller.selectedPotentialRevenueRecordType = potRevRecordTypeId ;
                PageReference editPotentialRev = controller.openNewPotentialRevenueRecord();
                
                test.stopTest();
                String potentialRevenueKeyPref = Potential_Revenue__c.SObjectType.getDescribe().getKeyPrefix();
                
                Potential_Revenue_Fields_Ids__c potRevField = Potential_Revenue_Fields_Ids__c.getAll().values().get(0);
                    
                system.assert(editPotentialRev.getUrl().contains(potRevRecordTypeId), 'The current url does not have the expected potential revenue record type id');
                system.assert(editPotentialRev.getUrl().contains(accBusiness.Id), 'The current url does not have the expected account id');
                system.assert(editPotentialRev.getUrl().contains(potentialRevenueKeyPref), 'The current url does not have the expected potential revenue prefix');
                system.assert(editPotentialRev.getUrl().contains(accBusiness.Name), 'The current url does not have the expected account name');
                system.assert(editPotentialRev.getUrl().contains(potRevField.Entity_c__c), 'The current url does not have the expected entity field id');
            }
        }
    }
}