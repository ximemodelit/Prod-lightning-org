@isTest
private class MeaningfulActivityManager_TB {

	@isTest 
	private static void handles200Tasks() {
		Date theDate = Date.today().addDays(-3);
		Integer numTasks = 200;

		List<Account> accounts = new List<Account>();
		for (Integer i = 0; i < 200; i++) {
			Account account1 = new Account(
				Name = 'test'
			);
			accounts.add(account1);
		}
		insert accounts;
		
		List<Task> tasks = new List<Task>();
		for (Integer i = 0; i < 200; i++) {
			Task task1 = new Task(
				WhatId = accounts[i].Id,
				Subject = 'test',
				ActivityDate = theDate,
				Status = 'Completed',
				Meaningful_Activity__c = 'Last Estate Plan Review'
			);
			tasks.add(task1);
		}

		insert tasks;

		Account account1 = [SELECT Last_Estate_Plan_Review__c FROM Account WHERE Id = :accounts[1].Id];
		System.assertEquals(Date.today(), account1.Last_Estate_Plan_Review__c);
	}
}