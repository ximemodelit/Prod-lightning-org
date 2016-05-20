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
private class MassDeleteProcessStepsController_T {

	private static void initData(){
		//Insert accounts
    	List<Account> accounts = new List<Account>();
    	accounts.add(TestUtility.createAccount('Edhasa'));
    	accounts.add(TestUtility.createAccount('Century'));
    	accounts.add(TestUtility.createAccount('Ediciones Peninsula'));
        insert accounts;
        
        List<Process_Template__c> templates = new List<Process_Template__c>();
        templates.add(TestUtility.createProcessTemplate('Account template sample 1', 'Entity'));
        templates.add(TestUtility.createProcessTemplate('Account template sample 2', 'Entity'));
	    insert templates;
	    
	    List<Process_Template_Step__c> stepTemplates = new List<Process_Template_Step__c>();
		stepTemplates.add(new Process_Template_Step__c(Name = 'Account Step 1', Assign_To_User__c = UserInfo.getUserId(), Process_Template__c = templates.get(0).Id, Sequence__c = 1 ));
		stepTemplates.add(new Process_Template_Step__c(Name = 'Account Step 2', Assign_To_User__c = UserInfo.getUserId(), Process_Template__c = templates.get(1).Id, Sequence__c = 2 ));
		insert stepTemplates;
		
		Process__c pProcess = TestUtility.createAccountProcess('Process 1', templates.get(0).Id, accounts.get(0).Id);
		insert pProcess;
		
		List<Process_Step__c> steps = new List<Process_Step__c>();
		for (Integer i = 0; i < 100; i++){
			steps.add(TestUtility.createProcessStep('Step ' + i, pProcess.Id, 'Open', i));
		}	
		insert steps;
	}
    static testMethod void testMassDelete() {
        initData();
        Test.startTest();
	    PageReference p = new PageReference('/MassDeleteProcessSteps?retURL=papitas');
        Test.setCurrentPage(p);

        List<Process_Step__c> steps = [Select Id from Process_Step__c];
        system.assertEquals(steps.size(), 100);
        
        //Reinstantiate the controller
        ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(steps);
 		ssc.setSelected(steps);
 		
 		MassDeleteProcessStepsController controller = new MassDeleteProcessStepsController(ssc);
		
        //Verify there isn't an error
        System.assertEquals(controller.errors.size(), 0);
        
        List<Process_Step__c> sameSteps = controller.getSteps(); //Jason - improve code coverage
		
		PageReference page = controller.deleteProcessSteps();
		System.assertNotEquals(page.getURL(), null);
		system.assertEquals([Select Id from Process_Step__c].size(), 0);
		
		page = controller.goBack();
		System.assertNotEquals(page.getURL(), null);
		Test.stopTest();
    }
    
     static testMethod void testMassDeleteErrors() {
        //Reinstantiate the controller
        List<Process_Step__c> steps = new List<Process_Step__c>();
        ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(steps);
 		ssc.setSelected(steps);
 		
 		MassDeleteProcessStepsController controller = new MassDeleteProcessStepsController(ssc);
 		//Jason-move bc error is in init not deleteProcessSteps
 		System.assertEquals(controller.errors.size(), 1);
 		system.assertEquals(controller.errors.get(0),'Please select at least one step to delete.');
		//Jason end
		
		PageReference page = controller.deleteProcessSteps();
		
        //Verify there is an error
        //System.assertEquals(controller.errors.size(), 1);
        //system.assertEquals(controller.errors.get(0),'Please select at least one record');
		//System.assertEquals(page, null);
		System.assertNotEquals(page, null);
		 		
 		
    }
}