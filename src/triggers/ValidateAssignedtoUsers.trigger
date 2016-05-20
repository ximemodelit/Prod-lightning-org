// Trigger to validate tasks are assigned to a user for steps
// Sanu             04182011    Created Trigger
// Sankalp Shastri  04192011    Modified the logic to check process steps instead of Process Template Steps

trigger ValidateAssignedtoUsers on Process_Step__c (after update, after insert) 
    {
    
    // Create Set for IDs
    Set <ID> processIDs = new Set<ID>();
    
    // Loop through and IDs and add to set
    for(Process_step__c p:Trigger.new)
        {   
            processIDs.add(p.process__c);         
        }
    
    //Fetch the auto create tasks status for the processes
    List<Process__c> lstProcess = new List<Process__c>([Select ID, Auto_Create_Tasks__c from Process__c where ID in : processIDs]);
    
    //Create a map for the above list
    Map<Id, boolean> mapProcessAutoTaskStatus = new Map<Id,boolean>();
    
    for(Process__c objProcessAuto : lstProcess)
        {
            mapProcessAutoTaskStatus.put(objProcessAuto.id, objProcessAuto.Auto_Create_Tasks__c);
        }
    
    //Keep the Process Step and task in Sync
    if(Trigger.isUpdate)
        {
            Set<Id> processStepIDs = new Set<Id>();
            
            for(Process_Step__c objPSNew : Trigger.New)
                {
                    for(Process_Step__c objPSOld : Trigger.Old)
                        {
                            if(objPSNew.id == objPSOld.id && objPSNew.Assigned_to__c != objPSOld.Assigned_to__c)
                                {
                                if(objPSNew.Assigned_to__c != null)
                                    {
                                    processStepIDs.add(objPSNew.id);
                                    }
                                else
                                    {
                                        if(objPSNew.Task_Created__c != 'N')
                                            {
                                                objPSNew.Assigned_to__c.addError('Assigned To field cannot be blank for a step with task');
                                            }
                                        else
                                            {
                                                boolean AutoCreateStatus = mapProcessAutoTaskStatus.get(objPSNew.Process__c);
                                                if(AutoCreateStatus)
                                                    {
                                                        objPSNew.Assigned_to__c.addError('Auto Create Tasks is turned on, therefore all incomplete steps must be assigned a user');
                                                    }
                                            }       
                                    }    
                                }
                        }
                }
            
            //Process only if there are items in the set
            if(processStepIDs.size() > 0)
                {
                    //Fetch the Tasks for the process steps
                    List<Task> lstTasks = new List<Task>([SELECT OwnerID, WhatID FROM Task WHERE WhatID =: processStepIDs]);
                    for(Process_Step__c objPS : Trigger.New)
                        {
                            for(Task objTask : lstTasks)
                                {
                                    if(objPS.id == objTask.WhatID)
                                        {
                                            objTask.OwnerID = objPS.Assigned_to__c;
                                            break;
                                        }
                                }
                        }
                        
                    update lstTasks;
                }   
        }          
    
    
    if(processIDs.size() >0)
        {
            //Call the helper class method    
            ValidateAssignedToUserHelper.validate(processIDs, true);
        }
}