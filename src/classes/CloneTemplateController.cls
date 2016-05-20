public with sharing class CloneTemplateController {
	private Id recordId;
	
	public CloneTemplateController(ApexPages.StandardController cont) {
		recordId = cont.getId();	
	}
	
	public PageReference init() {
		ProcessTemplateManager mgr = new ProcessTemplateManager();
		Id clonedTemplateId = mgr.deepClone(recordId);
		PageReference pr = new PageReference('/' + clonedTemplateId);
		return pr;
	}
}