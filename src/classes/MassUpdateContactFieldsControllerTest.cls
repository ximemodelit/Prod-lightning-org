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
private class MassUpdateContactFieldsControllerTest {
	
	@testSetup static void setup() {
		// Create common test sObject
		
		Account testAcct0 = new Account(Name = 'TestAcct1');
		
		insert testAcct0;
		System.assertNotEquals(testAcct0.Id, null);
        
		List<Contact> testCntcts = new List<Contact>();
		for(Integer i=0;i<4;i++) {
			testCntcts.add(new Contact(FirstName = 'TestCntctFirst'+i, LastName = 'TestCntctLast'+i, AccountId=testAcct0.ID));
		}
		
		
		 
		insert testCntcts;
	}

    static testMethod void myUnitTest() {
    	Account acct = [SELECT Id FROM Account WHERE Name='TestAcct1' LIMIT 1];
        // TO DO: implement unit test
        Apexpages.currentPage().getParameters().put('Id',acct.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(acct);
        MassUpdateContactFieldsController controller = new MassUpdateContactFieldsController(sc);
        
        
        Test.setCurrentPage(Page.MassUpdateContactAddresses);

        
        
        System.assertNotEquals(controller.accaddtocpy, null);
        System.assertNotEquals(controller.wrapperContacts, null);
		System.assertEquals(controller.wrapperContacts.size(), 4);
        
        controller.updateFields(); //test w none selected
        
        controller.targetcontactaddress = 'second';
        controller.whchCntctAddress();
        System.assertEquals(controller.scndry, true);
        
        controller.wrapperContacts.get(2).selected = true;
        controller.updateFields();
        
        controller.targetcontactaddress = 'first';
        controller.whchCntctAddress();
        controller.wrapperContacts.get(0).selected = true;
        controller.setAccountaddress2copy('second');
        controller.updateFields();
        
        controller.targetcontactaddress = 'third';
        controller.whchCntctAddress();
        controller.wrapperContacts.get(2).selected = true;
        controller.setAccountaddress2copy('third');
        controller.updateFields();
        
        controller.targetcontactaddress = 'fourth';
        controller.whchCntctAddress();
        controller.wrapperContacts.get(3).selected = true;
        controller.setAccountaddress2copy('fourth');
        controller.updateFields();
        
        //String address2Copy = controller.getAccountaddress2copy();
        System.assertNotEquals(controller.getAccountaddress2copy(), null);
        //testAccPlan.getaccountContact();
        //testAccPlan.save();
        
        //system.assertEquals(controller.task.Id, task.Id);
    }
}