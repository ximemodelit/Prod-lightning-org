/**
 * This class contains unit tests for validating the behavior of EditProcessTemplateStepController
 */
@isTest
private class EditProcessTemplateStepController_T {

    private static void initData(){
    //Create one template
    Process_Template__c template = TestUtility.createProcessTemplate('Sample Case Template', 'Case', 'Marketing','', false);
    insert template;
    System.assertNotEquals(template.Id, null);
    
    //Insert one step
    Process_Template_Step__c templateStep = TestUtility.createProcessTemplateStep('Create payload', 'Create payload', 0, template.Id, null, 'Case Role');
    insert templateStep;
    System.assertNotEquals(templateStep.Id, null);
    
    
  }
  
    static testMethod void testSave() {
        //Initialize data
        initData();
        
        //Query the template inserted
        Process_Template_Step__c templateStep = [Select Id, Name, Details__c, Duration_In_Days__c, Assign_To_Case_Role__c, Process_Template__c from Process_Template_Step__c limit 1];
        
        //Set the page for the test
        PageReference pageRef = Page.EditProcessTemplateStep;
        Test.setCurrentPage(pageRef);
      
      //Set parameters
      ApexPages.currentPage().getParameters().put('templateId', templateStep.Process_Template__c);
      ApexPages.currentPage().getParameters().put('CF00NG000000AkRdl', 'Sample+Case+Template');
      ApexPages.currentPage().getParameters().put('CF00NG000000AkRdl_lkid', templateStep.Process_Template__c);
      
      //Instantiate the page controller
        ApexPages.StandardController standardController = new ApexPages.StandardController(templateStep);            
      EditProcessTemplateStepController controller = new EditProcessTemplateStepController(standardController);
      
      //Update the attributes
      templateStep.Name = 'Updated name';
      templateStep.Duration_In_Days__c = 1;
      
      standardController.save();
      templateStep = [Select Id, Name, Details__c, Duration_In_Days__c, Assign_To_Case_Role__c, Process_Template__c from Process_Template_Step__c limit 1];
      System.assertEquals(templateStep.Name, 'Updated name');
      System.assertEquals(templateStep.Duration_In_Days__c, 1);
        
    }
    
    static testMethod void testCancel() {
        //Initialize data
        initData();
        
        //Query the template inserted
        Process_Template_Step__c templateStep = [Select Id, Name, Details__c, Duration_In_Days__c, Assign_To_Case_Role__c, Process_Template__c from Process_Template_Step__c limit 1];
        
        //Set the page for the test
        PageReference pageRef = Page.EditProcessTemplateStep;
        Test.setCurrentPage(pageRef);
      
      //Set parameters
      ApexPages.currentPage().getParameters().put('templateId', templateStep.Process_Template__c);
      ApexPages.currentPage().getParameters().put('CF00NG000000AkRdl', 'Sample+Case+Template');
      ApexPages.currentPage().getParameters().put('CF00NG000000AkRdl_lkid', templateStep.Process_Template__c);
      
      //Instantiate the page controller
        ApexPages.StandardController standardController = new ApexPages.StandardController(templateStep);            
      EditProcessTemplateStepController controller = new EditProcessTemplateStepController(standardController);
      
      //Update the attributes
      templateStep.Name = 'Updated name';
      templateStep.Duration_In_Days__c = 1;
      
      standardController.cancel();
      templateStep = [Select Id, Name, Details__c, Duration_In_Days__c, Assign_To_Case_Role__c, Process_Template__c from Process_Template_Step__c limit 1];
      System.assertEquals(templateStep.Name, 'Create payload');
      System.assertEquals(templateStep.Duration_In_Days__c, 0);
        
    }
    
    static testMethod void testSaveAndNew() {
        //Initialize data
        initData();
        
        //Query the template inserted
        Process_Template_Step__c templateStep = [Select Id, Name, Details__c, Duration_In_Days__c, Assign_To_Case_Role__c, Process_Template__c from Process_Template_Step__c limit 1];
        
        //Set the page for the test
        PageReference pageRef = Page.EditProcessTemplateStep;
        Test.setCurrentPage(pageRef);
      
      //Set parameters
      ApexPages.currentPage().getParameters().put('templateId', templateStep.Process_Template__c);
      ApexPages.currentPage().getParameters().put('CF00NG000000AkRdl', 'Sample+Case+Template');
      ApexPages.currentPage().getParameters().put('CF00NG000000AkRdl_lkid', templateStep.Process_Template__c);
      
      //Instantiate the page controller
        ApexPages.StandardController standardController = new ApexPages.StandardController(templateStep);            
      EditProcessTemplateStepController controller = new EditProcessTemplateStepController(standardController);
      
      //Update the attributes
      templateStep.Name = 'Updated name';
      templateStep.Duration_In_Days__c = 1;
      
      PageReference pr = controller.saveAndNew();
      templateStep = [Select Id, Name, Details__c, Duration_In_Days__c, Assign_To_Case_Role__c, Process_Template__c from Process_Template_Step__c limit 1];
      System.assertEquals(templateStep.Name, 'Updated name');
      System.assertEquals(templateStep.Duration_In_Days__c, 1);
        
        System.assertNotEquals(pr, null);
        System.assertNotEquals(pr.getUrl(),null);
        System.assert(pr.getUrl().contains('templateId'));
    }
}