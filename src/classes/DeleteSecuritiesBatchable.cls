global class DeleteSecuritiesBatchable implements Database.Batchable<sObject> {

	global Database.QueryLocator start(Database.BatchableContext context) {
		return Database.getQueryLocator('SELECT Id FROM XLR8_Securities__c');
	}
	
	global void execute(Database.BatchableContext context, List<XLR8_Securities__c> records) {
		delete records;
	}
	
	global void finish(Database.BatchableContext context){
		Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
		User user1 = [SELECT Email FROM User WHERE Id = :UserInfo.getUserId()];
		message.setToAddresses(new String[] { user1.email });
		message.setSubject('Mass security deletion is complete');
		message.setPlainTextBody('The mass deletion of all security records is complete.');
		Messaging.sendEmail(new Messaging.Email[] { message });
	}
}