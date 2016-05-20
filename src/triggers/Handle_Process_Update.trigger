trigger Handle_Process_Update on Process__c (after update) 
{    

// This trigger is planned for deprecation 

/*
        Set<Id> processIds = new Set<Id>();
        
        for (Process__c tmpObj: Trigger.new)
        {
            processIds.add(tmpObj.Id);
        }

        List<Task> taskList = [SELECT Id, ActivityDate, WhatID, status, OwnerId FROM task WHERE WhatID != NULL AND WhatID IN :processIds];
        for(Task tmpTask: taskList)
        {
            for (Process__c tmpProcess: Trigger.new)
            {
                if (tmpTask.WhatId == tmpProcess.Id)
                {
                    tmpTask.ActivityDate = tmpProcess.Deadline__c;
                    if ((tmpProcess.Total_Steps__c ==0) || (tmpProcess.Completed_Steps__c == 0))
                    {
                        tmpTask.Status = 'Not Started';
                    }
                    else if (tmpProcess.Total_Steps__c == tmpProcess.Completed_Steps__c + tmpProcess.NA_Steps__c)
                    {
                        tmpTask.Status = 'Completed';
                    }
                    else
                    {
                        tmpTask.Status = 'In Progress';
                    }                   
                }
            }
        }
        Database.update(taskList);    
*/
}