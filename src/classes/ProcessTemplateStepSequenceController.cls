public with sharing class ProcessTemplateStepSequenceController {

	public List<GenericStep> Steps { get; set; }
	private ApexPages.StandardController controller;
	private Process_Template__c theProcess;

	public ProcessTemplateStepSequenceController(ApexPages.StandardController cont) {
		this.controller = cont;
		this.theProcess = (Process_Template__c) cont.getRecord(); 
		Steps = new List<GenericStep>();
		
		List<Process_Template_Step__c> processSteps = [Select Name,  
			Sequence__c,
			(SELECT ParentStep__c, PredecessorStep__c FROM Template_Step_Junctions_Parent__r)
			FROM Process_Template_Step__c WHERE Process_Template__c = :theProcess.Id 
			ORDER BY Sequence__c ];
			
		for (Process_Template_Step__c step : processSteps) {
			GenericStep Step1 = new GenericStep(step.Id, step.Name, String.valueOf(step.Sequence__c), 
				null);
			if (step.Template_Step_Junctions_Parent__r != null) {
				String[] predecessorIds = new List<String>();
				for (Process_Template_Step_Junction__c junction : step.Template_Step_Junctions_Parent__r) {
					predecessorIds.add(junction.PredecessorStep__c);
				}
				Step1.PredecessorIds = String.join(predecessorIds, ';');
			}
			Steps.add(Step1);
		}
	}
	
	public PageReference save() {
		List<Process_Template_Step__c> processSteps = new List<Process_Template_Step__c>();
		for (GenericStep step1 : Steps) {	
			Process_Template_Step__c processStep = new Process_Template_Step__c(
				Id = step1.Id,
				Sequence__c = Integer.valueOf(step1.Sequence)
			);
			processSteps.add(processStep);
		}
		try { 
			if (isProcessTemplateStepUpdateable()){
                update processSteps;
            }else{
                
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'You do not have perms to update process template steps.');
                ApexPages.addMessage(myMsg); 
            }
			ProcessTemplateManager mgr = new ProcessTemplateManager();
			mgr.setPredecessorsFromGenericSteps(Steps); 
			return controller.view();
		}
		catch (DMLException e) {
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
		}
		return null;
	}

	 private Boolean isProcessTemplateStepUpdateable(){
        return (Schema.sObjectType.Process_Template_Step__c.isUpdateable() && Process_Template_Step__c.Sequence__c.getDescribe().isUpdateable());
    }
}