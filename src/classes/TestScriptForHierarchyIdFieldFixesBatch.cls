/**
 * Test class for ScriptForHierarchyIdFieldFixesBatch
 *
 *@author Ximena Lasserre
 *@since 2014-12
 */
@IsTest
private class TestScriptForHierarchyIdFieldFixesBatch{
 
    /*
     * Tests the post install script
     */
    static testmethod void testBatch(){
        
        Account a1 = new Account();
        a1.Name = 'TestX1';
        insert a1;      
        a1.Hierarchy_Id_As_Text__c = String.valueOf(a1.Id).substring(0, 15);
        update a1;
        
        Account a2 = new Account();
        a2.Name = 'TestX2';
        insert a2;
        a2.Hierarchy_Id_As_Text__c = String.valueOf(a2.Id).substring(0, 15);
        update a2;
        
        Account a3 = new Account();
        a3.Name = 'TestX3';
        insert a3;
        
        Account a4 = new Account();
        a4.Name = 'TestX4';
        insert a4;
                
        Account a5 = new Account();
        a5.Name = 'TestX5';
        insert a5;
        
        Id result5 = a5.Id;
        
        Account a6 = new Account();
        a6.Name = 'TestX6';
        insert a6;
        
        
        Test.startTest();
        Database.executeBatch(new ScriptForHierarchyIdFieldFixesBatch ());
        Test.stopTest();
        
        //Check that there are no accounts where Hierarchy_Id_As_Text__c is null after executing the batch
        System.assertEquals(0, Database.countQuery('SELECT COUNT() FROM Account WHERE Hierarchy_Id_As_Text__c = NULL'));
                    
        //Check that account 5 has the same id in Hierarchy_Id_As_Text__c but is of the type text
        List<Account> listRes5 = Database.query('SELECT Hierarchy_Id_As_Text__c FROM Account WHERE Id = :result5');
        System.assertEquals(String.valueOf(result5).substring(0, 15), listRes5.get(0).Hierarchy_Id_As_Text__c);
    }

}