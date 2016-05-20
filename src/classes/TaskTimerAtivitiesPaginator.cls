public with sharing class TaskTimerAtivitiesPaginator {
	
	private ID taskId { get; set; }
	private Integer counter { get; set; }  //keeps track of the offset
   	private Integer maxRecordsPerPage { get; set; } //sets the page size or number of rows
   	
   	public Integer recordsCount { get; set; } //used to show user the total size of the list
 
   	public TaskTimerAtivitiesPaginator(ID taskId) {
   		this.taskId = taskId;
   		init();
   	}
 	
 	private void init(){
 		counter = 0;
   		maxRecordsPerPage = 5;
   		recordsCount = TaskTimerUtils.getTaskTimerActivitiesCount(taskId); //set the total size in the constructor
 	}
 	
   	public List<Task_Timer_Activity__c> getActivities(){        
       	return TaskTimerUtils.getTaskTimerActivities(taskId, counter);
    }
 
   	public PageReference firstPage() { //user clicked beginning
      	counter = 0;
      	return null;
   	}
 
   	public PageReference previousPage() { //user clicked previous button
      	counter -= maxRecordsPerPage;
      	return null;
   	}
 
   	public PageReference nextPage() { //user clicked next button
      	counter += maxRecordsPerPage;
      	return null;
   	}
 
   	public PageReference lastPage() { //user clicked end
      	counter = recordsCount - math.mod(recordsCount, maxRecordsPerPage);
      	return null;
   	}
 
   	public Boolean getDisablePrevious() { 
      	//this will disable the previous and beginning buttons
      	return counter == 0;
   	}
 
   	public Boolean getDisableNext() { //this will disable the next and end buttons
      	return (counter + maxRecordsPerPage >= recordsCount);
   	}
 
   	public Integer getrecordsCount() {
      	return recordsCount;
   	}
 
   	public Integer getPageNumber() {
      	return counter/maxRecordsPerPage + 1;
   	}
 
   	public Integer getTotalPages() {
      	if (math.mod(recordsCount, maxRecordsPerPage) > 0) {
         	return recordsCount/maxRecordsPerPage + 1;
      	} else {
         	return (recordsCount/maxRecordsPerPage);
      	}
  	 }
}