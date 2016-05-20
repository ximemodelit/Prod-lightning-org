/**
 * Test class for XLR8PostInstallScript
 *
 *@author Ximena Lasserre
 *@since 2014-12
 *
 * revision 1.1 - Jason Landry - Support testing for population of Custom Setting for ReportIDs
 */
 
@isTest ()
public class PostInstallScriptTest {
    /*
     * Tests the post install script when there is no custom setting
     */
    static testmethod void postInstallScript(){
        
        Test.startTest();
     
        //Set the Install Script class for the test
        PostInstallScript myClass = new PostInstallScript();
        Test.testInstall(myClass, null);    
            
        test.stopTest();
        
        Map<String, Data_Mover_XLR8_Objects__c> dmObjects = Data_Mover_XLR8_Objects__c.getAll();
        system.assert(dmObjects.size() == 1, 'Data Mover XLR8 Objects map is not of size 1. It is ' + dmObjects.size());
    }
    
    /*
     * Test post install script when there is 
     * already a security custom setting
     */
    static testmethod void postInstallScriptDontInsert(){
        
        Data_Mover_XLR8_Objects__c security = new Data_Mover_XLR8_Objects__c();
        security.Name = 'Securities';
        security.API_Name__c = 'XLR8CS__XLR8_Securities__c';
        insert security;
        
        Map<String, Data_Mover_XLR8_Objects__c> dmObjectsBfr = Data_Mover_XLR8_Objects__c.getAll();
        system.assert(dmObjectsBfr.size() == 1, 'Data Mover XLR8 Objects map is not of size 1. It is ' + dmObjectsBfr.size());
        
        Test.startTest();
     
        //Set the Install Script class for the test
        PostInstallScript myClass = new PostInstallScript();
        Test.testInstall(myClass, null);    
            
        test.stopTest();
        
        Map<String, Data_Mover_XLR8_Objects__c> dmObjects = Data_Mover_XLR8_Objects__c.getAll();
        system.assert(dmObjects.size() == 1, 'Data Mover XLR8 Objects map is not of size 1. It is ' + dmObjects.size());
    }
}