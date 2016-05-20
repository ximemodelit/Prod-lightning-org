//Trigger to Handle Task Updates

trigger Handle_Task_Update on Task (after update) 
{
    Set<Id> processStepIDs = new Set<Id>();
    Set<Id> processIDs = new Set<Id>();
    Map<Id,Task>stepToTaskMap = new Map<Id,Task>();
    //Loop through and check if Tasks are updated to "Completed" status and are for Process Step or Process     
    for (Task tmpTask: Trigger.new)
    {
        //If the task has been marked completed for a Process Step - add the ID to Process Step IDs set
        if (tmpTask.Process_Step_ID__c != null && ('Completed'.equalsIgnoreCase(tmpTask.Status) ||
            'Cancelled'.equalsIgnoreCase(tmpTask.Status) || 'In Progress'.equalsIgnoreCase(tmpTask.Status) ||
            'Not Started'.equalsIgnoreCase(tmpTask.Status)))
        {
            processStepIDs.add(tmpTask.Process_Step_ID__c);
            stepToTaskMap.put(tmpTask.Process_Step_ID__c, tmpTask);
        }
        //If the task has been marked completed for a Process - add the ID to Process IDs set
        else if ((tmpTask.Process_Step_ID__c == null) && (tmpTask.Process_ID__c != null) /*&& 'Completed'.equalsIgnoreCase(tmpTask.Status)*/)
        {
            processIDs.add(tmpTask.Process_ID__c);
        }
    }
    
    //Set
    Set<ID> autoCreateTasksForProcesses = new Set<ID>();
    
    //If there are steps available to be updated then update the step status to "Completed" 
    if (processStepIDs.size() > 0)
    {
       list<Process_Step__c> processSteps = [SELECT Id, Status__c, Completed_Date__c, Completed_By__c,Process__c, Process__r.Auto_Create_Tasks__c 
                                               FROM Process_Step__c 
                                              WHERE /*Status__c ='Open' and*/ Id IN :processStepIDs];  
        for (Process_Step__c tmpProcessStep: processSteps)
        {
            Task task = stepToTaskMap.get(tmpProcessStep.Id);
            
            if (task != null){
                if (task.Status == 'In Progress' || task.Status == 'Not Started'){
                    tmpProcessStep.Completed_Date__c = null;
                    tmpProcessStep.Completed_By__c = null;
                    tmpProcessStep.Status__c = 'Open';
                }else if (task.Status == 'Cancelled'){
                    tmpProcessStep.Completed_Date__c = Date.Today();
                    tmpProcessStep.Completed_By__c = Userinfo.getUserId();
                    if (ProcessActionsController.getCancelProcessStarted()){
                        tmpProcessStep.Status__c = 'Cancelled';
                    }else{
                        tmpProcessStep.Status__c = 'N/A';
                    }
                    
                }else if (task.Status == 'Completed'){
                    tmpProcessStep.Completed_Date__c = Date.today();
                    tmpProcessStep.Completed_By__c = Userinfo.getUserId();
                    tmpProcessStep.Status__c = 'Completed';
                    if(tmpProcessStep.Process__r.Auto_Create_Tasks__c)
                    {
                        autoCreateTasksForProcesses.add(tmpProcessStep.Process__c);         
                    }
                }
            }           
       }
       database.update(processSteps);
       
       //Auto Create Tasks
       if(autoCreateTasksForProcesses.size() > 0)
        {
          AutoCreateTasks.processSteps(autoCreateTasksForProcesses);
        }
    }
    
    //If there are process IDs to be updates then show a message 'This task is tied to a Process. Please close the steps of the process and the task will close automatically.'     
    if (processIDs.size() > 0)
    {
        list<Process__c> processes = [SELECT Id, Status__c, Cancelled_Steps__c, Total_Steps__c, NA_Steps__c, Completed_Steps__c  FROM Process__c WHERE Id IN :processIDs];
        for (Process__c tmpObj: processes)
        {
            for (Task tmpTask: Trigger.new)
            {
                if (tmpObj.Id == tmpTask.Process_ID__c)
                {
                    /*if ((tmpObj.Total_Steps__c == 0) || (tmpObj.Cancelled_Steps__c + tmpObj.NA_Steps__c + tmpObj.Completed_Steps__c != tmpObj.Total_Steps__c))
                    {
                        tmpTask.addError('This task is tied to a Process. Please close the steps of the process and the task will close automatically.');
                    }*/
                    if (tmpTask.Status != tmpObj.Status__c){
                        tmpTask.addError('This task is tied to a Process, and you cannot change the status because it is controlled by the Process.');
                    }
                    break;
                }
            }
        }
    }
}