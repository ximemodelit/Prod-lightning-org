//Trigger to update the primary contact from Entity to Process Step Task
//Created by    Date        Comments
//Sankalp       04222011    Created the trigger
 
trigger UpdateContactFromEntity on Task (before insert) 
{
    Set<ID> processIds = new Set<ID>();
    
    for(Task objTask : Trigger.New)
    	{
    		if(objTask.Process_Step_Id__c != null)
    			{
    				processIDs.add(objTask.Process_ID__c);
    			}	
    	}
   
   	Map<Id,Id> mapContacts = new Map<id,id>();
    
    //If there are items in the set	
    if(processIDs.size() > 0)
    	{
    		//Fetch tasks for those process IDs    		
    		List<Task> lstTasks = new List<Task>([Select WhatID, WhoId from Task where WhatID in : processIds]);
    		
    		for(Task objTempTask : lstTasks)
    			{
    				mapContacts.put(objTempTask.WhatID, objTempTask.WhoId);
    			}
    	}
    	
    for(Task objTask : Trigger.New)
    	{	
    		if(objTask.Process_Step_Id__c != null)
    			{	
    				objTask.WhoId = mapContacts.get(objTask.Process_ID__c);
    			}	
    	}		
}