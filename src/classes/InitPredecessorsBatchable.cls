global class InitPredecessorsBatchable implements Database.Batchable<SObject> {

	global Database.QueryLocator start(Database.BatchableContext context) {
		return Database.getQueryLocator([SELECT Id FROM Process__c WHERE Status__c != 'Completed']);
	}
	
	global void execute(Database.BatchableContext context, List<Process__c> processes) {
		InitPredecessors mgr = new InitPredecessors();
		mgr.initPredecessors(processes);
	}
	
	global void finish(Database.BatchableContext context) {
	}
	
	public static void run() {
		InitPredecessorsBatchable b = new InitPredecessorsBatchable();
		Database.executeBatch(b);
	}
}