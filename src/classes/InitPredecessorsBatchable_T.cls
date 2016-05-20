/**
 * This class contains unit tests for validating the behavior of InitPredecessorsBatchable

 */
@isTest
private class InitPredecessorsBatchable_T {

  private static void initData(){
    //Create one case
    Case tcase = TestUtility.createCase('Open', 'Phone');
    insert tcase;
    
    System.assertNotEquals(tcase.Id, null); 
  
    //Create one template
    Process_Template__c template = TestUtility.createProcessTemplate('Sample Case Template', 'Case', 'Marketing','', false);
    insert template;
    System.assertNotEquals(template.Id, null);
    
    //Insert 100 process
    List<Process__c> processes = new List<Process__c>();
    for (Integer i = 0; i < 100; i++){
      processes.add(TestUtility.createProcess('Process' + i, template.Id, tcase.Id));
    }
    insert processes;
    
    //Verify processes were inserted
    processes = [Select Id from Process__c];
    System.assertEquals(processes.size(), 100);
  
    //Insert open steps for some processes
    List<Process_Step__c> steps = new List<Process_Step__c>();
    for (Integer i = 0; i < 80; i++){
      Id processId = processes.get(i).Id;
      steps.add(TestUtility.createProcessStep('Step ' + i + 'a', processId, 'Open', 1));
      steps.add(TestUtility.createProcessStep('Step ' + i + 'b', processId, 'Open', 2));
    }
    
    //Insert completed steps fro some processes
    for (Integer i = 80; i < 100; i++){
      Id processId = processes.get(i).Id;
      steps.add(TestUtility.createProcessStep('Step ' + i, processId, 'Completed', 1));
    }
    
    insert steps;
    
    //Verify steps were inserted
    steps = [Select Id from Process_Step__c];
    System.assertEquals(steps.size(), 180);
    
    //Verify that there are 80 open processes
    processes = [Select Id from Process__c where Status__c != 'Completed'];
    System.assertEquals(processes.size(), 80);
    
    
    //Verify that there are 20 completed processes
    processes = [Select Id from Process__c where Status__c = 'Completed'];
    System.assertEquals(processes.size(), 20);
  }
  
    static testMethod void myUnitTest() {
        //Create data for the test
        initData();
        
        //Start the test
        Test.startTest();
        
        //Verify that there aren't any Process_Step_Junction__c
        System.assertEquals([Select Id from Process_Step_Junction__c].size(), 0);
        
        //Execute the batch
        InitPredecessorsBatchable.run();
        
        //Stop the test
        Test.stopTest();
        
        //Verify that after running the test, Process_Step_Junction__c records were inserted
        System.assertEquals([Select Id from Process_Step_Junction__c].size(), 80);
        
    }
}