/*
 * Handles various activities related to Tasks. Current implementation sets the 
 * "Meaingful Activity Flat" field. 
 ************************************************************************************************************************
 * Revision History
 * Change #     Developer       Date        Description
 ************************************************************************************************************************
 * 1.1         Jason Landry    02/12/15     PlanIO 710 - Exception on Comment when FYI checked, but user not selected
 */
public without sharing class TaskManager {
    
    private Map<Id, User> userMap;
    private User runningUser;
    @TestVisible private static Boolean taskHistoryRecordsCreated = false;
    private static Boolean commentHistoryUpdated = false;
    
    /*
     * Call from before insert and before update triggers
     */
    public void beforeInsertUpdate(Map<Id, Task> oldTaskMap, List<Task> newTasks) {
        buildMaps(newTasks);
        runningUser = [SELECT Name, Alias FROM User WHERE Id = :UserInfo.getUserId()];

        for (Task newTask : newTasks) {
            newTask.Activity_Date__c = newTask.ActivityDate;
            Task oldTask;
            if (oldTaskMap != null) {
                oldTask = oldTaskMap.get(newTask.Id);
            }
            if (oldTask == null || 
                    oldTask.Meaningful_Activity__c != newTask.Meaningful_Activity__c) {
                setMeaningfulActivityFlat(newTask);
            }
            
            if ((oldTask == null || oldTask.Status != newTask.Status) 
                && (newTask.Status == 'Completed' || newTask.Status == 'Cancelled') && newTask.Completion_Date__c == null && newTask.Import_Id__c == null) {
                newTask.Completion_Date__c = Date.today();
            }
            
            if (!commentHistoryUpdated) {
                updateComments(newTask, oldTask);
            }
        }
    }
    
    public void beforeDelete(List<Task> tasks) {
        List<Id> taskIds = new List<Id>();
        Map<Id, Task> taskMap = new Map<Id, Task>();
        for (Task task1 : tasks) {
            taskIds.add(task1.Id);
            taskMap.put(task1.Id, task1);
        }
        List<Task> tasksWithType = [SELECT Id, What.Type FROM Task WHERE Id IN :taskIds];
        for (Task task1 : tasksWithType) {
            if (task1.What != null && task1.What.Type.endsWith('Process__c')) {
                Task taskToReject = taskMap.get(task1.Id);
                taskToReject.addError('Cannot delete a Process Master Task');
            }
        }
    }
    
    public void afterInsert(Map<Id, Task> newTaskMap) {
        system.debug('&&&&&& ' + taskHistoryRecordsCreated);
        if (!taskHistoryRecordsCreated) {
            createTaskHistoryRecords(newTaskMap.values(), false);
        }
    }
    
    public void afterUpdate(Map<Id, Task> oldTaskMap, Map<Id, Task> newTaskMap) {
        if (!taskHistoryRecordsCreated) {
            createTaskHistoryRecords(newTaskMap.values(), false);
        }
        updateTaskTimerActivityStatus(oldTaskMap, newTaskMap);
    }
    
    public void afterDelete(List<Task> tasks) {
        if (!taskHistoryRecordsCreated) {
            createTaskHistoryRecords(tasks, true);
        }
    }
    
    private boolean useTaskHistory(){
        Boolean useTaskHistory = false;
        Settings__c settings = null;
        system.debug('&&&&&& ' + Settings__c.getAll());
        if (Settings__c.getAll() != null && Settings__c.getAll().size() > 0){
            settings = Settings__c.getAll().values().get(0);    
        }
        
        if (settings != null && settings.useTaskHistory__c){
            useTaskHistory = true;
        }
        
        return useTaskHistory;
    }
    
    private void updateTaskTimerActivityStatus(Map<Id, Task> oldTaskMap, Map<Id, Task> newTaskMap){
        Map<Id, Task> tasks = new Map<Id, Task>();
        for (Task task : newTaskMap.values()){
            if (task.Subject != oldTaskMap.get(task.Id).Subject){
                tasks.put(task.Id, task);
            }               
        }
        List<Task_Timer_Activity__c> activities = null;
        if (tasks.size() > 0){
            activities = TaskTimerUtils.getTaskTimerActivities(tasks.keySet());         
        }
        
        if (activities != null && activities.size() > 0){
            for (Task_Timer_Activity__c activity : activities){
                activity.Task_Subject__c = tasks.get(activity.Task_ID__c).Subject;
            }
            
            try{
                update activities;
            }catch (Exception ex){}
        }
        
    }
    
    private void createTaskHistoryRecords(List<Task> tasks, Boolean isDelete) {
        taskHistoryRecordsCreated = true;
        Boolean useTaskHistory =  useTaskHistory();
        List<Task_History__c> histories = new List<Task_History__c>();          
        system.debug('&&&&& ' + useTaskHistory);
        if (useTaskHistory){
            for (Task task1 : tasks) {
                Task_History__c history = makeTaskHistory(task1);
                if (isDelete) {
                    history.Status__c = 'Deleted';
                }
                histories.add(history);
            }
            insert histories;
        }
    }
    
    private Task_History__c makeTaskHistory(Task task1) {
        Task_History__c history = new Task_History__c(
            Activity_ID__c = task1.Id,
            Comments__c = task1.Description,
            Status__c = task1.Status,
            Subject__c = task1.Subject,
            Due_Date__c = task1.ActivityDate,
            Completion_Date__c = task1.Completion_Date__c,
            Assigned_To_ID__c = task1.OwnerId,
            Priority__c = task1.Priority,
            Category__c = task1.Category__c,
            Task_Type__c = task1.Task_Type__c,
            Task_Sub_Category__c = task1.Sub_Category_Task__c,
            Task_Duration__c = task1.Task_Duration__c,
            Meaningful_Activity__c = task1.Meaningful_Activity__c,
            Related_To_ID__c = task1.WhatId,
            Contact_Lead_ID__c = task1.WhoId 
        );
        return history;
    }

    private void buildMaps(List<Task> newTasks) {
        Set<Id> userIds = new Set<Id>();
        for (Task newTask : newTasks) {
            userIds.add(newTask.CreatedById);
        }
        userMap = new Map<Id, User>([SELECT Name, Alias FROM User WHERE Id IN :userIds]);
    }
    
    private void updateComments(Task newTask, Task oldTask) {
        commentHistoryUpdated = true;
        if (newTask.Description == null) {
            return;
        }
        if ((oldTask != null && newTask.Description != oldTask.Description)
            || oldTask == null || newTask.Send_FYI__c) {
            String userAlias = runningUser.Alias;
            String description = Datetime.now().formatLong() + ' ' + userAlias; 
             
            //if (newTask.Send_FYI__c) { 1.1 --
            if (newTask.Send_FYI__c && newTask.FYI_List__c != null){ //1.1++
                description += ' FYI to ';
                Boolean first = true;
                for (String fyiValue : newTask.FYI_List__c.split(';')) {
                    if (!first) {
                        description += ', '; 
                    }
                    description += fyiValue;
                    first = false;
                }
            }
            description += '\r\n' + newTask.Description;
            newTask.Description = description;
        }
    }
    
    private void setMeaningfulActivityFlat(Task t) {
        if (t.Meaningful_Activity__c == null) {
            t.Meaningful_Activity_Flat__c = null;
            return;
        }
        String flatValue = '';
        t.Meaningful_Activity_Flat__c = t.Meaningful_Activity__c;
    }
    
    private String taskClosedStatus() {
        TaskStatus ts = [SELECT MasterLabel FROM TaskStatus WHERE IsClosed = TRUE LIMIT 1];
        return ts.MasterLabel;
    }
}