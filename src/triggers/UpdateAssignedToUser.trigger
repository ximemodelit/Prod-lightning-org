//Trigger to update the step Assigned to user when the task owner changes

trigger UpdateAssignedToUser on Task (after update) 
{
    //Fetch all the Process Steps related with the tasks being updated
    Set<ID> proStepIDs = new Set<ID>();
    for(Task objNew : Trigger.New)
        {
            for(Task objOld : Trigger.Old)
                {
                    if(objNew.id == objOld.id && objNew.OwnerID != objOld.OwnerId)
                        {
                            proStepIDs.add(objNew.WhatID);
                        }
                }
        }
    
    //Process only if there are items in the set
    if(proStepIDs.size() > 0)
        {
            //Fetch the process steps
            List<Process_Step__c> lstPS = new List<Process_Step__c>([Select Assigned_To__c from Process_Step__c where ID IN : proStepIDs]); 
            
            for(Task objTask : Trigger.New)
                {
                    for(Process_Step__c objPS : lstPS)
                        {
                            if(objTask.whatID == objPS.id)
                                {
                                    objPS.Assigned_To__c = objTask.OwnerID;
                                    break;
                                }
                        }   
                } 
            
            //Update the process step list
            update lstPS;
        }       
}