@isTest
private class DeleteSecuritiesBatchable_T {
		
	@isTest
	private static void test() {
		
		XLR8_Securities__c security = new XLR8_Securities__c();
		insert security;
		
		Test.startTest();
		
		DeleteSecuritiesBatchable b = new DeleteSecuritiesBatchable();
		Database.executeBatch(b);
		Test.stopTest();
		
		List<XLR8_Securities__c> securities = [SELECT Id FROM XLR8_Securities__c];
		System.assert(securities.isEmpty());
	}

}