public with sharing class HandleOwnerNotification
{
	// private constants
	private static final string TEMPLATE_NAME = 'Process_Notify_Owners_Email_Template_V1';
	private static final string CONFIRMATION_MESSAGE = 'An email has been sent notifying all open process step assignees that they have ownership in the process';
	
	// Private instance variables
	private Process__c currentProcess { get; set; }
	
	// Public instance variables
	public Id processId {get;set;}
	public List<String> errors {get;set;}
	public boolean init {get;set;}
	// Constructors
    public HandleOwnerNotification(ApexPages.StandardController controller){
    	processId = controller.getId();
    	initProcess();
    	errors = new List<String>();
		init = true;
    }
    
    /*
    This method sends an email to the owner of the uncompleted steps for current process
    @param -
    @return PageReference to the current process
    */
    public void handleMailNotification(){
    	init = false;
    	Set<Id> sentUsers = new Set<Id>();
        //String processID = Apexpages.currentPage().getParameters().get('id');
        if (currentProcess != null){
        	if (currentProcess.Status__c == 'Completed'){
        		errors.add('This process is Completed, owners will not be notified.');
        	}else if (currentProcess.Status__c == 'Cancelled'){
        		errors.add('This process is Cancelled, owners will not be notified.');
        	}else{
        		EmailTemplate emailTemplate = getEmailTempalte(TEMPLATE_NAME);
        
		        if (emailTemplate != null){
		        	List<Process_Step__c> processSteps = getProcessSteps();
		        	List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
			        
			        if (processSteps.size() > 0){
			        	for (Process_Step__c processStep: processSteps){
				            if (processStep.Assigned_To__c != null && !sentUsers.contains(processStep.Assigned_To__c)){
				                Messaging.SingleEmailMessage mail = createEmail(emailTemplate.Id, processStep.Assigned_To__c, processID);
				                emails.add(mail);		                
				                sentUsers.add(processStep.Assigned_To__c);    
				            }
				        }
				        
				        if (sendEmails(emails)){			        	
				        	showConfirmationMessage();
				        }
			        }else{
			        	errors.add('This process does not have steps, owners will not be notified.');
			        }  
		        }
        	}
        }else{
        	errors.add('Process ID cannot be blank.');
        }	
       	
       	showErrors();
    }
    
    /*
    This method initializes current process
    @param -
    @return -
    */
    private void initProcess(){   	
    	
    	if (processId != null){
    		List<Process__c> processes = [Select Id, Status__c from Process__c where id =: processId];
    		
    		if (processes.size() >0){
    			currentProcess = processes.get(0);
    		}
    	}

    }
    
    /*
    This method searches and returns an email template with the given template name
    @param templateName name of the email template that should be queried
    @return EmailTemplate
    */
    private EmailTemplate getEmailTempalte(String templateName){
    	EmailTemplate emailTemplate = null;
    	
    	if (templateName != null && templateName.trim().length() > 0){
    		List<EmailTemplate> emailTemplateList = [SELECT Id, Name, Subject, body 
        										   FROM emailTemplate 
        										  WHERE developerName =: templateName];
        
	        if (emailTemplateList.size() > 0 ){
	        	emailTemplate = emailTemplateList.get(0);
	        }
    	}
    	
    	return emailTemplate;	
    }
    
    /*
    This returns the list of uncompleted process steps for current process
    @param -
    @return list of process steps
    */
    private List<Process_Step__c> getProcessSteps(){
    	
    	List<Process_Step__c> processSteps = [SELECT Id, Assigned_To__C 
    											FROM Process_Step__c 
    										   WHERE Process__c =: currentProcess.Id AND 
    										   		 Status__c <> 'Completed' AND
    										   		 Assigned_To__c != ''];
	    return processSteps;
    }
    
    /*
    This method adds error messages to the page
    @param -
    @return - 
    */
    private void showErrors(){
    	if (errors != null && errors.size() > 0){
    		for (String error : errors){
    			ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,error));
    		}
    	}
    }
    
    /*
    This method displays the confirmation message
    @param -
    @return - 
    */
    private void showConfirmationMessage(){    	
    	ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,CONFIRMATION_MESSAGE));
    }
    
    /*
    This method creates a new single email instance
    @param emailTemplateId id of the email template
    @param targetObjectId id email's recipient
    @param whatId id of the related record (to populated merge fields)
    @return Email
    */
    private Messaging.SingleEmailMessage createEmail(Id emailTemplateId, Id targetObjectId, Id whatId){
    	Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setTemplateId(emailTemplateId);
        mail.setTargetObjectId(targetObjectId);
        mail.saveAsActivity = false;
        mail.setWhatId(whatId);
        return mail;
    }
    
     /*
    This method sends email
    @param list of emails that must be send
    @return true if emails were submitted.
    */
    private boolean sendEmails(List<Messaging.SingleEmailMessage> emails){
    	Boolean result = false;
    	
    	if (emails.size() > 0){
    		try{
                Messaging.sendEmail(emails);
                result = true;
            }catch (Exception ex){
            	system.debug(ex.getMessage());
                errors.add('An error occurred while notifying owners: ' + ex.getMessage());
            }
    	}
    	return result;
    }
}