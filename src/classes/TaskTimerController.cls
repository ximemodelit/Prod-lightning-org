/*
* This class contains logic to display the timer for tasks
* @author Angelica Buffa
* @since February 2015
*/
public with sharing class TaskTimerController {

	// Private instance variables
	
	public Id recordId { get; set; }
	@testVisible
	private Task task { get; set; }
	
	// Public instance variables
    public String duration {get; set;}
    public Boolean showTimer{get; set;}
   	public Task_Timer_Activity__c timerActivity { get; set; }
   	public String taskSubject { get; set; }
   	public Id taskId {get;set;}

	// Constructor
    public TaskTimerController(){    
        recordId = ApexPages.currentPage().getParameters().get('Id');
        init();
    }      
    
    public String getTaskURL(){
    	String taskUrl = URL.getSalesforceBaseUrl().toExternalForm() + '/' + taskId;
    	return taskUrl;
    }
    /* 
     * This method initialize the values to be displayed on the page
     * The page can be accessed from the Task Page Layout, or Task Timer Activity page layout
     * Based on the location, different actions must be performed:
    		If it is opened from a task, we will log a new time
    		If it is openened from a task  timer activity record, we will increase the duration
     * @param -
     * @return -
     */
    private void init(){		
    	if (recordId != null ){    		
        	if (recordId.getSobjectType() == Schema.Task.SObjectType){ 	        		  
	        	showTimer= false;
				duration = '00:00:00';
				timerActivity = new Task_Timer_Activity__c(); 
				task = TaskTimerUtils.getTask(recordId);     	  	        	        	
	        }else  if (recordId.getSobjectType() == Schema.Task_Timer_Activity__c.SObjectType){
	        	showTimer= true;
	        	timerActivity = TaskTimerUtils.getTaskTimerActivity(recordId);  	        	       	 
	        	duration = convertDecimalDurationToString();   
        	}
    	}
    	
    	if (task != null){
        	taskSubject= task.Subject;
        	taskId = task.Id;
        }else if (timerActivity != null){
        	taskId = timerActivity.Task_ID__c;
        	taskSubject= timerActivity.Task_Subject__c;
        }
    }
    
    /*
     * Saves the time that has passed in the timer after converting 
     * it to the format of Duration__c field
     * @return PageReference
     */ 
    public void SaveTime(){        
        Decimal decToAdd = 0;
        //get the time to be added to duration__c
        String timeToBeAdded = ApexPages.currentPage().getParameters().get('timeToAdd');
        system.debug('@@@@ time to add ' + timeToBeAdded);
        //split the string to divide the diff time units
        List<String> timeUnits = timeToBeAdded.split(':',-1);
        //add the hours
        decToAdd += Decimal.valueOf(timeUnits.get(0));
        //add the minutes
        if(Decimal.valueOf(timeUnits.get(2)) > 29){//if seconds > 29 add another minute
            decToAdd += (Decimal.valueOf(timeUnits.get(1)) + 1) / 60;
        }else{
            decToAdd += (Decimal.valueOf(timeUnits.get(1)) / 60);
        }
        
         system.debug('@@@@ time to decToAdd ' + decToAdd);
        timerActivity.Duration__c = decToAdd;
             
        try{        	
            update timerActivity;
        }catch(System.DMLException e){
            ApexPages.addMessages(e);
        }
    }
    
    /*
     * Converts the argument decDuration into string to use with js
     * @param Decimal - decDuration: decimal to be converted
     * @return String: returns the time converted to a string with this format '00:00:00'
     */ 
    private String convertDecimalDurationToString(){
        
        String stringDecimal = '';
        Decimal decimalDuration = 0;
        //if it is one digit, add one zero before
        
        if (timerActivity != null && timerActivity.Duration__c != null){
        	decimalDuration = timerActivity.Duration__c;
        }
        
    	if(decimalDuration.intValue() <= 9){
            stringDecimal = '0'+ decimalDuration.intValue() + ':';
        }else{    
            stringDecimal = decimalDuration.intValue() + ':';
        } 
        
        //get the minutes   
        Decimal zeroAndDec = decimalDuration - decimalDuration.round(System.RoundingMode.FLOOR);
        Integer minutes = (Integer)(zeroAndDec * 60);
        
        //if it is one digit, add one zero before
        if(minutes <= 9){
            stringDecimal += '0' + minutes + ':00';
        }else{
            stringDecimal += minutes + ':00';
        }
        system.debug('@@@@ time to decToAdd ' + stringDecimal);
        return stringDecimal;
    }
    
    /*
    * This method logs the time when the timer is invoked from the Task Page layout
    * @param -
    * @return -
    */
    public void save(){
    
    	// Upsert current Task Timer Activity record
    	upsertTaskTimerActivity();
    	
    	// Show the timer
    	showTimer= true;
	
    	// Set the duration in case it is set on the page
    	duration = convertDecimalDurationToString();   
    	
    }
    
    
    /*
    * This method upserts a TaskTimerActivity record
    * @param -
    * @return -
    */
    private void upsertTaskTimerActivity(){
    	
		try{
			if (timerActivity.Id == null){
				timerActivity.Task_ID__c = taskId;
			}
			timerActivity.Task_Subject__c = taskSubject;
			upsert timerActivity;
		}catch (Exception ex){
			
		}

    }
}