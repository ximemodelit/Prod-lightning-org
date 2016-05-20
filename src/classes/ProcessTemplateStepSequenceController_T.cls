/**
 * This class contains unit tests for validating the behavior of ProcessTemplateStepSequenceController
 */

@isTest
private class ProcessTemplateStepSequenceController_T {

    private static void initData(){
    
    //Create one template
    Process_Template__c template = TestUtility.createProcessTemplate('Sample Case Template', 'Case', 'Marketing','', false);
    insert template;
    System.assertNotEquals(template.Id, null);
    
    //Insert open steps for some processes
    List<Process_Template_Step__c> steps = new List<Process_Template_Step__c>();
    steps.add(TestUtility.createProcessTemplateStep('Step 1', template.Id, 1, 'Sammple Case Role'));
    steps.add(TestUtility.createProcessTemplateStep('Step 2 ', template.Id, 2, 'Sammple Case Role'));
    steps.add(TestUtility.createProcessTemplateStep('Step 3', template.Id, 3, 'Sammple Case Role'));
    steps.add(TestUtility.createProcessTemplateStep('Step 4', template.Id, 4, 'Sammple Case Role'));
    
    insert steps;
    
    //Verify steps were inserted
    System.assertNotEquals(steps.get(0).Id, null);
    System.assertNotEquals(steps.get(1).Id, null);
    System.assertNotEquals(steps.get(2).Id, null);
    System.assertNotEquals(steps.get(3).Id, null);
    
    //Insert junctions
    Process_Template_Step_Junction__c junction = new Process_Template_Step_Junction__c(
      ParentStep__c = steps.get(1).Id,
      PredecessorStep__c = steps.get(0).Id
    );
    
    insert junction;
  }
  
    static testMethod void testSequenceChange() {
        initData();
        
        Process_Template__c template = [Select Id from Process_Template__c limit 1];
        
        //Set the page for the test
        PageReference pageRef = Page.ProcessTemplateStepSequence;
        Test.setCurrentPage(pageRef);
      
      //Instantiate the page controller
        ApexPages.StandardController standardController = new ApexPages.StandardController(template);            
      ProcessTemplateStepSequenceController controller = new ProcessTemplateStepSequenceController(standardController);
      
      //Update the sequence number
      controller.Steps.get(3).sequence = '1';
      controller.Steps.get(2).sequence = '2';
      controller.Steps.get(1).sequence = '3';
      controller.Steps.get(0).sequence = '4';    
        controller.save();
        
        List<Process_Template_Step__c> steps = [Select Name, Sequence__c from Process_Template_Step__c order by Sequence__c asc];
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
        
        
        Process_Template__c template = [Select Id from Process_Template__c limit 1];
        
        //Set the page for the test
        PageReference pageRef = Page.ProcessTemplateStepSequence;
        Test.setCurrentPage(pageRef);
      
      //Instantiate the page controller
        ApexPages.StandardController standardController = new ApexPages.StandardController(template);            
      ProcessTemplateStepSequenceController controller = new ProcessTemplateStepSequenceController(standardController);
      
      //Update the sequence number
      controller.Steps.get(3).sequence = '1';
      controller.Steps.get(2).sequence = '2';
      controller.Steps.get(1).sequence = '3';
      controller.Steps.get(0).sequence = '4';    
        
        //Delete steps to throw an exception
        delete [Select Id from Process_Template_Step__c order by Sequence__c asc];
        
        controller.save();
        System.assert(ApexPages.getMessages().size()>0);
    }
}