Global with sharing class XLR8API { 
	/**
	* Gets all related MyObjects for a given account
	* @param context The account context
	* @return The related MyObjects
	*/
	WebService static XLR8APITypes.AccountObject getAccount(String accountId) {
		XLR8APITypes.AccountObject result = new XLR8APITypes.AccountObject();
 
		if (accountId == null || accountId.trim() == '') {
			result.returnCode = XLR8APITypes.STATUS_BAD;
			result.message = 'Invalid account id';
			return result;
		}
 
		try {
			Account account = XLR8APIUtils.getAccount(accountId);
			result = new XLR8APITypes.AccountObject(account);
			result.returnCode = XLR8APITypes.STATUS_OK;
			result.message = 'Success';
		} catch (XLR8APITypes.XLR8Exception e) {			
			result.returnCode = XLR8APITypes.STATUS_NOTFOUND;
			result.message = e.getMessage();
		} catch (Exception e) {
			result.returnCode = XLR8APITypes.STATUS_ISE;
			result.message = e.getMessage();
		}
 
		return result;
	}
	
	/**
	* Gets all related MyObjects for a given account
	* @param context The account context
	* @return The related MyObjects
	*/
	WebService static XLR8APITypes.ContactObjects getContacts(String accountId) {
		XLR8APITypes.ContactObjects result = new XLR8APITypes.ContactObjects();
 
		if (accountId == null || accountId.trim() == '') {
			result.returnCode = XLR8APITypes.STATUS_BAD;
			result.message = 'Invalid account id';
			return result;
		}
 
		try {
			List<Contact> contacts = XLR8APIUtils.getContacts(accountId);
			result = new XLR8APITypes.ContactObjects(contacts);
			result.returnCode = XLR8APITypes.STATUS_OK;
			result.message = 'Success';
		} catch (XLR8APITypes.XLR8Exception e) {			
			result.returnCode = XLR8APITypes.STATUS_NOTFOUND;
			result.message = e.getMessage();
		} catch (Exception e) {
			result.returnCode = XLR8APITypes.STATUS_ISE;
			result.message = e.getMessage();
		}
 
		return result;
	}
	
	/**
	* Gets all related MyObjects for a given account
	* @param context The account context
	* @return The related MyObjects
	*/
	WebService static XLR8APITypes.AssetObjects getAssets(String accountId) {
		XLR8APITypes.AssetObjects result = new XLR8APITypes.AssetObjects();
 
		if (accountId == null || accountId.trim() == '') {
			result.returnCode = XLR8APITypes.STATUS_BAD;
			result.message = 'Invalid account id';
			return result;
		}
 
		try {
			List<XLR8CS__XLR8_Assets_Liabilities__c> assets = XLR8APIUtils.getAssets(accountId);
			result = new XLR8APITypes.AssetObjects(assets);
			result.returnCode = XLR8APITypes.STATUS_OK;
			result.message = 'Success';
		} catch (XLR8APITypes.XLR8Exception e) {			
			result.returnCode = XLR8APITypes.STATUS_NOTFOUND;
			result.message = e.getMessage();
		} catch (Exception e) {
			result.returnCode = XLR8APITypes.STATUS_ISE;
			result.message = e.getMessage();
		}
 
		return result;
	}
	
	/**
	* Gets all related MyObjects for a given account
	* @param context The account context
	* @return The related MyObjects
	*/
	WebService static XLR8APITypes.HoldingObjects getHoldings(String accountId) {
		XLR8APITypes.HoldingObjects result = new XLR8APITypes.HoldingObjects();
 
		if (accountId == null || accountId.trim() == '') {
			result.returnCode = XLR8APITypes.STATUS_BAD;
			result.message = 'Invalid account id';
			return result;
		}
 
		try {
			List<XLR8CS__XLR8_Securities__c> records = XLR8APIUtils.getHoldings(accountId);
			result = new XLR8APITypes.HoldingObjects(records);
			result.returnCode = XLR8APITypes.STATUS_OK;
			result.message = 'Success';
		} catch (XLR8APITypes.XLR8Exception e) {			
			result.returnCode = XLR8APITypes.STATUS_NOTFOUND;
			result.message = e.getMessage();
		} catch (Exception e) {
			result.returnCode = XLR8APITypes.STATUS_ISE;
			result.message = e.getMessage();
		}
 
		return result;
	}
	
	/**
	* Gets all related MyObjects for a given account
	* @param context The account context
	* @return The related MyObjects
	*/
	WebService static XLR8APITypes.InsuranceObjects getInsurances(String accountId) {
		XLR8APITypes.InsuranceObjects result = new XLR8APITypes.InsuranceObjects();
 
		if (accountId == null || accountId.trim() == '') {
			result.returnCode = XLR8APITypes.STATUS_BAD;
			result.message = 'Invalid account id';
			return result;
		}
 
		try {
			List<XLR8CS__XLR8_Insurance__c> records = XLR8APIUtils.getInsurances(accountId);
			result = new XLR8APITypes.InsuranceObjects(records);
			result.returnCode = XLR8APITypes.STATUS_OK;
			result.message = 'Success';
		} catch (XLR8APITypes.XLR8Exception e) {			
			result.returnCode = XLR8APITypes.STATUS_NOTFOUND;
			result.message = e.getMessage();
		} catch (Exception e) {
			result.returnCode = XLR8APITypes.STATUS_ISE;
			result.message = e.getMessage();
		}
 
		return result;
	}
	
	/**
	* Gets all related MyObjects for a given account
	* @param context The account context
	* @return The related MyObjects
	*/
	WebService static XLR8APITypes.IncomeAndExpenseObjects getIncomeAndExpenses(String accountId) {
		XLR8APITypes.IncomeAndExpenseObjects result = new XLR8APITypes.IncomeAndExpenseObjects();
 
		if (accountId == null || accountId.trim() == '') {
			result.returnCode = XLR8APITypes.STATUS_BAD;
			result.message = 'Invalid account id';
			return result;
		}
 
		try {
			List<XLR8CS__Income_and_Expense__c> records = XLR8APIUtils.getIncomeAndExpenses(accountId);
			result = new XLR8APITypes.IncomeAndExpenseObjects(records);
			result.returnCode = XLR8APITypes.STATUS_OK;
			result.message = 'Success';
		} catch (XLR8APITypes.XLR8Exception e) {			
			result.returnCode = XLR8APITypes.STATUS_NOTFOUND;
			result.message = e.getMessage();
		} catch (Exception e) {
			result.returnCode = XLR8APITypes.STATUS_ISE;
			result.message = e.getMessage();
		}
 
		return result;
	}
	
	/**
	* Gets all related MyObjects for a given account
	* @param context The account context
	* @return The related MyObjects
	*/
	WebService static XLR8APITypes.EstateAndPlansGiftingObjects getEstatePlannings(String accountId) {
		XLR8APITypes.EstateAndPlansGiftingObjects result = new XLR8APITypes.EstateAndPlansGiftingObjects();
 
		if (accountId == null || accountId.trim() == '') {
			result.returnCode = XLR8APITypes.STATUS_BAD;
			result.message = 'Invalid account id';
			return result;
		}
 
		try {
			List<XLR8CS__XLR8_Estate_Planning_Gifting__c> records = XLR8APIUtils.getEstatePlannings(accountId);
			result = new XLR8APITypes.EstateAndPlansGiftingObjects(records);
			result.returnCode = XLR8APITypes.STATUS_OK;
			result.message = 'Success';
		} catch (XLR8APITypes.XLR8Exception e) {			
			result.returnCode = XLR8APITypes.STATUS_NOTFOUND;
			result.message = e.getMessage();
		} catch (Exception e) {
			result.returnCode = XLR8APITypes.STATUS_ISE;
			result.message = e.getMessage();
		}
 
		return result;
	}
	
}