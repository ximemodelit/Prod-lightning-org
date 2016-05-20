trigger Handle_Process_Creation on Process__c (after insert) 
{
// deprecated
/*
        Set<Id> entityIDSet = new Set<Id>();
        List<Task> taskList = new List<Task>();
        
        for (Process__c tmpProcess : Trigger.new)
        {
            if (tmpProcess.Entity__c != null)
            {
               entityIDSet.add(tmpProcess.Entity__c);   
            }
        }
        
        List<Contact> lstContact = new List<Contact>();
        
        //Query only if there are items
        if(entityIDSet.size() > 0)
            {
                lstContact = [SELECT Id, primary_contact__c, AccountId FROM contact WHERE AccountId IN :entityIDSet];
            }
        
        for (Process__c tmpProcess : Trigger.new)
        {
            Task tmpSFTask = new Task();
            String contactID = null;
            
            for(Contact tmpContact : lstContact)
            {
                if ((tmpProcess.Entity__c != null) && (tmpProcess.Entity__c == tmpContact.AccountId))
                {
                    if (tmpContact.Primary_Contact__c)
                    {
                        contactID = tmpContact.Id;
                        break;
                    }
                }
            }
            
            if (contactID == null)
            {
                for(Contact tmpContact : lstContact)
                {
                    if ((tmpProcess.Entity__c != null) && (tmpProcess.Entity__c == tmpContact.AccountId))
                    {
                        contactID = tmpContact.Id;
                        break;
                    }
                }
            }
            tmpSFTask.OwnerId = Userinfo.getUserId(); //AssignedTo field for SF Task Obj
            tmpSFTask.ActivityDate = tmpProcess.Deadline__c;  //Deadline of SF Task Obj
            tmpSFTask.Subject = 'Process: ' + tmpProcess.Name;
            tmpSFTask.Status = 'Not Started';
            tmpSFTask.Description = tmpProcess.Description__c;
            tmpSFTask.WhatId = tmpProcess.Id;
            tmpSFTask.Priority = 'Normal';  
            tmpSFTask.WhoId = contactID;   
            tmpSFTask.Process_ID__c = tmpProcess.Id;
            taskList.add(tmpSFTask);
        }
    Database.insert(taskList);    
*/
}