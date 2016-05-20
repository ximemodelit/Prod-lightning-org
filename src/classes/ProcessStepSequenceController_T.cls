/**
 * This class contains unit tests for validating the behavior of ProcessStepSequenceController
 */
@isTest
private class ProcessStepSequenceController_T {

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
    Process__c p = TestUtility.createProcess('Process', template.Id, tcase.Id);
    
    insert p;
    
    //Verify process was inserted
    System.assertNotEquals(p.Id, null);
  
    //Insert open steps for some processes
    List<Process_Step__c> steps = new List<Process_Step__c>();
    steps.add(TestUtility.createProcessStep('Step 1', p.Id, 'Open', 1));
    steps.add(TestUtility.createProcessStep('Step 2', p.Id, 'Open', 2));
    steps.add(TestUtility.createProcessStep('Step 3', p.Id, 'Open', 3));
    steps.add(TestUtility.createProcessStep('Step 4', p.Id, 'Open', 4));
    
    insert steps;
    
    //Verify steps were inserted
    System.assertNotEquals(steps.get(0).Id, null);
    System.assertNotEquals(steps.get(1).Id, null);
    System.assertNotEquals(steps.get(2).Id, null);
    System.assertNotEquals(steps.get(3).Id, null);
  }
  
    static testMethod void testSequenceChange() {
        initData();
        
        //Insert junctions
        Test.startTest();
        
        //Verify that there aren't any Process_Step_Junction__c
        System.assertEquals([Select Id from Process_Step_Junction__c].size(), 0);
        
        //Execute the batch
        InitPredecessorsBatchable.run();
        
        Test.stopTest();
        Process__c p = [Select Id from Process__c limit 1];
        
        //Set the page for the test
        PageReference pageRef = Page.ProcessStepSequence;
        Test.setCurrentPage(pageRef);
      
      //Instantiate the page controller
        ApexPages.StandardController standardController = new ApexPages.StandardController(p);            
      ProcessStepSequenceController controller = new ProcessStepSequenceController(standardController);
      
      //Update the sequence number
      controller.Steps.get(3).sequence = '1';
      controller.Steps.get(2).sequence = '2';
      controller.Steps.get(1).sequence = '3';
      controller.Steps.get(0).sequence = '4';    
        controller.save();
        
        List<Process_Step__c> steps = [Select Name, Sequence__c from Process_Step__c order by Sequence__c asc];
        System.assertEquals(steps.size(), 4);
        System.assertEquals(steps.get(0).Name, 'Step 4');
        System.assertEquals(steps.get(0).Sequence__c, 1);
        
        System.assertEquals(steps.get(1).Name, 'Step 3');
        System.assertEquals(steps.get(1).Sequence__c, 2);
        
        System.assertEquals(steps.get(2).Name, 'Step 2');
        System.assertEquals(steps.get(2).Sequence__c, 3);
        
        System.assertEquals(steps.get(3).Name, 'Step 1');
        System.assertEquals(steps.get(3).Sequence__c, 4);
        
        //Verify steps were updated
    }
    
    static testMethod void testUpdate() {
        initData();
        
        //Insert junctions
        Test.startTest();
        
        //Verify that there aren't any Process_Step_Junction__c
        System.assertEquals([Select Id from Process_Step_Junction__c].size(), 0);
        
        //Execute the batch
        InitPredecessorsBatchable.run();
        
        Test.stopTest();
        Process__c p = [Select Id from Process__c limit 1];
        
        //Set the page for the test
        PageReference pageRef = Page.ProcessStepSequence;
        Test.setCurrentPage(pageRef);
      
      //Instantiate the page controller
        ApexPages.StandardController standardController = new ApexPages.StandardController(p);            
      ProcessStepSequenceController controller = new ProcessStepSequenceController(standardController);
      
      //Update the sequence number
      controller.Steps.get(3).sequence = '1';
      controller.Steps.get(2).sequence = '2';
      controller.Steps.get(1).sequence = '3';
      controller.Steps.get(0).sequence = '4';    
        
        //Delete steps to throw an exception
        delete [Select Id from Process_Step__c order by Sequence__c asc];
        
        controller.save();
        System.assert(ApexPages.getMessages().size()>0);
    }
}