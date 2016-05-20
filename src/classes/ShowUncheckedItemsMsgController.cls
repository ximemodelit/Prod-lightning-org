public with sharing class ShowUncheckedItemsMsgController {
	
	private String retUrl;
	
	public ShowUncheckedItemsMsgController() {
		retUrl = ApexPages.currentPage().getParameters().get('retUrl');
	}
	
	public PageReference back() {
		return new PageReference(retUrl);
	}
}