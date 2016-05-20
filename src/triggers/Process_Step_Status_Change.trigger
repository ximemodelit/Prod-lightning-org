trigger Process_Step_Status_Change on Process_Step__c (before insert, before update) {
/*
    if (Trigger.isBefore && Trigger.isInsert)
    {
        for(Process_Step__c tmpProcessStep: Trigger.new)
        {
            if ('Open'.equalsIgnoreCase(tmpProcessStep.Status__c))
	        {
	            tmpProcessStep.Completed_By__c = null;
	            tmpProcessStep.Completed_Date__c = null;
	        }
	        else if ('N/A'.equalsIgnoreCase(tmpProcessStep.Status__c))
	        {
	            if (tmpProcessStep.Completed_By__c == null)
	            {
	                tmpProcessStep.Completed_By__c = Userinfo.getUserId();
	            }
	            if (tmpProcessStep.Completed_Date__c == null)
	            {
	                tmpProcessStep.Completed_Date__c = Date.today();
	            }
	        }
	        
        }
        
        if (Trigger.new.size() > 1)
        {
        	return;
        }
        for (Process_Step__c processStep: Trigger.new)
        {
           if (processStep.Process__c != null)
           {
               List<Process_Step__c> processStepList = [SELECT Id, name, Process__c from  Process_Step__c where Process__c =: processStep.Process__c 
                                                        AND name =: processStep.name];
               if(!processStepList.isEmpty())
               {
                   processStep.Name.addError('Process step name is already in use');
               }
           }

           List<Process_Step__c> processStepList = [SELECT Id, name, Process__c, sequence__c from  Process_Step__c where Process__c =: processStep.Process__c
                                                    AND sequence__c =: processStep.sequence__c]; 
           if(!processStepList.isEmpty())
           {
               processStep.sequence__c.addError('This sequence number is already in use. Please select another sequence number.');
           }            
        }
    }
    else if (Trigger.isBefore && Trigger.isUpdate)
    {
        for (Process_Step__c oldProcessStep : Trigger.old)
        {
        	for (Process_Step__c newProcessStep : Trigger.new)
        	{
        		if ((oldProcessStep.Id == newProcessStep.Id) && (oldProcessStep.Status__c != newProcessStep.Status__c))
        		{
        			if ('Open'.equalsIgnoreCase(newProcessStep.Status__c))
		            {
		                newProcessStep.Completed_By__c = null;
		                newProcessStep.Completed_Date__c = null;
		            }
		            else if ('N/A'.equalsIgnoreCase(newProcessStep.Status__c))
		            {
		                if (newProcessStep.Completed_By__c == null)
		                {
		                    newProcessStep.Completed_By__c = Userinfo.getUserId();
		                }
		                if (newProcessStep.Completed_Date__c == null)
		                {
		                    newProcessStep.Completed_Date__c = Date.today();
		                }
		            }
		            break;
        		}
        	}
        }
        
        if (Trigger.new.size() > 1)
        {
            return;
        }
        for (Process_Step__c processStep: Trigger.new)
        {
           if (processStep.Process__c != null)
           {
               List<Process_Step__c> processStepList = [SELECT Id, name, Process__c from  Process_Step__c where Process__c =: processStep.Process__c
                                                        AND name =: processStep.name AND id <>: processStep.id]; 
               if(!processStepList.isEmpty())
               {
                   processStep.Name.addError('Process step name is already in use');
               }
           }
           List<Process_Step__c> processStepList = [SELECT Id, name, Process__c, sequence__c from  Process_Step__c where Process__c =: processStep.Process__c
                                                    AND sequence__c =: processStep.sequence__c AND id <>: processStep.id]; 
           if(!processStepList.isEmpty())
           {
               processStep.sequence__c.addError('This sequence number is already in use. Please select another sequence number.');
           }          
        }
    }
*/  
}