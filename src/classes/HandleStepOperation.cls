public without sharing class HandleStepOperation 
{
    public String calledForC ;
    public String processIdC ;
    public String processStepIdC ;
    public String taskCreatedC;
    
    public String getCalledForC() 
    {
        return calledForC ;
    }
    
    public String getProcessId()  
    {
        return processIdC ;
    }
    
    public String getProcessStepId()  
    {
        return processStepIdC ;
    }



    public PageReference handlePageOperation() 
    {
        String calledFor = Apexpages.currentPage().getParameters().get('called_for');
        String processStepID = Apexpages.currentPage().getParameters().get('id');
        String processID = Apexpages.currentPage().getParameters().get('process_id');
                
        calledForC = calledFor ;
        processStepIdC  = processStepID ;
        processIdC = processID ;
        
        if(calledForC.equalsIgnoreCase('createTask'))
        {
            String taskCreated = Apexpages.currentPage().getParameters().get('task_created');
            handleCreateTask(taskCreated);
        }
        else
        {
            String completed = Apexpages.currentPage().getParameters().get('Completed');
            return handleCompleted(completed);
        }

        return null;
    }
    
    private void handleCreateTask(String taskCreated)
    {
        if(taskCreated != null && taskCreated.equalsIgnoreCase('Y'))
        {
            taskCreatedC = 'Y';
        }
        else
        {
        
            taskCreatedC = 'N';
            createTask();
        }
    }
    private Pagereference handleCompleted(String taskCreated)
    {
        String processStepId = Apexpages.currentPage().getParameters().get('id');
        List<Process_Step__c> steps = [SELECT name,Process__c,Sequence__c,Task_Created__c,status__c,completed_by__c, completed_date__c, Id from  Process_Step__c where id = :processStepId];
        ///DataBase.query ('SELECT name,Process__c,Sequence__c,Task_Created__c,status__c,completed_by__c, completed_date__c, Id from  Process_Step__c where id = \''+processStepId +'\'');
        Process_Step__c step = steps[0];
        step.Completed_by__c = Userinfo.getUserId();
        step.Completed_Date__c = Date.today();
        step.status__c = 'Completed'; 
        
        if (isProcessStepUpdateable()){                    
            Database.update(step);            
        }else{
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'You do not have perms to update process steps.');
            ApexPages.addMessage(myMsg); 
        }         
                                              
        return new Pagereference('/'+processIdC );
    }

    public PageReference createTask() 
    {
        processStepIdC = Apexpages.currentPage().getParameters().get('id') ;
        processIdC = Apexpages.currentPage().getParameters().get('process_id');
        System.debug('processStepIdC   ' + processStepIdC  );
        List<Process_Step__c> steps = [SELECT name,Assigned_To__c,Step_Details__c, 
            Duration_In_Days__c from Process_Step__c WHERE id = :processStepIdC];
        System.debug(steps[0].name);
        String comments = '';
        if(steps[0].Step_Details__c != null)
        {
            comments = steps[0].Step_Details__c;
        }
        
        String userName = Userinfo.getName();
        String userID = Userinfo.getUserId();
        if(steps[0].Assigned_To__c != null)
        {
            String tmpStr = steps[0].Assigned_To__c;
            List<User> users = [SELECT name from User WHERE id = :tmpStr];
            ///Database.query('  );
            userName  = users[0].name;
            userID = steps[0].Assigned_To__c;
        }
        

        //Datetime d = System.now();
        
        String taskName = '';
        List<Process__c> processs = [SELECT name FROM Process__c WHERE id = :processIdC]; 
        
        List<Task> lstProcessTask = new List<Task>([Select WhoID from Task where WhatID =: processIdC]);
        List<Contact> lstContact;
        if(lstProcessTask.size() > 0)
            { 
                lstContact = new List<Contact>([Select ID, Name from Contact where ID =: lstProcessTask[0].WhoId]);
            }
        for (Process__c process: processs)
        {
            taskName = process.Name;
        }
        
        String taskTypeParamName = '';
/*
 * commenting to see if this parameter is needed.
        PE_Parameter_Settings__c customSetting = PE_Parameter_Settings__c.getInstance('Task Type Identifier');
        if (customSetting != null && customSetting.Parameter_Name__c != null)
        {
            taskTypeParamName = customSetting.Parameter_Name__c;
        }
*/
        Decimal duration = steps[0].Duration_In_Days__c;
        System.debug('duration ' + duration);
        Date dueDate = Date.today();
        if (duration != null) {
            dueDate = DateUtils.addBusinessDays(dueDate, Integer.valueOf(duration)).dateGMT();
        }
        System.debug('dueDate ' + dueDate);
        Pagereference pf = new Pagereference('/00T/e?');
        Map<string,string> paramsMap = pf.getParameters();
        paramsMap.put('what_id', processStepIdC);
        paramsMap.put('retURL', processIdC);
        paramsMap.put('tsk1_lkid', userID);
        paramsMap.put('tsk5', 'Process Step: ' + taskName + ' - ' +steps[0].name);
        paramsMap.put('tsk4', dueDate.format());
        paramsMap.put('tsk3_lkid', processStepIdC);
        paramsMap.put('tsk3', steps[0].name);
        paramsMap.put('email', '1');
        paramsMap.put('tsk1', userName);
        paramsMap.put('tsk6', comments);
        if(lstContact.size() > 0)
            {
                paramsMap.put('tsk2_lkid', lstContact[0].Id);
                paramsMap.put('tsk2', lstContact[0].name);
            }
        if (taskTypeParamName != '')
        {
            paramsMap.put(taskTypeParamName, 'Process ToDo');
        }
        paramsMap.put('saveURL', Page.saveTask.getURL() + '?process_id=' + processIdC+ '&process_step_id='+ processStepIdC + '&retURL=/'+processIdC);

        return pf;        
    }

    public PageReference redirectPage() 
    {
        Pagereference pf = new Pagereference('/'+processIdC );
        return pf;
    }

    public String getTaskCreated() 
    {
        return taskCreatedC;
    }
    
    public PageReference  redirectAfterTaskCreation()
    {
        String newSFTaskID = Apexpages.currentPage().getParameters().get('newid') ;
        String processStepId = Apexpages.currentPage().getParameters().get('process_step_id');
        
        //System.Debug('processStepId ----->>>  ' + processStepId );
        List<Process_Step__c> steps = [SELECT name,Process__c,Sequence__c,Task_Created__c, Id from  Process_Step__c where id = :processStepId];
        Process_Step__c step = steps[0];
        step.Task_Created__c = 'Y';
        
        if (isProcessStepUpdateable()){                    
            Database.update(step);            
        }else{
            
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'You do not have perms to update process steps.');
            ApexPages.addMessage(myMsg); 
        }  
        
        List<Task> sfTaskList = [SELECT Process_Step_ID__c, id, Process_ID__c FROM  Task where id = :newSFTaskID];
        Task sfTask = sfTaskList[0];
        sftask.whatID = processStepId;
        sfTask.Process_Step_ID__c = step.Id;
        sfTask.Process_ID__c = step.Process__c;
        
        System.Debug('sfTask.Process_Step_ID__c -----  ' + sfTask.Process_Step_ID__c);
        
        if (isTaskUpdateable()){
            Database.update(sfTask); 
        }else{
            
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'You do not have perms to update tasks.');
            ApexPages.addMessage(myMsg); 
        }   
                                                             
        return new Pagereference(Apexpages.currentPage().getParameters().get('retURL'));
    }

    private static Boolean isProcessStepUpdateable(){
        return (Schema.sObjectType.Process_Step__c.isUpdateable() && Process_Step__c.Status__c.getDescribe().isUpdateable() && 
                Process_Step__c.Completed_By__c.getDescribe().isUpdateable() && Process_Step__c.Completed_Date__c.getDescribe().isUpdateable() &&
                Process_Step__c.Task_Created__c.getDescribe().isUpdateable());
    }
    
    public static Boolean isTaskUpdateable(){
        return (Schema.Sobjecttype.Task.isUpdateable() &&  Task.WhatId.getDescribe().isCreateable() && Task.Process_ID__c.getDescribe().isCreateable() &&
                Task.Process_Step_ID__c.getDescribe().isCreateable());
    }
    static testMethod void testHAndleStepOp()
    {
        Date tmpDate = Date.today();
        Process_Template__c template = new Process_Template__c(
            Name = 'testtemplate',
            Auto_Create_Tasks_Default__c = true,
            Type__c = 'Entity'
        );
        insert template;
        
        Account entity = new Account(
            Name = 'testacc'
        );
        insert entity;

        Process__c tmpProcess = new Process__c();
        tmpProcess.Name = 'TEST PROCESS PKS';
        tmpProcess.Deadline__c = (tmpDate + 5);
        tmpProcess.Process_Template__c = template.Id;
        tmpProcess.Entity__c = entity.Id;
        
        Test.startTest();
        Database.insert(tmpProcess);
        System.assertNotEquals(tmpProcess.Id, null);
        
        tmpProcess = null;
        List<Process__c> processes = Database.query('SELECT name, id, Process_Template__c,Entity__c ,Deadline__c,Description__c FROM Process__c WHERE name=\'TEST PROCESS PKS\'');
        for (Process__c tmpObj: processes)
        {
            tmpProcess = tmpObj;
        }
        Process_Step__c step = new Process_Step__c();
        step.Name = 'TEST PROCESS STEP 1';
        step.Status__c = 'Open';
        step.Process__c = tmpProcess.Id;
        step.Sequence__c = 1;
        step.Assigned_To__c = Userinfo.getUserId();
        
        Database.insert(step);  
        System.assertNotEquals(step.Id, null);
        List<Process_Step__c> steps = Database.query('SELECT Id,Assigned_To__c, Name,Completed_By__c,Status__c,Completed_Date__c FROM Process_Step__c WHERE Process__c = \'' + tmpProcess.Id + '\'');
                
        HandleStepOperation obj = new HandleStepOperation();
        Apexpages.currentPage().getParameters().put('called_for','createTask');
        Apexpages.currentPage().getParameters().put('id',steps[0].id);
        Apexpages.currentPage().getParameters().put('process_id',tmpProcess.id);
        Apexpages.currentPage().getParameters().put('task_created','N'); 
     
        Task sfTask = new Task();
        sfTask.OwnerId = Userinfo.getUserId(); //AssignedTo field for SF Task Obj
        sfTask.ActivityDate = tmpProcess.Deadline__c;  //Deadline of SF Task Obj
        sfTask.Subject = 'Process: ' + tmpProcess.Name;
        sfTask.Status = 'Not Started';
        sfTask.Description = tmpProcess.Description__c;
        sfTask.WhatId = tmpProcess.Id;
        sfTask.Priority = 'Normal';  
        sfTask.Process_ID__c = tmpProcess.Id;
        sfTask.Process_Step_ID__c = steps[0].id;
    
        List<Task> taskList = new List<Task>();
        taskList.add(sfTask);
        
        Database.insert(taskList);
   
        List<Task> tasklst = Database.query('SELECT Id FROM TASK WHERE Process_Step_ID__c = \'' + steps[0].id + '\'');
   
     
        Apexpages.currentPage().getParameters().put('newid',tasklst[0].id);
        Apexpages.currentPage().getParameters().put('process_step_id',steps[0].id);
        Apexpages.currentPage().getParameters().put('retURL','/'+tmpProcess.id);

        obj.getCalledForC();
        obj.getProcessId();
        obj.getProcessStepId();
        
        obj.handlePageOperation();
        obj.getTaskCreated();
        obj.redirectAfterTaskCreation(); 
        obj.redirectPage();
        obj.handleCreateTask('Y');
        Test.stopTest();
    }
}