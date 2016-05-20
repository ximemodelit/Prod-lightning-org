/*
 *Test class for ShowUncheckedItemsMsgController
 *@author Ximena Lasserre
 *@since October 2015
 */
@isTest
public with sharing class ShowUncheckedItemsMsgCtrlTest {

	static testmethod void showUncheckedItemsMsgControllerTest(){
		PageReference currentPage = Page.showUncheckedItemsMsg;
		Test.setCurrentPage(currentPage);
		ApexPages.currentPage().getParameters().put('retUrl', '/');
		
		Test.startTest();
		ShowUncheckedItemsMsgController controller = new ShowUncheckedItemsMsgController();
		
		PageReference back = controller.back();
		Test.stopTest();
		system.assert(back != null, 'New page reference is null');
	}
}