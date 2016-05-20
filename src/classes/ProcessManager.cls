public without sharing class ProcessManager {

    public static String PROCESS_STATUS_NOT_STARTED = 'Not Started';
    public static String PROCESS_STATUS_COMPLETED = 'Completed';
    public static String PROCESS_STATUS_IN_PROGRESS = 'In Progress';
    public static String PROCESS_STATUS_CANCELLED = 'Cancelled';
    public static String PROCESS_STEP_STATUS_OPEN = 'Open';
    public static String PROCESS_STEP_STATUS_N_A = 'N/A';
    public static String PROCESS_STEP_STATUS_COMPLETED = 'Completed';
    public static String PROCESS_STEP_STATUS_CANCELLED = 'Cancelled';
    
    private List<Process__c> processes;
    private Map<Id,Process__c> processesMap;
    private ProcessUtils processUtils = new ProcessUtils();
    
    public void beforeInsert(List<Process__c> processes, Map<Id,Process__c> processesMap) {
        this.processes = processes;
        this.processesMap = processesMap;
        setDefaultValues();
        validateNew();
        validateDeadline();
    }
    
    public void beforeUpdate(List<Process__c> processes, Map<Id,Process__c> processesMap){
        this.processes = processes;
        this.processesMap = processesMap;
        validateDeadline();
    }
    
    public void afterInsert(Map<Id, Process__c> processes) {
        ProcessTaskManager mgr = new ProcessTaskManager();
        mgr.createMasterTasks(processes);
    }
    
    public void afterUpdate(Map<Id, Process__c> oldProcesses, Map<Id, Process__c> newProcesses) {
        updateMasterTaskStatus(newProcesses);
        validateAssignedToUser(oldProcesses, newProcesses);
        autoCreateTasks(oldProcesses, newProcesses);        
    }
    
    private void updateMasterTaskStatus(Map<Id, Process__c> newProcesses) {
        List<Task> tasks = [SELECT Id, ActivityDate, WhatID, status, OwnerId FROM task 
            WHERE WhatID != NULL AND WhatID IN :newProcesses.keySet()];
        for(Task task1: tasks) {
            for (Process__c process1: newProcesses.values()) {
                if (task1.WhatId == process1.Id) {
                    task1.ActivityDate = process1.Deadline__c;
                    if (process1.Status__c == 'Cancelled'){
                        task1.Status = 'Cancelled';
                    }else if (process1.Status__c == 'Completed'){
                        task1.Status = 'Completed';
                    }else if (process1.Status__c == 'In Progress'){
                        task1.Status = 'In Progress';
                    }else if (process1.Status__c == 'Not Started'){
                        task1.Status = 'Not Started';
                    }               
                }
            }
        }
        if (isTaskUpdateable()){
            Database.update(tasks);   
        }    
    }
    
    private void validateAssignedToUser(Map<Id, Process__c> oldProcesses, 
            Map<Id, Process__c> newProcesses) {
        Set<ID> processIDs = new Set<ID>();
        for (Process__c newProcess : newProcesses.values()) {
            Process__c oldProcess = oldProcesses.get(newProcess.Id);
            if (newProcess.Auto_Create_Tasks__c != oldProcess.Auto_Create_Tasks__c) {
                processIds.add(newProcess.Id);
            }
        }
        boolean result = ValidateAssignedToUserHelper.validate(processIDs,true);
    }
        
    private void autoCreateTasks(Map<Id, Process__c> oldProcesses, 
            Map<Id, Process__c> newProcesses) {
        Set<ID> processIDs = new Set<ID>();
        for (Process__c newProcess : newProcesses.values()) {
            processIds.add(newProcess.Id);
            /*
            Process__c oldProcess = oldProcesses.get(newProcess.Id);
            
            if (newProcess.Auto_Create_Tasks__c != oldProcess.Auto_Create_Tasks__c) {
                processIds.add(newProcess.Id);
            }
            */
        }
        AutoCreateTasks.processSteps(processIDs);       
    }
    
    public void save(Process__c theProcess) {
        if (theProcess.Id == null) {
            theProcess.Exclude_From_Auto_Create_Tasks__c = true;
            if (isProcessCreateable()){
                insert theProcess;
            }else{
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'You do not have privileges to insert Processes.');
                ApexPages.addMessage(myMsg);
            } 
            insertProcessSteps(theProcess.Process_Template__c, 
                new List<Process__c> { theProcess });
            theProcess.Exclude_From_Auto_Create_Tasks__c = false;
            if (isProcessUpdateable()){
                update theProcess;
            }else{
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'You do not have privileges to update Processes.');
                ApexPages.addMessage(myMsg);
            }
        }
        else {
            if (isProcessUpdateable()){
                update theProcess;
            }else{
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'You do not have privileges to update Processes.');
                ApexPages.addMessage(myMsg);
            }
        }
    }
    
    public void stopProcess(Id processId) {
        AutoCreateTasks.Disable = true;
        Process__c tmpProcess = XLR8ProcessUtils.getProcessAndSteps(processId, PROCESS_STEP_STATUS_OPEN);
        
        if (tmpProcess != null && 
            tmpProcess.Status__c != PROCESS_STATUS_COMPLETED && tmpProcess.Status__c != PROCESS_STATUS_CANCELLED &&
            tmpProcess.Process_Steps__r != null && tmpProcess.Process_Steps__r.size() > 0) {
            
            List<Process_Step__c> steps = tmpProcess.Process_Steps__r;
            for (Process_Step__c step : steps) {
                step.Status__c = PROCESS_STEP_STATUS_CANCELLED;
            }
        
            if (isProcessStepUpdateable()){
                update steps;
            }else{
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'You do not have privileges to update Process Steps.');
                ApexPages.addMessage(myMsg);
            }
        }
    }
    
    private void validateNew() {
        Set<Id> templateIds = new Set<Id>();
        for (Process__c theProcess : processes) {
            templateIds.add(theProcess.Process_Template__c);
        }
        Map<Id, Process_Template__c> templateMap = new Map<Id, Process_Template__c>([
            SELECT Type__c FROM Process_Template__c WHERE Id IN :templateIds]);
        for (Process__c theProcess : processes) {
            Process_Template__c template = templateMap.get(theProcess.Process_Template__c);
            if (template == null) {
                continue;
            }
            
            if ((template.Type__c == 'Entity' && (theProcess.Entity__c == null 
                    || theProcess.Lead__c != null || theProcess.Opportunity__c != null
                    || theProcess.Contact__c != null || theProcess.Case__c != null))
                    || (template.Type__c == 'Lead' && (theProcess.Entity__c != null 
                    || theProcess.Lead__c == null || theProcess.Opportunity__c != null
                    || theProcess.Contact__c != null || theProcess.Case__c != null)) 
                    || (template.Type__c == 'Opportunity' && (theProcess.Entity__c != null 
                    || theProcess.Lead__c != null || theProcess.Opportunity__c == null
                    || theProcess.Contact__c != null || theProcess.Case__c != null)) 
                    || (template.Type__c == 'Contact' && (theProcess.Entity__c != null 
                    || theProcess.Lead__c != null || theProcess.Opportunity__c != null
                    || theProcess.Contact__c == null || theProcess.Case__c != null)) 
                    || (template.Type__c == 'Case' && (theProcess.Entity__c != null 
                    || theProcess.Lead__c != null || theProcess.Opportunity__c != null
                    || theProcess.Contact__c != null || theProcess.Case__c == null))
            ) {
                theProcess.addError('Please populate the ' + template.Type__c + ' lookup.');
            }
        }
    }
    
    private void setDefaultValues() {
        Set<Id> processTemplateIds = new Set<Id>();
        for (Process__c theProcess : processes) {
            if (theProcess.Process_Template__c != null) {
                processTemplateIds.add(theProcess.Process_Template__c);
            }
        }
        Map<Id, Process_Template__c> processTemplateMap = new Map<Id, Process_Template__c>([
            SELECT Auto_Create_Tasks_Default__c, Type__c FROM Process_Template__c 
            WHERE Id IN :processTemplateIds
        ]);
        for (Process__c theProcess : processes) {
            Process_Template__c processTemplate = 
                processTemplateMap.get(theProcess.Process_Template__c);
            if (processTemplate == null) {
                theProcess.addError('Process must be associated with a Template.');
                continue;
            }
            if (processTemplate.Type__c == null) {
                theProcess.addError('Process template must have a value selected for Type.');
            }
            theProcess.Auto_Create_Tasks__c = processTemplate.Auto_Create_Tasks_Default__c;
        }
    }
    
    public void insertProcessSteps(Id processTemplateId, List<Process__c> processes) {
        List<Process_Step__c> processSteps = new List<Process_Step__c>();
        List<Process_Template_Step__c> templateSteps = [select id, name , Details__c, Sequence__c, 
            Assign_To_Role__c, Assign_to_User__c,  Assign_To_Process_Owner__c, Assign_To_Record_Owner__c, 
            Duration_In_Days__c,
            Assign_To_Case_Role__c, Assign_To_Contact_Role__c, Assign_To_Lead_Role__c,
            Assign_To_Opportunity_Role__c, Process_Template__r.Type__c,
            (SELECT ParentStep__c, PredecessorStep__c FROM Template_Step_Junctions_Parent__r)
            from Process_Template_Step__c s 
            where Process_Template__c = : processTemplateId];
        
        if (templateSteps != null && templateSteps.size() > 0){
            processSteps.addAll(makeProcessSteps(processes, templateSteps));
        }
        
        
        if (isProcessStepCreateable() && processSteps.size() > 0){
            insert processSteps;    
        }

        List<Map<Id, Id>> stepMapList = new List<Map<Id, Id>>();
        Integer processStepIndex = 0;
        for (Integer i = 0; i < processes.size(); i++) {
            Map<Id, Id> stepMap = new Map<Id, Id>();
            stepMapList.add(stepMap);
            for (Integer j = 0; j < templateSteps.size(); j++) {
                stepMap.put(templateSteps.get(j).Id, processSteps.get(processStepIndex).Id);
                processStepIndex++;
            }
        }
        List<Process_Step_Junction__c> junctions = new List<Process_Step_Junction__c>();
        for (Process_Template_Step__c templateStep : templateSteps) {
            if (templateStep.Template_Step_Junctions_Parent__r == null) {
                continue;
            }
            for (Process_Template_Step_Junction__c junction : 
                    templateStep.Template_Step_Junctions_Parent__r) {
                for (Map<Id, Id> stepMap : stepMapList) {
                    Process_Step_Junction__c stepJunction = new Process_Step_Junction__c();
                    stepJunction.ParentStep__c = stepMap.get(junction.ParentStep__c);
                    stepJunction.PredecessorStep__c = stepMap.get(junction.PredecessorStep__c);
                    junctions.add(stepJunction);
                }
            }
        }
        if (isProcessStepJunctionCreateable()){
            insert junctions;
        }
    }
    
    public void setPredecessorsFromGenericSteps(List<GenericStep> genericSteps) {
        Boolean isDeletable = Schema.sObjectType.Process_Step_Junction__c.isDeletable();
        List<Id> parentStepIds = new List<Id>();
        List<Process_Step_Junction__c> junctions = 
            new List<Process_Step_Junction__c>();
        for (GenericStep step : genericSteps) {
            parentStepIds.add(step.Id);
            if (String.isEmpty(step.PredecessorIds)) {
                continue;
            }
            String[] predecessorIds = step.PredecessorIds.split(';');
            for (String predecessorId : predecessorIds) {
                Process_Step_Junction__c junction = new Process_Step_Junction__c(
                    ParentStep__c = step.Id,
                    PredecessorStep__c = predecessorId
                );
                junctions.add(junction);
            }
        }
        List<Process_Step_Junction__c> junctionsToDelete = [SELECT Id 
            FROM Process_Step_Junction__c
            WHERE ParentStep__c IN :parentStepIds];
        AutoCreateTasks.Disable = true;
        if (isDeletable){
            delete junctionsToDelete;
        }
        AutoCreateTasks.Disable = false;
        if (!junctions.isEmpty()) {
            if (isProcessStepJunctionCreateable()){
                insert junctions;
            }
        }
    }
    

    private List<Process_Step__c> makeProcessSteps(List<Process__c> processes, 
            List<Process_Template_Step__c> templateSteps) {
                System.debug('>>>>>>>>>>>>>>>>>>>>>>>>>>>> ' + processes);
        List<Process_Step__c> processSteps = new List<Process_Step__c>();
        Map<String,Id> assignedToIds = processUtils.getAssignedToUser(templateSteps, processes);
        String templateType = templateSteps.get(0).Process_Template__r.Type__c;
        Map<Id,sObject> parentsMap = processUtils.getParentOwnerIds(processes, templateType);
        for (Process__c process1 : processes){
            Id parentId = processUtils.getProcessParentOwner(process1, templateType);                   
            Id parentOwnerId = (Id)parentsMap.get(parentId).get('OwnerId');
            for (Process_Template_Step__c templateStep : templateSteps) {
                Process_Step__c processStep = new Process_Step__c();
                processStep.Name = templateStep.Name;
                processStep.Duration_In_Days__c = templateStep.Duration_In_Days__c;
                processStep.Step_Details__c = templateStep.Details__c;
                processStep.Process__c = process1.Id;
                processStep.Sequence__c = templateStep.Sequence__c;
                processStep.Status__c = 'Open';
                if (templateStep.Assign_To_Role__c != null) {
                    processStep.Account_Team_Assigned__c = true;
                }
                if (templateStep.Assign_to_User__c != null) {
                    processStep.Assigned_To__c = templateStep.Assign_to_User__c;
                }else if (templateStep.Assign_To_Process_Owner__c == true){
                    processStep.Assigned_To__c = UserInfo.getUserId();
                }else if (templateStep.Assign_to_Record_Owner__c == true){
                    processStep.Assigned_To__c = parentOwnerId;
                }else{
                    String key = String.valueOf(process1.Id) + String.valueOf(templateStep.Id);
                    String userId = assignedToIds.get(key);
                    if (userId != null && userId.length() > 0 ) {                       
                        processStep.Assigned_To__c = userId;
                    }
                }
                
                processSteps.add(processStep);
            }
        }
        return processSteps;
    }
    
    private static Boolean isProcessStepCreateable(){

        return (Schema.sObjectType.Process_Step__c.isCreateable() &&  Process_Step__c.Name.getDescribe().isCreateable() && 
                Process_Step__c.Duration_In_Days__c.getDescribe().isCreateable() && Process_Step__c.Step_Details__c.getDescribe().isCreateable() &&  
                Process_Step__c.Process__c.getDescribe().isCreateable() && Process_Step__c.Sequence__c.getDescribe().isCreateable() &&  
                Process_Step__c.Status__c.getDescribe().isCreateable() && Process_Step__c.Account_Team_Assigned__c.getDescribe().isCreateable() &&  
                Process_Step__c.Assigned_To__c.getDescribe().isCreateable() );
    }
    
    private void validateDeadline(){
        if (processes != null){
            for (Process__c p : processes){
                 if ((p.Deadline__c != null) && (system.today().daysBetween(p.Deadline__c) < 0) && 
                     (processesMap == null || (processesMap != null && processesMap.get(p.Id).Deadline__c != p.Deadline__c))){
                    p.addError('Due date cannot be in the past');
                 }
            }
        }
    }
    private static Boolean isProcessStepJunctionCreateable(){

        return (Schema.sObjectType.Process_Step_Junction__c.isCreateable() &&  Process_Step_Junction__c.ParentStep__c.getDescribe().isCreateable() && 
                Process_Step_Junction__c.PredecessorStep__c.getDescribe().isCreateable());
    }
    
    public static Boolean isTaskUpdateable(){
        return (Schema.Sobjecttype.Task.isUpdateable() &&  Task.Status.getDescribe().isCreateable());
    }
    
    private static Boolean isProcessCreateable(){
        return (Schema.sObjectType.Process__c.isCreateable() && Process__c.Exclude_From_Auto_Create_Tasks__c.getDescribe().isCreateable()); 
    }
    
    private static Boolean isProcessUpdateable(){
        return (Schema.sObjectType.Process__c.isUpdateable() && Process__c.Exclude_From_Auto_Create_Tasks__c.getDescribe().isUpdateable()); 
    }
    
    private static Boolean isProcessStepUpdateable(){
        return (Schema.sObjectType.Process_Step__c.isUpdateable() ); 
    }
}