/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class TaskTimerControllerTest {

    public static testMethod void testTaskTimer(){
        
        //create project
        Task task = new Task();
        task.OwnerId = Userinfo.getUserId();
        task.Subject = 'Task Subject';
        task.Status = 'Not Started';
        task.Priority = 'Normal';
        insert task;
        
        system.assertNotEquals(task.Id, null);
        
        // Create a new project time
       
        Test.setCurrentPage(Page.TaskTimer);
        Apexpages.currentPage().getParameters().put('Id',task.Id);
        TaskTimerController controller = new TaskTimerController();
        
        system.assertEquals(controller.duration, '00:00:00');
        system.assertEquals(controller.showTimer, false);
        system.assertNotEquals(controller.task, null);
        system.assertEquals(controller.task.Id, task.Id);
        system.assertNotEquals(controller.timerActivity, null);
        system.assertEquals(controller.timerActivity.Id, null);
        system.assertEquals(controller.taskId, task.Id);
        system.assertEquals(controller.taskSubject, task.Subject);
        
        // Log some time
        controller.timerActivity.Billable__c = true;
        controller.timerActivity.Description__c = 'Description';
        controller.timerActivity.Date__c = system.today();
        controller.timerActivity.Duration__c = 10; 
        
        // Invoke save
        controller.save();
                
        // verify that a task timer activity was inserteded
        List<Task_Timer_Activity__c> timerActivities = [Select Id, Description__c, Date__c, Duration__c, Task_Id__c, Task_Subject__c 
        												from Task_Timer_Activity__c];
        system.assertEquals(timerActivities.size(), 1);
        system.assertEquals(timerActivities.get(0).Description__c, 'Description');
        system.assertEquals(timerActivities.get(0).Date__c, system.today());
        system.assertEquals(timerActivities.get(0).Duration__c, 10);
        system.assertEquals(timerActivities.get(0).Task_Id__c, task.Id);
        system.assertEquals(timerActivities.get(0).Task_Subject__c, task.Subject);
        
    }
    
    public static testMethod void testTaskTimerActivity(){
        
        //create project
        Task task = new Task();
        task.OwnerId = Userinfo.getUserId();
        task.Subject = 'Task Subject';
        task.Status = 'Not Started';
        task.Priority = 'Normal';
        insert task;
        
        system.assertNotEquals(task.Id, null);
        
        // Create a new task timer activity
        Task_Timer_Activity__c timerActivity = new Task_Timer_Activity__c();
        timerActivity.Description__c = 'Description';
        timerActivity.Duration__c = 0;
        timerActivity.Billable__c = true;
        timerActivity.Date__c = system.today();
        timerActivity.Task_Id__c = task.Id;
        timerActivity.Task_Subject__c = task.Subject;
        insert timerActivity;
       
        Test.setCurrentPage(Page.TaskTimer);
        Apexpages.currentPage().getParameters().put('Id',timerActivity.Id);
        TaskTimerController controller = new TaskTimerController();
        
        system.assertEquals(controller.duration, '00:00:00');
        system.assertEquals(controller.showTimer, true);
        system.assertEquals(controller.task, null);
        system.assertNotEquals(controller.timerActivity, null);
        system.assertEquals(controller.timerActivity.Id, timerActivity.Id);
        system.assertEquals(controller.taskId, task.Id);
        system.assertEquals(controller.taskSubject, task.Subject);
        
        // Log some time
        system.assertEquals(controller.timerActivity.Billable__c, true);
        system.assertEquals(controller.timerActivity.Description__c, 'Description');
        system.assertEquals(controller.timerActivity.Date__c, system.today());
        system.assertEquals(controller.timerActivity.Duration__c,0); 
        
        // Invoke save
        Apexpages.currentPage().getParameters().put('timeToAdd','00:10:00');

        controller.SaveTime();
        List<Task_Timer_Activity__c> timerActivities = [Select Id, Description__c, Date__c, Duration__c from Task_Timer_Activity__c];
        system.assertEquals(timerActivities.size(), 1);
        system.assertEquals(timerActivities.get(0).Description__c, 'Description');
        system.assertEquals(timerActivities.get(0).Date__c, system.today());
        system.assertEquals(timerActivities.get(0).Duration__c, 10.0/60);
        
        String strurl = controller.getTaskURL();
        system.assertEquals(URL.getSalesforceBaseUrl().toExternalForm() + '/' + task.Id, strurl);
        
    }
        
              
    }