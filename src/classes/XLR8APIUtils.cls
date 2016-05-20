public with sharing class XLR8APIUtils {
	public class RecordNotFoundException extends XLR8APITypes.XLR8Exception {}
	public class InvalidIdentifierException extends XLR8APITypes.XLR8Exception {}

	/**
	* Gets an account from a given account id
	* @param accountId The account id
	* @return The matching account
	* @throws UnknownAccountException if the account number is not found
	*/
	public static Account getAccount(String accountId) {
		String recordId = XLR8Utils.validateId(accountId);
		
		if (recordId == null) {
			throw new InvalidIdentifierException('Account ID null or blank');
		}
 
		Account account = null;
 		
 		List<Account> accounts = [Select Id, Name, RecordType.Name, XLR8CS__Envelope_Name__c, XLR8CS__Service_Level__c,
 										 XLR8CS__Primary_Advisor__r.Name, Phone,XLR8CS__Phone_Type__c, XLR8CS__Phone_2__c, 
 										 XLR8CS__Phone_2_Type__c, Fax,XLR8CS__Merge_C_O__c, XLR8CS__Merge_Street__c, XLR8CS__Merge_City__c,
 										 XLR8CS__Merge_State__c, XLR8CS__Merge_Zip__c, XLR8CS__Merge_Country__c, Website, 
 										 XLR8CS__Secondary_Advisor__r.Name, XLR8CS__Client_Svcs_Admin__r.Name
 								  From Account 
 								  Where Id =: recordId];
 		if (accounts.size() == 1){
 			account = accounts.get(0);
 		}
		
		if (account == null){
 			throw new RecordNotFoundException('Unable to find account by account Id');
		}
		
 		return account;
	}
	
	
	/**
	* Gets a contact from a given account id
	* @param acccountId The account id
	* @return The matching contact
	* @throws UnknownContactException if a contact related to the given account id is not found
	*/
	public static List<Contact> getContacts(String accountId) {
		String recordId = XLR8Utils.validateId(accountId);
		
		if (recordId == null) {
			throw new InvalidIdentifierException('Account ID null or blank');
		}
 		
 		List<Contact> contacts = [Select Id, AccountID, Account.Name, Birthdate, XLR8CS__Social_Security__c, XLR8CS__Gender__c, XLR8CS__Marital_Status__c, 
 										 XLR8CS__Employer__c, XLR8CS__Employment_Status__c, XLR8CS__Retirement_Date__c, XLR8CS__Occupation__c,
 										 XLR8CS__Primary_Contact__c, XLR8CS__Core_Contact__c, Email,XLR8CS__Email_2__c, XLR8CS__Email_3__c,
 										 XLR8CS__Critical_Notes__c, XLR8CS__Business_Phone__c, HomePhone, MobilePhone, Fax, XLR8CS__Merge_C_O__c,
 										 XLR8CS__Merge_Street__c, XLR8CS__Merge_City__c, XLR8CS__Merge_State__c, XLR8CS__Merge_Zip__c, 
 										 XLR8CS__Merge_Country__c, XLR8CS__Suffix__c, XLR8CS__Informal_Name__c, XLR8CS__Envelope_Name__c, XLR8CS__Relation_to_Entity__c, 
 										 XLR8CS__Client_Role__c, FirstName, LastName, Salutation, XLR8CS__middle_name__c
 								  From Contact Where AccountId =: recordId];
 		if (contacts.size() == 0){
 			throw new RecordNotFoundException('Unable to find contacts related to given account Id: ' + accountId);
 		}
		
 		return contacts;
	}
	
	/**
	* Gets a contact from a given account id
	* @param acccountId The account id
	* @return The matching contact
	* @throws UnknownContactException if a contact related to the given account id is not found
	*/
	public static List<XLR8CS__XLR8_Assets_Liabilities__c> getAssets(String accountId) {
		String recordId = XLR8Utils.validateId(accountId);
		
		if (recordId == null) {
			throw new InvalidIdentifierException('Account ID null or blank');
		}
 
		List<XLR8CS__XLR8_Assets_Liabilities__c> assets = [Select ID, Name, RecordType.Name,XLR8CS__Entity__c, XLR8CS__Entity__r.Name, XLR8CS__Category__c, 
																  XLR8CS__Custodian__c, XLR8CS__Registration__c, XLR8CS__Value_Balance__c, 
																  XLR8CS__As_Of_Date__c, XLR8CS__Cash_Value__c, XLR8CS__Aquisition_Value__c, 
																  XLR8CS__Asset_Classification__c, XLR8CS__Include_In_Net_Worth__c, 
																  XLR8CS__Acquired_Opened_Date__c, XLR8CS__Inactive_Date__c, XLR8CS__Description__c, 
																  XLR8CS__Initial_Loan_Amount__c, XLR8CS__Loan_Type__c, XLR8CS__Rate_Structure__c, 
																  XLR8CS__Amortization_Term__c, XLR8CS__Interest_Rate__c, XLR8CS__Payment_Amount__c, 
																  XLR8CS__Payment_Frequency__c, XLR8CS__Maturity_Date__c, XLR8CS__Primary_Owner__r.Name,
																  XLR8CS__Secondary_Owner__r.Name, XLR8CS__Institution__c, XLR8CS__Revolving_Loan__c
														  From XLR8CS__XLR8_Assets_Liabilities__c 
														  Where XLR8CS__Entity__c  =: recordId];
 		if (assets.size() == 0){
 			throw new RecordNotFoundException('Unable to find assets related to given account Id: ' + accountId);
 		}
		
 		return assets;
	}

	/**
	* Gets a contact from a given account id
	* @param acccountId The account id
	* @return The matching contact
	* @throws UnknownContactException if a contact related to the given account id is not found
	*/
	public static List<XLR8CS__XLR8_Securities__c> getHoldings(String accountId) {
		String recordId = XLR8Utils.validateId(accountId);
		
		if (recordId == null) {
			throw new InvalidIdentifierException('Account ID null or blank');
		}
 
		List<XLR8CS__XLR8_Securities__c> holdings = [Select ID, Name, XLR8CS__Financial_Account__c, XLR8CS__Quantity_of_Shares__c, 
														  XLR8CS__Security_Description__c, XLR8CS__Total_Value__c, XLR8CS__As_Of_Date__c,
														  XLR8CS__Cost_Basis__c, XLR8CS__Financial_Account__r.XLR8CS__Entity__c
														  From XLR8CS__XLR8_Securities__c 
														  Where XLR8CS__Financial_Account__r.XLR8CS__Entity__c  =: recordId];
 		if (holdings.size() == 0){
 			throw new RecordNotFoundException('Unable to find holdings related to given account Id: ' + accountId);
 		}
		
 		return holdings;
	}
	
	/**
	* Gets a contact from a given account id
	* @param acccountId The account id
	* @return The matching contact
	* @throws UnknownContactException if a contact related to the given account id is not found
	*/
	public static List<XLR8CS__XLR8_Insurance__c> getInsurances(String accountId) {
		String recordId = XLR8Utils.validateId(accountId);
		
		if (recordId == null) {
			throw new InvalidIdentifierException('Account ID null or blank');
		}
 
		List<XLR8CS__XLR8_Insurance__c> insurances = [Select ID, RecordType.Name, XLR8CS__Entity__r.Name, Name, XLR8CS__Policy_Holder__r.Name, 
															 XLR8CS__Insured_Individual__r.Name, XLR8CS__Status__c, XLR8CS__Policy_Type__c, 
															 XLR8CS__Insurance_Company__c, XLR8CS__Description__c, XLR8CS__Monthly_Benefit__c, 
															 XLR8CS__Surrender_Value__c, XLR8CS__Daily_Benefit__c, XLR8CS__Death_Benefit__c ,
															 XLR8CS__Maximum_Benefit__c, XLR8CS__Deductible__c, XLR8CS__Face_Value__c ,
															 XLR8CS__Annual_Premium__c, XLR8CS__Premium_Frequency__c, XLR8CS__Policy_Issued_Date__c, 
															 XLR8CS__Policy_Expiration_Date__c, XLR8CS__Policy_Effective_Date__c,
															 XLR8CS__Registered_Policy_Owner__c, XLR8CS__Registered_Insured_Individual__c
														  From XLR8CS__XLR8_Insurance__c 
														  Where XLR8CS__Entity__c  =: recordId];
 		if (insurances.size() == 0){
 			throw new RecordNotFoundException('Unable to find insurances related to given account Id: ' + accountId);
 		}
		
 		return insurances;
	}		

	/**
	* Gets a contact from a given account id
	* @param acccountId The account id
	* @return The matching contact
	* @throws UnknownContactException if a contact related to the given account id is not found
	*/
	public static List<XLR8CS__Income_and_Expense__c> getIncomeAndExpenses(String accountId) {
		String recordId = XLR8Utils.validateId(accountId);
		
		if (recordId == null) {
			throw new InvalidIdentifierException('Account ID null or blank');
		}
 
		List<XLR8CS__Income_and_Expense__c> incomeAndExpenses = [Select ID, RecordType.Name, XLR8CS__Entity__r.Name, XLR8CS__Type__c, XLR8CS__Owner_Registration__c,
															 XLR8CS__Primary_Owner__r.Name, XLR8CS__Secondary_Owner__r.Name, XLR8CS__Description__c, 
															 XLR8CS__Amount__c, XLR8CS__As_Of_Date__c,XLR8CS__Frequency__c, XLR8CS__Notes__c,
															 XLR8CS__Recurring_How_Often__c, XLR8CS__Pct_Annual_Increase__c, XLR8CS__Years_to_Continue__c, 
															 XLR8CS__Year_Expected_to_be_Incurred__c
														  From XLR8CS__Income_and_Expense__c 
														  Where XLR8CS__Entity__c  =: recordId];
 		if (incomeAndExpenses.size() == 0){
 			throw new RecordNotFoundException('Unable to find Income and Expenses related to given account Id: ' + accountId);
 		}
		
 		return incomeAndExpenses;
	}

	/**
	* Gets a contact from a given account id
	* @param acccountId The account id
	* @return The matching contact
	* @throws UnknownContactException if a contact related to the given account id is not found
	*/
	public static List<XLR8CS__XLR8_Estate_Planning_Gifting__c> getEstatePlannings(String accountId) {
		String recordId = XLR8Utils.validateId(accountId);
		
		if (recordId == null) {
			throw new InvalidIdentifierException('Account ID null or blank');
		}
 
		List<XLR8CS__XLR8_Estate_Planning_Gifting__c> plannings = [Select ID, RecordType.Name, Name, XLR8CS__Entity__r.Name, XLR8CS__Contact__r.Name,
																				  XLR8CS__Description__c, XLR8CS__Status__c, XLR8CS__Date_Given__c,
																				  XLR8CS__Recurring__c, XLR8CS__Recipient__c, XLR8CS__Value__c, XLR8CS__Value_as_of__c,
																				  XLR8CS__Date_Executed__c, XLR8CS__Document_Type__c, XLR8CS__Instrument_Gift_Type__c
														  From XLR8CS__XLR8_Estate_Planning_Gifting__c 
														  Where XLR8CS__Entity__c  =: recordId];
 		if (plannings.size() == 0){
 			throw new RecordNotFoundException('Unable to find Estate Plans & Giftings related to given account Id: ' + accountId);
 		}
		
 		return plannings;
	}
}