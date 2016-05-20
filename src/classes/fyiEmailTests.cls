/*
    Concenter Services, LLC
*/
@isTest
private class fyiEmailTests {

    private static testMethod void fyiEmailTest() {
        Task[] tasks = new Task[20];
        String alias = [SELECT Alias FROM User WHERE Id = :UserInfo.getUserId()].Alias;
        
        for (Integer i = 0; i < tasks.size(); i++) {
            tasks[i] = new Task();
            
            tasks[i].Send_FYI__c = true;
            tasks[i].FYI_List__c = alias;
        }
            
        Test.startTest();
        insert tasks;
        Test.stopTest();
        
        Task[] insertedTasks = [SELECT Send_FYI__c FROM Task WHERE Id IN :tasks];
        
        for (Task insertedTask : insertedTasks) {
            System.assert(!insertedTask.Send_FYI__c);
            
            insertedTask.Send_FYI__c = true;
        }
        
        update insertedTasks;
        
        Task[] updatedTasks = [SELECT Send_FYI__c FROM Task WHERE Id IN :insertedTasks];
        
        for (Task updatedTask : updatedTasks)
            System.assert(!updatedTask.Send_FYI__c);
    }
}