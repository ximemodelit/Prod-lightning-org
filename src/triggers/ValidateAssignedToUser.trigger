//Validates Assigned To User for all the steps in the process if Auto Create Tasks is set to True
//Changed By        Date        Comments
//Sankalp           04202011    Created the trigger

trigger ValidateAssignedToUser on Process__c (after update) 
{
// Set to be deprecated
/*
    Set<ID> processIDs = new Set<ID>();    
    for(Process__c objProcess : Trigger.New)
        {
            for(Process__c objOldProcess : Trigger.Old)
                {
                    if(objProcess.id == objOldProcess.id && objProcess.Auto_Create_Tasks__c != objOldProcess.Auto_Create_Tasks__c)
                        {
                            if(objProcess.Auto_Create_Tasks__c)
                                {
                                    processIDs.add(objProcess.ID);
                                }
                        break;      
                        }       
                }       
        }
        
    //Call the helper class method if there are items in the set
    if(processIDs.size() > 0)
        {   
            //Validate Assigned to User
            boolean status = ValidateAssignedToUserHelper.validate(processIDs,true);
            
            if(!status)
                {
                    Trigger.New[0].addError('When using Auto Create Tasks, all incomplete steps must be assigned a user');
                }   
            
            //Auto Create Tasks
            AutoCreateTasks.processSteps(processIDs);
        }   
*/
}