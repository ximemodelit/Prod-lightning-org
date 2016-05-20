/* This class contains methods to insert, update, and retrieve information from the Task table
 * @author Angelica Buffa
 * @since February, 2015
 */
public with sharing class XLR8TaskUtils {
	
	public static List<Task> getProcessStepTasks(Set<Id> procesStepIds){
		List<Task> tasks = null;
		
		if (procesStepIds != null && procesStepIds.size() > 0){		
			tasks = [SELECT Id, Status, WhatID 
			 		   FROM Task 
			 		  WHERE WhatID IN : procesStepIds];
		}
		
		return tasks;			
	}
}