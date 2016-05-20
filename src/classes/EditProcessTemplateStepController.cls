public with sharing class EditProcessTemplateStepController {

	public String TheType { get; set; }

	private ApexPages.StandardController standardController;
	private String newUrl;
	
	public EditProcessTemplateStepController(ApexPages.StandardController standardController) {
		this.standardController = standardController;
		String templateId = null;
		Process_Template_Step__c step = (Process_Template_Step__c) standardController.getRecord();
		if (step.Process_Template__c != null) {
			templateId = step.Process_Template__c;
		}
		else {
			templateId = ApexPages.currentPage().getParameters().get('templateId');
			step.Process_Template__c = templateId;
		}
		Process_Template__c template = [SELECT Type__c FROM Process_Template__c 
			WHERE Id = :templateId];
		TheType = template.Type__c;
    	setNewUrl();
	}
	
	public PageReference saveAndNew() {
		PageReference pr = null;
		try {
			standardController.save();
			Process_Template_Step__c step = (Process_Template_Step__c) standardController.getRecord();
			if (!Apexpages.hasMessages()) {
		        pr = new PageReference(newUrl += '&templateId=' + step.Process_Template__c);
		        pr.setRedirect(true);
			}
		}
		catch (Exception ex) {
			ApexPages.addMessages(ex);
		}
        return pr;
	}
	
	private void setNewUrl() {
		Schema.DescribeSObjectResult describeResult = standardController.getRecord()
				.getSObjectType().getDescribe();
        newUrl = '/' + describeResult.getKeyPrefix() + '/e?';
    	Map<String, String> params = ApexPages.currentPage().getParameters();
    	String queryString = '';
    	for (String key : params.keyset()) {
    		if (key != 'id' && key != 'templateId') {
    			if (queryString.length() > 0) {
    				queryString += '&';
    			}
    			queryString += key + '=' + params.get(key);
    		}
    	}
    	newUrl += queryString;
	}
}