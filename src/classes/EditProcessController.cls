public with sharing class EditProcessController {

	public String getTemplateType() {
		return [SELECT Type__c FROM Process_Template__c 
    			WHERE Id = :theProcess.Process_Template__c].Type__c;
	}

	public String getProcessName() {
		return theProcess.Name != null ? theProcess.Name : 'New Process';
	}

    private ApexPages.Standardcontroller controller;
    private Process__c theProcess;
    
    public EditProcessController(ApexPages.StandardController controller) {
    	this.controller = controller;
    	this.theProcess = (Process__c) controller.getRecord();
    }
    
    public void selectTemplate() {
		if (theProcess.Process_Template__c != null 
				&& !hasReadAccessToObject(getTemplateType())) {
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
			'You do not have access to the ' + getTemplateType() + ' object. Please select a'
			+ ' different template.'));
			theProcess.Process_Template__c = null;
		}
		else {
			theProcess.Auto_Create_Tasks__c = [SELECT Auto_Create_Tasks_Default__c 
				FROM Process_Template__c WHERE Id = :theProcess.Process_Template__c]
				.Auto_Create_Tasks_Default__c;
		}
    }
    
    private Boolean hasReadAccessToObject(String objectName) {
		if (objectName == 'Entity') objectName = 'Account';
		Map<String, Schema.SObjectType> describeMap = Schema.getGlobalDescribe();
		Schema.SObjectType token = describeMap.get(objectName);
		if (token == null) {
			return false;
		}
		return token.getDescribe().isAccessible();
    }
    
    public PageReference save() {
    	PageReference pr = null;
    	try { 
	    	clearInvisibleFields();
	    	saveInternal();
	    	pr = new ApexPages.StandardController(theProcess).view();
    	}
    	catch(Exception ex) {
    		ApexPages.addMessages(ex);
    	} 
    	return pr;
    }
    
    private void saveInternal() {
		ProcessManager manager = new ProcessManager();
		manager.save(theProcess);
    }
    
    private void clearInvisibleFields() {
		String templateType = getTemplateType();
		if (templateType != 'Contact') {
			theProcess.Contact__c = null;
		}
		if (templateType != 'Entity') {
			theProcess.Entity__c = null;
		}
		if (templatetype != 'Case') {
			theProcess.Case__c = null;
		}
		if (templateType != 'Opportunity') {
			theProcess.Opportunity__c = null;
		}
		if (templateType != 'Lead') {
			theProcess.Lead__c = null;
		}
    }
}