/*
 * Utils class for ProjectTimerController
 * 
 * @author Ximena Lasserre
 * @since 01-2015
 */
public with sharing class TaskTimerUtils {
	
	
   /*
    * This method returns a task timer activity record for a given task timer activity Id
    * @param id of the record that must be returned
    * @return task timer activity
    */
    public static Task_Timer_Activity__c getTaskTimerActivity(Id recordId){        
       	Task_Timer_Activity__c timer = null;
       	
		if (recordId != null){
			List<Task_Timer_Activity__c> records = [Select Id,Date__c,Description__c ,Billable__c ,Duration__c, Task_ID__c, Task_Subject__c 
											From Task_Timer_Activity__c
											Where Id =: recordId];
			
			if (records.size() > 0){
				timer = records.get(0);
			}
       	}
       	
       	return timer;
    }
    
    
    /*
    * This method returns a list of task timer activities for a given task id
    * @param id of the record that must be returned
    * @return task timer activity
    */
    public static List<Task_Timer_Activity__c> getTaskTimerActivities(Id taskId, Integer pageOffset){        
       	List<Task_Timer_Activity__c> activities = null;
       	
		if (taskId != null){
			activities = [Select Id, Name, Date__c,Description__c ,Billable__c ,Duration__c, Task_ID__c , Task_Subject__c
											From Task_Timer_Activity__c
											Where Task_ID__c =: taskId																					
											order by Description__c asc
											limit 5	
											offset : pageOffset];
       	}
       	
       	return activities;
    }
    
    /*
    * This method returns a list of task timer activities for a given task id
    * @param id of the record that must be returned
    * @return task timer activity
    */
    public static List<Task_Timer_Activity__c> getTaskTimerActivities(Set<Id> taskIds){        
       	List<Task_Timer_Activity__c> activities = null;
       	
		if (taskIds != null){
			activities = [Select Id, Task_Subject__c, Task_ID__c from Task_Timer_Activity__c where Task_ID__c IN : taskIds];
       	}
       	
       	return activities;
    }
    
    /*
    * This method returns the number of task timer activities for a given task
    * @param id of the record that must be returned
    * @return task timer activity
    */
    public static Integer getTaskTimerActivitiesCount(Id taskId){        
       	Integer recordsCount = 0;
       	
		if (taskId != null){
			recordsCount = [select count() from Task_Timer_Activity__c where Task_ID__c =: taskId]; 
       	}
       	
       	return recordsCount;
    }
    
    /*
    * This method returns a task for a given task Id
    * @param id of the task that must be returned
    * @return task
    */
    public static Task getTask(Id recordId){        
       	Task task = null;
       	
		if (recordId != null){
			List<Task> records = [Select Id, Subject
											From Task
											Where Id =: recordId];
			
			if (records.size() > 0){
				task = records.get(0);
			}
       	}
       	
       	return task;
    }
    
    
    
    
    public static List<Task> getTasks(Set<Id> taskIds){
    	List<Task> tasks = null;
    	
    	if (taskIds != null && taskIds.size() > 0){
    		tasks = [Select Id, Timer_Billable_Hours__c, Timer_Non_Billable_Hours__c from Task where Id IN : taskIds];
    	}
    	
    	return tasks;
    }
}