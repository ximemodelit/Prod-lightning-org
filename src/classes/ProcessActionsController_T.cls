/**
 * This class contains unit tests for validating the behavior of the ProcessActionsController
 */  

@isTest
private class ProcessActionsController_T {
  
  private static void initData(){
    //Create one case
    Case tcase = TestUtility.createCase('Open', 'Phone');
    insert tcase;
    
    System.assertNotEquals(tcase.Id, null); 
  
    //Create one template
    Process_Template__c template = TestUtility.createProcessTemplate('Sample Case Template', 'Case', 'Marketing','', false);
    insert template;
    System.assertNotEquals(template.Id, null);
    
    //Insert a process
    Process__c p = TestUtility.createProcess('Process', template.Id, tcase.Id);
    
    insert p;
    System.assertNotEquals(p.Id, null);
    
  }
  
    static testMethod void testNoAction() {
        //Initialize data for the test
        initData();
        
        //Query the process
        Process__c p = [Select Id from Process__c limit 1];
        
        //Set the page for the test
        PageReference pageRef = Page.ProcessActions;
        Test.setCurrentPage(pageRef);
      
      //Set parameters
      ApexPages.currentPage().getParameters().put('id', p.Id);
      ApexPages.currentPage().getParameters().put('action','');
      
      ProcessActionsController controller = new ProcessActionsController();
      
      PageReference pr = controller.doAction();
      
      String url = System.Url.getSalesforceBaseUrl() + '/' + p.Id;
      String returnUrl = System.Url.getSalesforceBaseUrl() + pr.getUrl(); 
      System.assertEquals(url,returnUrl);   
    }
    
    static testMethod void testCloseProcessWithoutSteps() {
        //Initialize data for the test
        initData();
        
        //Query the process
        Process__c p = [Select Id from Process__c limit 1];
        
        //Set the page for the test
        PageReference pageRef = Page.ProcessActions;
        Test.setCurrentPage(pageRef);
      
      //Set parameters
      ApexPages.currentPage().getParameters().put('id', p.Id);
      ApexPages.currentPage().getParameters().put('action','stop');
      
      ProcessActionsController controller = new ProcessActionsController();
      
      PageReference pr = controller.doAction();
      
    }
    
    static testMethod void testCloseProcessWithSteps() {
        //Initialize data for the test
        initData();
        
        //Query the process
        Process__c p = [Select Id from Process__c limit 1];
        
        //Insert steps
        List<Process_Step__c> steps = new List<Process_Step__c>();
    steps.add(TestUtility.createProcessStep('Step 1', p.Id, 'Open', 1));
    steps.add(TestUtility.createProcessStep('Step 2', p.Id, 'Open', 2));
    
    insert steps;
    
    //Verify steps were inserted
    System.assertNotEquals(steps.get(0).Id, null);
    System.assertNotEquals(steps.get(1).Id, null);
    
        //Set the page for the test
        PageReference pageRef = Page.ProcessActions;
        Test.setCurrentPage(pageRef);
      
      //Set parameters
      ApexPages.currentPage().getParameters().put('id', p.Id);
      ApexPages.currentPage().getParameters().put('action','stop');
      
      ProcessActionsController controller = new ProcessActionsController();
      PageReference pr = controller.doAction();
      
      //Verify steps were updated
      steps = [Select Id, Status__c from Process_Step__c];
      System.assertEquals(steps.size(), 2);
      System.assertEquals(steps.get(0).Status__c, 'Cancelled');
      System.assertEquals(steps.get(1).Status__c, 'Cancelled');
      
      
    }
    
    static testMethod void testCloseCompletedProcess() {
        //Initialize data for the test
        initData();
        
        //Query the process
        Process__c p = [Select Id from Process__c limit 1];
        
        //Insert steps
        List<Process_Step__c> steps = new List<Process_Step__c>();
    steps.add(TestUtility.createProcessStep('Step 1', p.Id, 'Completed', 1));
    steps.add(TestUtility.createProcessStep('Step 2', p.Id, 'Completed', 2));
    
    insert steps;
    
    //Verify steps were inserted
    System.assertNotEquals(steps.get(0).Id, null);
    System.assertNotEquals(steps.get(1).Id, null);
    
        //Set the page for the test
        PageReference pageRef = Page.ProcessActions;
        Test.setCurrentPage(pageRef);
      
      //Set parameters
      ApexPages.currentPage().getParameters().put('id', p.Id);
      ApexPages.currentPage().getParameters().put('action','stop');
      
      ProcessActionsController controller = new ProcessActionsController();
      
      PageReference pr = controller.doAction();
      
      
    }
}