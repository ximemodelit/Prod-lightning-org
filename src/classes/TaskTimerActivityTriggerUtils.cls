public with sharing class TaskTimerActivityTriggerUtils {

    public void afterInsert(List<Task_Timer_Activity__c> newActivities){
        insertTotalHours(newActivities);
    }
    
    public void afterUpdate(List<Task_Timer_Activity__c> newActivities, Map<Id,Task_Timer_Activity__c > oldActivities){
        updateTotalHours(newActivities, oldActivities);
    }
    
    public void afterDelete(List<Task_Timer_Activity__c> oldActivities){
        deleteTotalHours(oldActivities);
    }
    
    private void insertTotalHours(List<Task_Timer_Activity__c> newActivities){
        Set<Id> taskIds = new Set<Id>();
        Map<Id, List<Task_Timer_Activity__c>> activitiesMap = new Map<Id, List<Task_Timer_Activity__c>>();
        for (Task_Timer_Activity__c activity : newActivities){
            if (activity.Task_ID__c != null){
                taskIds.add(activity.Task_ID__c);
                
                if (!activitiesMap.containsKey(activity.Task_ID__c)){
                    activitiesMap.put(activity.Task_ID__c, new List<Task_Timer_Activity__c>());
                }
                activitiesMap.get(activity.Task_ID__c).add(activity);
            }
        }
        
        List<Task> tasks = null;
        if (taskIds.size() > 0){
            tasks = TaskTimerUtils.getTasks(taskIds);       
        }       
        
        if (tasks != null && tasks.size() > 0){
            for (Task task : tasks){
                List<Task_Timer_Activity__c> taskActivities = activitiesMap.get(task.Id);
                if (taskActivities != null){
                    for (Task_Timer_Activity__c activity : taskActivities){
                        Decimal duration = activity.Duration__c;
                        if (duration == null){
                            duration = 0;
                        }
                        if (activity.Billable__c){
                            if (task.Timer_Billable_Hours__c == null){
                                task.Timer_Billable_Hours__c = duration;
                            }else{
                                task.Timer_Billable_Hours__c += duration;
                            }                           
                        }else{
                            if (task.Timer_Non_Billable_Hours__c == null){
                                task.Timer_Non_Billable_Hours__c = duration;
                            }else{
                                task.Timer_Non_Billable_Hours__c += duration;
                            }
                        }
                    }
                }
            }
            try{
                update tasks;   
            }catch (Exception ex){}             
        }   
    }

    private void updateTotalHours(List<Task_Timer_Activity__c> newActivities, Map<Id,Task_Timer_Activity__c > oldActivities){
        Set<Id> taskIds = new Set<Id>();
        Map<Id, List<Task_Timer_Activity__c>> activitiesMap = new Map<Id, List<Task_Timer_Activity__c>>();
        for (Task_Timer_Activity__c activity : newActivities){
            if (activity.Task_ID__c != null && 
                (activity.Duration__c != oldActivities.get(activity.Id).Duration__c ||
                activity.Billable__c != oldActivities.get(activity.Id).Billable__c)){
                taskIds.add(activity.Task_ID__c);
                
                if (!activitiesMap.containsKey(activity.Task_ID__c)){
                    activitiesMap.put(activity.Task_ID__c, new List<Task_Timer_Activity__c>());
                }
                activitiesMap.get(activity.Task_ID__c).add(activity);
            }
        }
        
        List<Task> tasks = null;
        if (taskIds.size() > 0){
            tasks = TaskTimerUtils.getTasks(taskIds);       
        }       
        
        if (tasks != null && tasks.size() > 0){
            for (Task task : tasks){
                List<Task_Timer_Activity__c> taskActivities = activitiesMap.get(task.Id);
                if (taskActivities != null){
                    for (Task_Timer_Activity__c activity : taskActivities){
                        Decimal duration = activity.Duration__c;
                        Decimal previousDuration = oldActivities.get(activity.Id).Duration__c;
                        if (duration == null){
                            duration = 0;
                        }
                        if (previousDuration == null){
                            previousDuration = 0;
                        }
                        
                        // Verify if billable condition changed and adjust the totals accordingly to the change
                        if (oldActivities.get(activity.Id).Billable__c != activity.Billable__c){
                            // If we pass from non-billable to billable
                            if (activity.Billable__c){
                                // Decrease old duration from non billable and add old duration to billable
                                if (task.Timer_Non_Billable_Hours__c != null){
                                    task.Timer_Non_Billable_Hours__c -= previousDuration;
                                }
                                
                                if (task.Timer_Billable_Hours__c == null){
                                    task.Timer_Billable_Hours__c = previousDuration;
                                }else{
                                    task.Timer_Billable_Hours__c += previousDuration;
                                }
                            // if we pass from billable to non-billable
                            }else{
                                // Decrease old duration from billable and add old duration to non-billable
                                if (task.Timer_Billable_Hours__c != null){
                                    task.Timer_Billable_Hours__c -= previousDuration;
                                }
                                
                                if (task.Timer_Non_Billable_Hours__c == null){
                                    task.Timer_Non_Billable_Hours__c = previousDuration;
                                }else{
                                    task.Timer_Non_Billable_Hours__c += previousDuration;
                                }
                            }
                        }   
                        
                        // Verify if the duration changed and adjust it accordingly to the is billable condition
                        if (oldActivities.get(activity.Id).Duration__c != activity.duration__c) {
                            if (activity.Billable__c){
                                if (task.Timer_Billable_Hours__c == null){
                                    task.Timer_Billable_Hours__c = duration;
                                }else{
                                    task.Timer_Billable_Hours__c -= previousDuration;
                                    task.Timer_Billable_Hours__c += duration;
                                }   
                            }else{
                                if (task.Timer_Non_Billable_Hours__c == null){
                                    task.Timer_Non_Billable_Hours__c = duration;
                                }else{
                                    task.Timer_Non_Billable_Hours__c -= previousDuration;
                                    task.Timer_Non_Billable_Hours__c += duration;
                                }
                            }                               
                        }
                    }
                }                   
            }   
            try{
                update tasks;   
            }catch (Exception ex){}     
        }
    }
    
    private void deleteTotalHours(List<Task_Timer_Activity__c> oldActivities){
        Set<Id> taskIds = new Set<Id>();
        Map<Id, List<Task_Timer_Activity__c>> activitiesMap = new Map<Id, List<Task_Timer_Activity__c>>();
        for (Task_Timer_Activity__c activity : oldActivities){
            if (activity.Task_ID__c != null){
                taskIds.add(activity.Task_ID__c);
                
                if (!activitiesMap.containsKey(activity.Task_ID__c)){
                    activitiesMap.put(activity.Task_ID__c, new List<Task_Timer_Activity__c>());
                }
                activitiesMap.get(activity.Task_ID__c).add(activity);
            }
        }
        
        List<Task> tasks = null;
        if (taskIds.size() > 0){
            tasks = TaskTimerUtils.getTasks(taskIds);       
        }       
        
        if (tasks != null && tasks.size() > 0){
            for (Task task : tasks){
                List<Task_Timer_Activity__c> taskActivities = activitiesMap.get(task.Id);
                if (taskActivities != null){
                    for (Task_Timer_Activity__c activity : taskActivities){
                        Decimal duration = activity.Duration__c;
                        if (duration == null){
                            duration = 0;
                        }
                        
                        if (activity.Billable__c){
                            if (task.Timer_Billable_Hours__c != null){
                                task.Timer_Billable_Hours__c -= duration;
                            }                           
                        }else{
                            if (task.Timer_Non_Billable_Hours__c != null){
                                task.Timer_Non_Billable_Hours__c -= duration;
                            }
                        }
                    }
                }
            }
            try{
                update tasks;   
            }catch (Exception ex){}             
        }   
    }
}