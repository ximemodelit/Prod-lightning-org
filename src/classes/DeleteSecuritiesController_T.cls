@isTest
private class DeleteSecuritiesController_T {

	@isTest
	private static void test() {
		DeleteSecuritiesController cont = new DeleteSecuritiesController();
		Integer count = cont.RecordCount;
		cont.startDeletion(); 
	}
}