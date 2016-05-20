//Class for Auto Creating Tasks when Auto Create Check box if ON

// Changed By    Date        Comments
// Sankalp       04192011    Created the class 
public without sharing class AutoCreateTasks {
    
    public static Boolean Disable = false;
    
        //Logic for auto creating tasks
        public static void processSteps(Set<ID> processIDs) {

            if (Disable) {
                return;
            }
            try
                {   
                //Fetch all the steps where Process is marked for auto creation of tasks
                List<Process_Step__c> lstProcessSteps = new List<Process_Step__c>
                    (
                    [SELECT ID,Name,Process__c,Status__c, Assigned_To__c, Step_Details__c, 
                    Sequence__c,Task_Created__c, Process__r.Name, Process__r.Deadline__c,
                    Duration_In_Days__c,
                    (SELECT ParentStep__c, PredecessorStep__c, PredecessorStep__r.Status__c 
                    FROM Process_Step_Junctions_Parent__r)
                    FROM Process_Step__c 
                    WHERE Process__c IN : processIDs 
                          AND Process__r.Auto_Create_Tasks__c = true
                          AND Process__r.Exclude_From_Auto_Create_Tasks__c = false
                    ORDER BY Sequence__c LIMIT : Limits.getLimitQueryRows()
                    ]);
                
                //Process only if there are process steps returned
                if(lstProcessSteps.size() > 0)
                    {
                        //Fetch all the tasks for the available Process Step IDs
                        List<Task> lstTasks = new List<Task>
                            (
                            [Select ID, Status, WhatID 
                            FROM Task 
                            WHERE WhatID IN : lstProcessSteps LIMIT : Limits.getLimitQueryRows()
                            ]);
                        
                        //Create a MAP so that bulk update can be handled on Process Steps
                        Map<ID,List<Process_Step__c>> mapPS = new Map<ID,List<Process_Step__c>>();
                        
                        //Create a MAP for keeping the tasks
                        Map<ID, Task> mapTasks = new Map<ID,Task>();
                        
                        //Loop through the Process Steps and fill the map
                        for(Process_Step__c PS : lstProcessSteps)
                            {
                                if(mapPS.containsKey(PS.Process__c))
                                    {
                                        //Fetch the list and add the process step in the list
                                        mapPS.get(PS.Process__c).add(PS);
                                    }
                                else
                                    {
                                        //Create an entry in the map with the key and the list with the Process Step added to it
                                        List<Process_Step__c> lstTemp = new List<Process_Step__c>();
                                        lstTemp.add(PS);
                                        mapPS.put(PS.Process__c,lstTemp);   
                                    }   
                            }
                        
                        //Loop through and put the tasks in the map
                        for(Task tsk : lstTasks)
                            {
                                mapTasks.put(tsk.WhatID,tsk);   
                            }   
                        
                        //Create a list of tasks to be inserted
                        List<Task> lstNewTasks = new List<Task>();
                        List<Process_Step__c> lstProcessStepsToUpdate = new List<Process_Step__c>();
                        
                        //Loop through and process
                        for(ID processID : processIDs)
                            {
                                //Fetch the Process Steps for the Process
                                List<Process_Step__c> lstTempProcessSteps = mapPS.get(processID);
                            
                                if(lstTempProcessSteps != null)
                                {
                                    
                                //Loop through the list and check if there is task available for the process step
                                for(Process_Step__c PS : lstTempProcessSteps)
                                    {
                                        Boolean hasIncompletePredecessor = containsIncompletePredecessor(PS.Process_Step_Junctions_Parent__r); 
                                        if(PS.Status__c.equals(ProcessManager.PROCESS_STEP_STATUS_OPEN) 
                                                && !hasIncompletePredecessor)
                                            {
                                                if(!mapTasks.containsKey(PS.id))
                                                {
                                                    Task objTask = new Task();
                                                    objTask.OwnerId = PS.Assigned_To__c != null?PS.Assigned_To__c:userinfo.getUserId();
                                                    Decimal duration = PS.Duration_In_Days__c;
                                                    Date dueDate = Date.today();
                                                    System.debug(dueDate);
                                                    if (duration != null) {
                                                        dueDate = DateUtils.addBusinessDays(dueDate, Integer.valueOf(duration)).dateGMT();
                                                    }
                                                    System.debug(dueDate);
                                                    objTask.ActivityDate = dueDate;
                                                    objTask.WhatID = PS.id;
                                                    objTask.Subject = 'Process Step: ' + PS.Process__r.Name + ' - ' + PS.name;
                                                    objTask.Description = PS.Step_Details__c;
                                                    objTask.Priority = 'Normal';
                                                    objTask.Process_ID__c = PS.Process__c;
                                                    objTask.Process_Step_ID__c = PS.id;
                                                        
                                                    //add the task to the list
                                                    PS.Task_Created__c = 'Y';
                                                    lstNewTasks.add(objTask);
                                                        
                                                    //Mark the process to have the task created for
                                                    lstProcessStepsToUpdate.add(PS);

                                                 }                                                
                                            }
                                    }
                                }   
                            }
                    
                        Database.DMLOptions dmlo = new Database.DMLOptions();
                        dmlo.EmailHeader.triggerUserEmail = true; 
                        dmlo.optAllOrNone = true;   
                    
                            //Insert the tasks, checking if current user has perms to update
                            if (isTaskCreateable()){

                                database.insert(lstNewTasks,dmlo);
                            }
                            
                            //Update the process steps, checking if current user has perms to update
                            if (isProcessStepUpdeatable()){
                                update lstProcessStepsToUpdate; 
                            }
                        }
                }
            catch(exception ex)
                {
                    throw ex;   
                }           
            }

    public static Boolean containsIncompletePredecessor(List<Process_Step_Junction__c> junctions) {
        System.debug(junctions);
        if (junctions == null) {
            System.debug('junctions was null');
            return false;
        }
        for (Process_Step_Junction__c junction : junctions) {
            System.debug(junction);
            if (junction.PredecessorStep__r.Status__c == 'Open') {
                return true;
            }
        }
        return false;
    }
    
    public static Boolean isTaskCreateable(){
        return (Schema.Sobjecttype.Task.isCreateable() &&  Task.OwnerId.getDescribe().isCreateable() && Task.Subject.getDescribe().isCreateable() &&
                Task.Description.getDescribe().isCreateable() && Task.Priority.getDescribe().isCreateable() && Task.Process_ID__c.getDescribe().isCreateable() &&
                Task.Process_Step_ID__c.getDescribe().isCreateable());
    
    }
    public static Boolean isProcessStepUpdeatable(){
        return (Schema.Sobjecttype.Process_Step__c.isUpdateable() &&  Process_Step__c.Task_Created__c.getDescribe().isUpdateable());
    }
}