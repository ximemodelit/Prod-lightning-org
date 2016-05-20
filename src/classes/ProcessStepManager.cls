public without sharing class ProcessStepManager {

    public void populateSequences(List<Process_Step__c> steps) {
        Set<Id> processIds = new Set<Id>();
        for (Process_Step__c step : steps) {
            processIds.add(step.Process__c);
        }
        AggregateResult[] results = [SELECT Process__c ProcessId, MAX(Sequence__c) MaxSeq FROM Process_Step__c 
            WHERE Process__c IN :processIds GROUP BY Process__c ];
        Map<Id, Double> maxSequenceByProcess = new Map<Id, Double>();
        for (AggregateResult result : results) {
            maxSequenceByProcess.put((Id) result.get('ProcessId'), (Double) result.get('MaxSeq'));
        }
        for (Process_Step__c step : steps) {
            if (step.Sequence__c == null) {
                Double maxSequence = maxSequenceByProcess.get(step.Process__c);
                if (maxSequence == null) {
                    maxSequence = 0;
                }
                step.Sequence__c = maxSequence + 1;
            }
        }
    }
    
    public void populatePredecessorSequences(List<Id> newStepIds) {
        List<Process_Step__c> newSteps = [SELECT Process__c, Sequence__c,
            (SELECT ParentStep__c, PredecessorStep__c, PredecessorStep__r.Sequence__c 
            FROM Process_Step_Junctions_Parent__r ORDER BY PredecessorStep__r.Sequence__c)
            FROM Process_Step__c WHERE Id IN :newStepIds];
        Map<Id, Process_Step__c> mapNewSteps = new Map<Id, Process_Step__c>(
            newSteps);
        Set<Id> processIds = new Set<Id>();
        for (Process_Step__c step : newSteps) {
            processIds.add(step.Process__c);
        }
        List<Process_Step__c> steps = [SELECT Process__c, Sequence__c,
            (SELECT ParentStep__c, PredecessorStep__c, PredecessorStep__r.Sequence__c 
            FROM Process_Step_Junctions_Parent__r ORDER BY PredecessorStep__r.Sequence__c)
            FROM Process_Step__c WHERE Process__c IN :processIds];
        Map<Id, Map<Id, Process_Step__c>> processMap = 
                new Map<Id, Map<Id, Process_Step__c>>(); 
        for (Process_Step__c step : newSteps) {
            if (step.Process_Step_Junctions_Parent__r == null) {
                step.Predecessor_Steps__c = null;
                continue;
            }
            List<String> sequences = new List<String>();
            for (Process_Step_Junction__c junction : step.Process_Step_Junctions_Parent__r) {
                sequences.add(String.valueOf(junction.PredecessorStep__r.Sequence__c));
            }           
            step.Predecessor_Steps__c = String.join(sequences, ', ');
        }
        if (isProcessStepUpdateable()){
            update newSteps;
        }
    }

    public void deleteJunctionObjectsForSteps(List<Process_Step__c> steps) { 
        List<Process_Step_Junction__c> junctions = [SELECT Id 
            FROM Process_Step_Junction__c 
            WHERE PredecessorStep__c IN :steps]; 
        Boolean isDeleteable = Schema.sObjectType.Process_Step_Junction__c.isDeletable();
        if (isDeleteable){
            delete junctions;
        }
    }
    
    public void updateRelatedTasks(Map<Id,Process_Step__c> steps, Map<Id,Process_Step__c> oldSteps) {
        Set<ID> stepIDs = new Set<ID>();
        
        // Verify if the status has changed and it is not null
        for (Process_Step__c processStep: steps.values()) {
            if (processStep.Status__c != null && processStep.Status__c.trim().length() > 0 && 
               (oldSteps == null || (oldSteps != null && oldSteps.get(processStep.Id).Status__c != processStep.Status__c))) {
                stepIDs.add(processStep.Id);            
            }
        }
        
        
        if (!stepIds.isEmpty()) {
            List<Task> tasks = XLR8TaskUtils.getProcessStepTasks(stepIDs);
            if (tasks != null && tasks.size() > 0){
                
                // Set the status of tasks
                for (Task task : tasks) {
                    String stepStatus = steps.get(task.WhatID).Status__c;
                    if (stepStatus.equalsIgnoreCase('N/A')){
                        task.Status = 'Cancelled';
                    }else if (stepStatus.equalsIgnoreCase('Completed')){
                        task.Status = 'Completed';
                    }else if (stepStatus.equalsIgnoreCase('Open')){
                        task.Status = 'Not Started';
                    }else if (stepStatus.equalsIgnoreCase('Cancelled')){
                        task.Status = 'Cancelled';
                    }                   
                }
                
                //Update the tasks allowing to commit just the successfull changes
                if (isTaskUpdateable()){
                    Database.update(tasks, false);
                }
            }
        }    
    }   

    public void autoCreateTasks(List<Process_Step__c> steps) {
        Set<ID> processIds = new Set<ID>();
        for (Process_Step__c processStep: steps) {
            processIDs.add(processStep.Process__c);              
        }
        if (!processIds.isEmpty()) {
            AutoCreateTasks.processSteps(processIDs);
        }
    }   
    
    public void handleStatusChange(List<Process_Step__c> steps, Map<Id, Process_Step__c> oldStepMap) {
        for (Process_Step__c step : steps) {
            Process_Step__c oldStep = oldStepMap.get(step.Id);
            if (oldStep.Status__c != step.Status__c && step.Status__c != null) {
                if ('Open'.equalsIgnoreCase(step.Status__c)) {
                    step.Completed_By__c = null;
                    step.Completed_Date__c = null;
                }
                else if ('N/A'.equalsIgnoreCase(step.Status__c)
                    || step.Status__c.equalsIgnoreCase('Completed')
                    || step.Status__c.equalsIgnoreCase('Cancelled')) {
                    if (step.Completed_By__c == null) {
                        step.Completed_By__c = Userinfo.getUserId();
                    }
                    if (step.Completed_Date__c == null) {
                        step.Completed_Date__c = Date.today();
                    }
                }
            }
        }
    }   
    
    public void validateUniqueName(List<Process_Step__c> steps) {
        if (steps.size() > 1) {
            return;
        }
        for (Process_Step__c step: steps) {
            if (step.Process__c != null) {
                List<Process_Step__c> stepList = [SELECT Id, name, Process__c from  Process_Step__c 
                where Process__c =: step.Process__c
                AND name =: step.name AND id <>: step.id]; 
                if (!stepList.isEmpty()) {
                    step.Name.addError('Process step name is already in use');
                }
            }
            //Requeriments on Planio ticket #332
            /*List<Process_Step__c> stepList = [SELECT Id, name, Process__c, sequence__c 
                from Process_Step__c where Process__c =: step.Process__c
                AND sequence__c =: step.sequence__c AND id <>: step.id]; 
            if (!stepList.isEmpty()) {
                step.sequence__c.addError('This sequence number is already in use.'
                    + ' Please select another sequence number. ');
            }  */          
        }
    }
    
    private static Boolean isProcessStepUpdateable(){
        return (Schema.sObjectType.Process_Step__c.isUpdateable() && Process_Step__c.Predecessor_Steps__c.getDescribe().isUpdateable());
    }
    
    private static Boolean isTaskUpdateable(){
        return (Schema.Sobjecttype.Task.isUpdateable() &&  Task.Status.getDescribe().isCreateable());
    }
}