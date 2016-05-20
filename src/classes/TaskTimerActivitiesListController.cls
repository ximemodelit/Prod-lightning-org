/* This class is used to mimic a related list in the Task page layout
   @author Angelica Buffa
   @since March 2015
*/
public with sharing class TaskTimerActivitiesListController {
    
    // Private instance variables
    private TaskTimerAtivitiesPaginator paginator { get; set; }
    private ID taskId { get; set; }
    
    // Constructor
    public TaskTimerActivitiesListController(ApexPages.StandardController stdController){
        taskId = stdController.getId();
        paginator = new TaskTimerAtivitiesPaginator(taskId);
    }
    
    public String getCreateNewURL(){
        String url = Page.TaskTimer.getURL() + '?Id=' + taskId;
        return url;
    }
    
 
    public PageReference deleteTaskTimer(){
        String activityId= ApexPages.currentPage().getParameters().get('activityId'); 
        Task_Timer_Activity__c task = TaskTimerUtils.getTaskTimerActivity(activityId);
     
        if (task != null){
            try{
                delete task;
            }catch (Exception ex){}
        }
        
        return new PageReference('/' + taskId);
        
    }
    
    /* This method returns the activities that must be displayed
       @param -
       @return List of activities
     */
    public List<Task_Timer_Activity__c> getActivities(){
        return paginator.getActivities();
    }
    
    /* This method displays the first page
       @param -
       @return PageReference
     */
    public PageReference firstPage() { 
        return paginator.firstPage();
    }
 
    /* This method displays the previous page
       @param -
       @return PageReference
     */
    public PageReference previousPage() { 
        return paginator.previousPage();
    }
 
    /* This method displays the next page
       @param -
       @return PageReference
     */
    public PageReference nextPage() { 
        return paginator.nextPage();
    }
 
    /* This method displays the last page
       @param -
       @return PageReference
     */
    public PageReference lastPage() {
        return paginator.lastPage();
    }
    
    /* This method disables the previous and first buttons if you are at the first page
       @param -
       @return true if the first page is displayed
     */
    public Boolean getDisablePrevious() { 
        return paginator.getDisablePrevious();
    }
 
    /* This method disables the next and end buttons if there are no more pages
       @param -
       @return true if there are no more pages
     */
    public Boolean getDisableNext() { 
        return paginator.getDisableNext();
    }
 
    /* This method returns the total number of Task Timer Activity records related to current task
       @param -
       @return number of records
     */
    public Integer getrecordsCount() {
        return paginator.getrecordsCount();
    }
    
    public Integer getPageNumber() {
        return paginator.getPageNumber();
    }
 
    public Integer getTotalPages() {
        return paginator.getTotalPages();
     }
     
     public boolean getIsTaskActivityTimerDeletable(){
        return Schema.sObjectType.Task_Timer_Activity__c.isDeletable();
     }
    
}