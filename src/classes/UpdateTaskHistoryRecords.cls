/* 
 * This class contains logic to mass update Task Histories. It will update the Activity Id field to contain the 18 character id instead of the 15 characters id
 *
 * @author Angelica Buffa
 * @since 2013-12
 */
global with sharing class UpdateTaskHistoryRecords implements Database.Batchable<sObject> {

    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([SELECT Id, Activity_ID__c from Task_History__c ]);
    }
    
    /*
    * Overwrites the execute method. 
    *
    * @param - Database.BatchableContext, current set of records to process
    * @return - void
    */
    global void execute(Database.BatchableContext BC, List<Task_History__c> scope){
        for (Task_History__c record : scope){
            if (record.Activity_ID__c != null && record.Activity_ID__c != '' && record.Activity_ID__c.length() == 15){
                try{
                    Id activityId = (Id)record.Activity_ID__c;
                    record.Activity_ID__c = activityId;
                }catch(Exception ex){}
            }
        }
        try{
            update scope;
        }catch(Exception ex){}
        
    }

    /*
    * Overwrites the finish method. Email admins upon job completion
    *
    * @param - Database.BatchableContext
    * @return - void
    */
    global void finish(Database.BatchableContext BC){
        
    }
}