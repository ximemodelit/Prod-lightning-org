public without sharing class ProcessTaskManager {

    public void createMasterTasks(Map<Id, Process__c> processes) {
        Map<Id, Process__c> processMap = new Map<Id, Process__c>([
            SELECT Process_Template__r.Type__c, Entity__c, Contact__c, Deadline__c, Description__c,
            Name,
            Lead__c, Case__r.ContactId, Opportunity__c, Opportunity__r.AccountId FROM Process__c 
            WHERE Id IN :processes.keySet()]);
        
        List<Contact> relatedContacts = relatedContacts(processMap.values());
        List<Task> tasks = new List<Task>();
        
        for (Process__c process1 : processMap.values())
        {
            Task tmpSFTask = new Task();
            String whoId = null;
            String templateType = process1.Process_Template__r.Type__c;
            if (templateType == 'Contact') {
                whoId = process1.Contact__c;
            }
            else if (templateType == 'Entity') {
                whoId = contactIdFromProcessEntity(relatedContacts, process1);    
            }
            else if (templateType == 'Opportunity') {
                whoId = contactIdFromProcessOpportunity(relatedContacts, process1);
            }
            else if (templateType == 'Lead') {
                // skip. Task can't be related to a lead and an arbitrary object.
            }
            else if (templateType == 'Case') {
                whoId = process1.Case__r.ContactId;
            }
            tmpSFTask.OwnerId = Userinfo.getUserId(); 
            tmpSFTask.ActivityDate = process1.Deadline__c;
            tmpSFTask.Subject = 'Process: ' + process1.Name;
            tmpSFTask.Status = 'Not Started';
            tmpSFTask.Description = process1.Description__c;
            tmpSFTask.WhatId = process1.Id;
            tmpSFTask.Priority = 'Normal';  
            tmpSFTask.WhoId = whoId;   
            tmpSFTask.Process_ID__c = process1.Id;
            tasks.add(tmpSFTask);
        }
        if (isTaskCreateable()){
            Database.insert(tasks);  
        }       
    }
    
    private List<Contact> relatedContacts(List<Process__c> processes) {
        Set<Id> accountIds = new Set<Id>();
        for (Process__c process1 : processes) {
            if (process1.Entity__c != null) {
               accountIds.add(process1.Entity__c);   
            }
            if (process1.Opportunity__r.AccountId != null) {
                accountIds.add(process1.Opportunity__r.AccountId);
            }
        }
        List<Contact> contacts = new List<Contact>();
        
        if (!accountIds.isEmpty()) {
            contacts = [SELECT Id, primary_contact__c, AccountId FROM contact WHERE AccountId IN :accountIds];
        } 
        return contacts;
    }
    
    private Id contactIdFromProcessEntity(List<Contact> contacts, Process__c process1) {
        Id whoId = null;       
        for(Contact contact1 : contacts) {
            if (process1.Entity__c == contact1.AccountId) {
                whoId = contact1.Id;
                if (contact1.Primary_Contact__c) {
                    break;
                }
            }
        }
        return whoId;
    }
    
    private Id contactIdFromProcessOpportunity(List<Contact> contacts, Process__c process1) {
        Id accountId = process1.Opportunity__r.AccountId;
        Id whoId = null;
        for (Contact contact1 : contacts) {
            if (process1.Opportunity__r.AccountId == contact1.AccountId) {
                whoId = contact1.Id;
                if (contact1.Primary_Contact__c) {
                    break;
                }
            }
        }
        return whoId;
    }   
    
    private static Boolean isTaskCreateable(){
        return (Schema.Sobjecttype.Task.isCreateable() &&  Task.OwnerId.getDescribe().isCreateable() && 
                Task.ActivityDate.getDescribe().isCreateable() && Task.Subject.getDescribe().isCreateable() &&
                Task.Status.getDescribe().isCreateable() && Task.Description.getDescribe().isCreateable() &&
                Task.WhatId.getDescribe().isCreateable() && Task.Priority.getDescribe().isCreateable() && 
                Task.WhoId.getDescribe().isCreateable() && Task.Process_Step_ID__c.getDescribe().isCreateable());
    }
}