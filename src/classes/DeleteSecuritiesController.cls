public with sharing class DeleteSecuritiesController {
	
	public DeleteSecuritiesController() {
		Started = false;
	}
	
	public Integer RecordCount {
		get {
			return (Integer) [SELECT Count(Id) cnt FROM XLR8_Securities__c][0].get('cnt');
		}
	}
	
	public Boolean Started {
		get; set;
	}
	
	public PageReference startDeletion() {
		Database.executeBatch(new DeleteSecuritiesBatchable());
		Started = true;
		return null;
	}
}