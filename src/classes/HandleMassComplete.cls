public with sharing class HandleMassComplete 
{ 
    List<Process_Step__c> steps;

    public PageReference firstItem() {
        List<Process_Step__c> newSteps= new List<Process_Step__c>();
        String retUrl= Apexpages.currentPage().getParameters().get('retURL');
        Pagereference ref  = new Pagereference('/apex/showUncheckedItemsMsg?retUrl='+retUrl);
        if (!steps.isEmpty())
        {
            for(Process_Step__c step:steps )
            {
               newSteps.add(new Process_Step__c(Status__c = 'Completed', Id = step.Id
               ,Completed_By__c = Userinfo.getUserId()
               , Completed_Date__c = Date.today()));
            }
            
            //Update the process steps, checking if current user has perms to update
            if (isProcessStepUpdateable()){
            	Database.update(newSteps);
            }else{
            	ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'You do not have privileges to update porcess steps.');
				ApexPages.addMessage(myMsg); 
        	}            
            
            ref = new Pagereference(retURL);
        }
        return ref;
    }

    public HandleMassComplete(ApexPages.StandardSetController controller) 
    {
        steps = (List<Process_Step__c>) controller.getSelected();
    }
    
    private static Boolean isProcessStepUpdateable(){
    	return (Schema.sObjectType.Process_Step__c.isUpdateable() && Process_Step__c.Status__c.getDescribe().isUpdateable() && 
    			Process_Step__c.Completed_By__c.getDescribe().isUpdateable() && Process_Step__c.Completed_Date__c.getDescribe().isUpdateable());
    
	}
}