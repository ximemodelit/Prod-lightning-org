/**
 * Batch for updating null values of Hierarchy_Id_As_Text__c with Hierarchy_Group_ID__c values
 *
 *@author Ximena Lasserre
 *@since 2014-12
 */


global class ScriptForHierarchyIdFieldFixesBatch implements Database.Batchable<SObject>{
    
    /*
     * Queries all the existing accounts where Hierarchy_Id_As_Text__c is null and returns them
     * @Param Database.BatchableContext BC
     * @Return Database.queryLocator
     */
    global Database.queryLocator start(Database.BatchableContext BC){
            
        return Database.getQueryLocator([SELECT Id, Hierarchy_Group_ID__c, Hierarchy_Id_As_Text__c
                                         FROM Account 
                                         WHERE Hierarchy_Id_As_Text__c = null
                                         AND Hierarchy_Group_ID__c != null]);
    }
    
    /*
     * For each queried account it takes the value from Hierarchy_Group_ID__c
     * and copies it to Hierarchy_Id_As_Text__c
     * @Param Database.BatchableContext BC
     * @Param List<SObject> scope
     */
    global void execute(Database.BatchableContext BC, List<SObject> scope){
        
        for(SObject s: scope){
            Account a = (Account)s;
            a.Hierarchy_Id_As_Text__c = String.valueOf(a.Hierarchy_Group_ID__c);        
        }
        Database.update(scope, false);
    }
    
    /*
     * There is no need to do anything after the batch was executed
     * @Param Database.BatchableContext BC
     */
    global void finish(Database.BatchableContext BC){
        
    }
}