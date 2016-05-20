/**
* This class is a utility class for WebServices and other API classes
*/

global with sharing class XLR8APITypes {
	
	global final static Integer STATUS_OK = 200;
	global final static Integer STATUS_BAD = 400;
	global final static Integer STATUS_NOTFOUND = 404;
	global final static Integer STATUS_ISE = 500;

	public virtual class XLR8Exception extends Exception {}
	
	/**
	* This class is an abstraction of the Account object
	*/
	global class AccountObject{
		WebService  Integer returnCode;
		WebService  String  message;
		webservice	String	id;		
		webservice	String	entityName;		
		webservice	String	recordType;		
		webservice	String	envelopeName;	
		webservice	String	serviceLevel;	
		webservice	String	primaryAdvisor;	
		webservice  String  secondaryAdvisor;
		webservice	String	phone;			
		webservice	String	phoneType;		
		webservice	String	phone2;			
		webservice	String	phone2Type;		
		webservice	String	fax;				
		webservice	String	website;			
		webservice	String	mergeCO;			
		webservice	String	mergeStreet;		
		webservice	String	mergeCity;		
		webservice	String	mergeState;		
		webservice	String	mergeZip;		
		webservice	String	mergeCountry;	
		webservice  String  clientSvcsAdmin;
		
		public AccountObject(){}
		
		public AccountObject(Account o){
			id 				= o.ID;
			entityName 		= o.Name;
			recordType 		= o.RecordType.Name;
			envelopeName 	= o.XLR8CS__Envelope_Name__c;
			serviceLevel 	= o.XLR8CS__Service_Level__c;
			primaryAdvisor 	= o.XLR8CS__Primary_Advisor__r.Name;
			secondaryAdvisor= o.XLR8CS__Secondary_Advisor__r.Name;
			phone 			= o.Phone;
			phoneType 		= o.XLR8CS__Phone_Type__c;
			phone2 			= o.XLR8CS__Phone_2__c;
			phone2Type 		= o.XLR8CS__Phone_2_Type__c;
			fax				= o.Fax;
			website			= o.Website;
			mergeCO			= o.XLR8CS__Merge_C_O__c;
			mergeStreet		= o.XLR8CS__Merge_Street__c;
			mergeCity 		= o.XLR8CS__Merge_City__c;
			mergeState 		= o.XLR8CS__Merge_State__c;
			mergeZip 		= o.XLR8CS__Merge_Zip__c;
			mergeCountry 	= o.XLR8CS__Merge_Country__c;
			clientSvcsAdmin = o.XLR8CS__Client_Svcs_Admin__r.Name;
		}
	}
	 /**
	  * This class is an abstraction of the Contact object
	  */
	global class ContactObject{
		WebService  Integer returnCode;
		WebService  String  message;
		webservice  String  contactId;
		webservice  String  accountId;
		webservice  String  accountName;
		webservice	Date	birthdate;		
		webservice	String	socialSecurity;	
		webservice	String	gender;			
		webservice	String	maritalStatus;	
		webservice	String	employer;		
		webservice	String	employmentStatus;
		webservice	Date	retirementDate;	
		webservice	String	occupation;		
		webservice	Boolean	primaryContact;	
		webservice	Boolean	coreContact;		
		webservice	String	email;			
		webservice	String	email2;			
		webservice	String	email3;			
		webservice	String	notes;			
		webservice	String	businessPhone;	
		webservice	String	homePhone;		
		webservice	String	mobile;			
		webservice	String	fax;				
		webservice	String	mergeCO;			
		webservice	String	mergeStreet;		
		webservice	String	mergeCity;		
		webservice	String	mergeState;		
		webservice	String	mergeZip;		
		webservice	String	mergeCountry;	
		webservice  String suffix;
		webservice  String informalName;
		webservice  String envelopeName;
		webservice  String relationToEntity;
		webservice  String clientRole;
		webservice  String firstName;
		webservice  String lastName;
		webservice  String salutation;
		webservice  String  middleName;
	
		public ContactObject(){}
		
		public ContactObject(Contact o){
			contactId       = o.Id;
			accountId       = o.AccountId;
			accountName     = o.Account.Name;
			birthdate 		= o.Birthdate;
			socialSecurity 	= o.XLR8CS__Social_Security__c;
			gender 			= o.XLR8CS__Gender__c;
			maritalStatus 	= o.XLR8CS__Marital_Status__c;
			employer 		= o.XLR8CS__Employer__c;
			employmentStatus = o.XLR8CS__Employment_Status__c;
			retirementDate 	= o.XLR8CS__Retirement_Date__c;
			occupation 		= o.XLR8CS__Occupation__c; 
			primaryContact 	= o.XLR8CS__Primary_Contact__c;
			coreContact 	= o.XLR8CS__Core_Contact__c;
			email 			= o.Email;
			email2 			= o.XLR8CS__Email_2__c;
			email3 			= o.XLR8CS__Email_3__c;
			notes 			= o.XLR8CS__Critical_Notes__c;
			businessPhone 	= o.XLR8CS__Business_Phone__c;
			homePhone 		= o.HomePhone;
			mobile 			= o.MobilePhone;
			fax 			= o.Fax;
			mergeCO 		= o.XLR8CS__Merge_C_O__c;
			mergeStreet 	= o.XLR8CS__Merge_Street__c;
			mergeCity 		= o.XLR8CS__Merge_City__c;
			mergeState 		= o.XLR8CS__Merge_State__c;
			mergeZip	 	= o.XLR8CS__Merge_Zip__c;
			mergeCountry 	= o.XLR8CS__Merge_Country__c;
			suffix          = o.XLR8CS__Suffix__c;
			informalName    = o.XLR8CS__Informal_Name__c;
			envelopeName    = o.XLR8CS__Envelope_Name__c;
			relationToEntity= o.XLR8CS__Relation_to_Entity__c;
			clientRole      = o.XLR8CS__Client_Role__c;
			firstName		= o.FirstName;
			lastName		= o.LastName;
			salutation      = o.Salutation;
			middleName      = o.XLR8CS__middle_name__c;
		}
	}
	
	/**
	  * This class is an abstraction of the XLR8CS__XLR8_Assets_Liabilities__c object
	  */
	global class AssetObject{
		WebService  Integer returnCode;
		WebService  String  message;
		
		webservice	String	id;					
		webservice	String	assetAccountNumber;	
		webservice	String	recordType;			
		webservice	String	entity;		
		webservice  String  entityName;		
		webservice	String	assetCategory;		
		webservice	String	custodian;			
		webservice	String	registration;		
		webservice	Decimal	valueBalance;		
		webservice	Date	asofDate;			
		webservice	Decimal	cashValue;			
		webservice	Decimal	acquisitionValue;	
		webservice	String	assetClassification;
		webservice	Boolean	includeinNetWorth;	
		webservice	Date	acquiredOpenedDate;	
		webservice	Date	inactiveDate;		
		webservice	String	description;			
		webservice	Decimal	initialLoanAmount;	
		webservice	String	loanType;			
		webservice	String	rateStructure;		
		webservice	Decimal	amortizationTerm;	
		webservice	Decimal	interestRate;		
		webservice	Decimal	paymentAmount;		
		webservice	String paymentFrequency;		
		webservice	Date	maturityDate;		
		webservice  String primaryOwner;
		webservice  String secondaryOwner;
		webservice  String institution;
		webservice  String revolvingLoan;
		
		public AssetObject(){}
		
		public AssetObject(XLR8CS__XLR8_Assets_Liabilities__c o){
			id 					= o.ID;
			assetAccountNumber 	= o.Name;
			recordType			= o.RecordType.Name;
			entity				= o.XLR8CS__Entity__c;
			entityname          = o.XLR8CS__Entity__r.Name;
			assetCategory 		= o.XLR8CS__Category__c;
			custodian 		    = o.XLR8CS__Custodian__c;
			registration 		= o.XLR8CS__Registration__c;
			valueBalance		= o.XLR8CS__Value_Balance__c;
			asofDate			= o.XLR8CS__As_Of_Date__c;
			cashValue			= o.XLR8CS__Cash_Value__c;
			acquisitionValue	= o.XLR8CS__Aquisition_Value__c ;
			assetClassification	= o.XLR8CS__Asset_Classification__c;
			includeinNetWorth	= o.XLR8CS__Include_In_Net_Worth__c;
			acquiredOpenedDate	= o.XLR8CS__Acquired_Opened_Date__c;
			inactiveDate		= o.XLR8CS__Inactive_Date__c;
			description			= o.XLR8CS__Description__c;
			initialLoanAmount	= o.XLR8CS__Initial_Loan_Amount__c;
			loanType			= o.XLR8CS__Loan_Type__c;
			rateStructure		= o.XLR8CS__Rate_Structure__c;
			amortizationTerm	= o.XLR8CS__Amortization_Term__c;
			interestRate		= o.XLR8CS__Interest_Rate__c;
			paymentAmount		= o.XLR8CS__Payment_Amount__c;
			paymentFrequency	= o.XLR8CS__Payment_Frequency__c;
			maturityDate		= o.XLR8CS__Maturity_Date__c;				
			primaryOwner        = o.XLR8CS__Primary_Owner__r.Name;
			secondaryOwner      = o.XLR8CS__Secondary_Owner__r.Name;
			institution         = o.XLR8CS__Institution__c;
			revolvingLoan       = o.XLR8CS__Revolving_Loan__c;
		}
	}
	/**
	  * This class is an abstraction of the XLR8CS__XLR8_Securities__c object
	  */
	global class HoldingObject{
		WebService  Integer returnCode;
		WebService  String  message;
		
		webservice	String	 id;					
		webservice	String	 symbol;				
		webservice	String	 financialAccount;	
		webservice  String   entityId;
		webservice	Decimal	 quantityOfShares;	
		webservice	String	 securityDescription;
		webservice	Decimal	 totalValue;			
		webservice	Datetime asOfDate;			
		webservice  Decimal costBasis;

	
		public HoldingObject(){}
		
		public HoldingObject(XLR8CS__XLR8_Securities__c o){
			id					= o.ID;
			symbol				= o.Name;
			entityId              = o.XLR8CS__Financial_Account__r.XLR8CS__Entity__c;
			financialAccount	= o.XLR8CS__Financial_Account__c;
			quantityOfShares	= o.XLR8CS__Quantity_of_Shares__c;
			securityDescription	= o.XLR8CS__Security_Description__c;
			totalValue			= o.XLR8CS__Total_Value__c;
			asOfDate			= o.XLR8CS__As_Of_Date__c;
			costBasis           = o.XLR8CS__Cost_Basis__c;
		}	
	}
	/**
	  * This class is an abstraction of the XLR8CS__XLR8_Insurance__c object
	  */
	global class InsuranceObject{
		WebService  Integer returnCode;
		WebService  String  message;
		
		webservice  String  id;						
		webservice	String	recordType;				
		webservice	String	entity;					
		webservice	String	policyNumberOrName;		
		webservice	String	policyHolder;			
		webservice	String	insuredIndividual;		
		webservice	String	status;					
		webservice	String	policyType;				
		webservice	String	insuranceCompany;		
		webservice	String	description;				
		webservice	Decimal	monthlyBenefit;			
		webservice	Decimal	surrenderValue;			
		webservice	Decimal	dailyBenefit;			
		webservice	Decimal	deathBenefit;			
		webservice	Decimal	maximumBenefit;			
		webservice	Decimal	deductible;				
		webservice	Decimal	faceValue;				
		webservice	Decimal	annualPremium;			
		webservice	String	premiumFrequency;		
		webservice	Datetime policyIssuedDate;	
		webservice	Datetime policyExpirationDate;
		webservice	Datetime policyEffectiveDate;	
		webservice  String   registeredPolicyOwner;
		webservice  String   registeredInsuredIndividual;
		
		public InsuranceObject(XLR8CS__XLR8_Insurance__c o){
			id					= o.ID;
			recordType			= o.RecordType.Name;
			entity				= o.XLR8CS__Entity__r.Name ;
			policyNumberOrName	= o.Name;
			policyHolder		= o.XLR8CS__Policy_Holder__r.Name;
			insuredIndividual	= o.XLR8CS__Insured_Individual__r.Name;
			status				= o.XLR8CS__Status__c;
			policyType			= o.XLR8CS__Policy_Type__c;
			insuranceCompany	= o.XLR8CS__Insurance_Company__c;
			description			= o.XLR8CS__Description__c;
			monthlyBenefit		= o.XLR8CS__Monthly_Benefit__c;
			surrenderValue		= o.XLR8CS__Surrender_Value__c;
			dailyBenefit		= o.XLR8CS__Daily_Benefit__c;
			deathBenefit		= o.XLR8CS__Death_Benefit__c;
			maximumBenefit		= o.XLR8CS__Maximum_Benefit__c;
			deductible			= o.XLR8CS__Deductible__c;
			faceValue			= o.XLR8CS__Face_Value__c;
			annualPremium		= o.XLR8CS__Annual_Premium__c;
			premiumFrequency	= o.XLR8CS__Premium_Frequency__c;
			policyIssuedDate	= o.XLR8CS__Policy_Issued_Date__c;
			policyExpirationDate= o.XLR8CS__Policy_Expiration_Date__c;
			policyEffectiveDate	= o.XLR8CS__Policy_Effective_Date__c;
			registeredPolicyOwner = o.XLR8CS__Registered_Policy_Owner__c;
			registeredInsuredIndividual = o.XLR8CS__Registered_Insured_Individual__c;
		}
	}	
	
	/**
	  * This class is an abstraction of the XLR8CS__Income_and_Expense__c object
	  */
	global class IncomeAndExpenseObject{
		WebService  Integer returnCode;
		WebService  String  message;
		
		webservice	String	id;				  
		webservice	String	recordType;		  
		webservice	String	entity;			  
		webservice	String	incomeType;		  
		webservice	String	ownerRegistration; 
		webservice	String	primaryOwner;	  
		webservice	String	secondaryOwner;	  
		webservice	String	description;		  
		webservice	Decimal	amount;			  
		webservice	Date	asOfDate;		  
		webservice	String	frequency;		  
		webservice	String	notes;			  
		webservice	String	howOftenRecurring; 
		webservice	String	yearsExpectedToBeIncurred; 
		webservice	Decimal	AnnualIncrease;	  
		webservice	Decimal	yearsToContinue;	  

		public IncomeAndExpenseObject(){}
		
		public IncomeAndExpenseObject(XLR8CS__Income_and_Expense__c  o){
			id					= o.ID;
			recordType			= o.RecordType.Name;
			entity				= o.XLR8CS__Entity__r.Name;
			incomeType			= o.XLR8CS__Type__c ;
			ownerRegistration	= o.XLR8CS__Owner_Registration__c;
			primaryOwner		= o.XLR8CS__Primary_Owner__r.Name;
			secondaryOwner		= o.XLR8CS__Secondary_Owner__r.Name;
			description			= o.XLR8CS__Description__c;
			amount				= o.XLR8CS__Amount__c;
			asOfDate			= o.XLR8CS__As_Of_Date__c;
			frequency			= o.XLR8CS__Frequency__c;
			notes				= o.XLR8CS__Notes__c;
			howOftenRecurring	= o.XLR8CS__Recurring_How_Often__c;
			AnnualIncrease		= o.XLR8CS__Pct_Annual_Increase__c;
			yearsToContinue		= o.XLR8CS__Years_to_Continue__c;
			yearsExpectedToBeIncurred =	o.XLR8CS__Year_Expected_to_be_Incurred__c;
		}
	}
	
	/**
	  * This class is an abstraction of the XLR8CS__XLR8_Estate_Planning_Gifting__c object
	  */
	global class EstateAndPlansGiftingObject{
		WebService  Integer returnCode;
		WebService  String  message;
		
		webservice	String	id;
		webservice	String	recordType;	
		webservice	String	planGiftID;	
		webservice	String	entity;	
		webservice	String	contact;	
		webservice	String	description;	
		webservice	String	status;	
		webservice	Date	dateGiven;	
		webservice	String	instrumentGiftType;	
		webservice	Boolean	recurring;
		webservice	String	recipient;	
		webservice	Decimal	value;
		webservice	Date	valueAsOf;
		webservice	Date	dateExecuted;	
		webservice	String	documentType;
		
		public EstateAndPlansGiftingObject(){}
		
		public EstateAndPlansGiftingObject(XLR8CS__XLR8_Estate_Planning_Gifting__c o){
			id			= o.ID;
			recordType	= o.RecordType.Name;
			planGiftID	= o.Name;
			entity		= o.XLR8CS__Entity__r.Name;
			contact		= o.XLR8CS__Contact__r.Name;
			description	= o.XLR8CS__Description__c;
			status		= o.XLR8CS__Status__c;
			dateGiven	= o.XLR8CS__Date_Given__c;
			recurring	= o.XLR8CS__Recurring__c;
			recipient	= o.XLR8CS__Recipient__c;
			value		= o.XLR8CS__Value__c;
			valueAsOf	= o.XLR8CS__Value_as_of__c;
			dateExecuted= o.XLR8CS__Date_Executed__c;
			documentType= o.XLR8CS__Document_Type__c;
			instrumentGiftType	= o.XLR8CS__Instrument_Gift_Type__c;
		}
	}	
	
	/**
	* This class is list of ContactObjects
	*/
	global class ContactObjects {
		WebService Integer returnCode;
		WebService String message;
 
		WebService List<ContactObject> objects;
 
		/**
		* Empty constructor
		*/
		public ContactObjects() {}
 
		/**
		* Constructor based on a list of XLR8CS__XLR8_Assets_Liabilities__c	
		*/
		public ContactObjects(List<Contact> objList) {
			this.objects = new List<ContactObject>();
			for (Contact o: objList) {
				this.objects.add(new ContactObject(o));
			}
		}
	}
	
	/**
	* This class is list of AssetObject
	*/
	global class AssetObjects {
		WebService Integer returnCode;
		WebService String message;
 
		WebService List<AssetObject> objects;
 
		/**
		* Empty constructor
		*/
		public AssetObjects() {}
 
		/**
		* Constructor based on a list of XLR8CS__XLR8_Assets_Liabilities__c	
		*/
		public AssetObjects(List<XLR8CS__XLR8_Assets_Liabilities__c> objList) {
			this.objects = new List<AssetObject>();
			for (XLR8CS__XLR8_Assets_Liabilities__c o: objList) {
				this.objects.add(new AssetObject(o));
			}
		}
	}
	
	/**
	* This class is list of HoldingsObject
	*/
	global class HoldingObjects {
		WebService Integer returnCode;
		WebService String message;
 
		WebService List<HoldingObject> objects;
 
		/**
		* Empty constructor
		*/
		public HoldingObjects() {}
 
		/**
		* Constructor based on a list of XLR8CS__XLR8_Securities__c	
		*/
		public HoldingObjects(List<XLR8CS__XLR8_Securities__c> objList) {
			this.objects = new List<HoldingObject>();
			for (XLR8CS__XLR8_Securities__c o: objList) {
				this.objects.add(new HoldingObject(o));
			}
		}
	}
	
	/**
	* This class is list of InsuranceObjects
	*/
	global class InsuranceObjects {
		WebService Integer returnCode;
		WebService String message;
 
		WebService List<InsuranceObject> objects;
 
		/**
		* Empty constructor
		*/
		public InsuranceObjects() {}
 
		/**
		* Constructor based on a list of XLR8CS__XLR8_Insurance__c	
		*/
		public InsuranceObjects(List<XLR8CS__XLR8_Insurance__c> objList) {
			this.objects = new List<InsuranceObject>();
			for (XLR8CS__XLR8_Insurance__c o: objList) {
				this.objects.add(new InsuranceObject(o));
			}
		}
	}
	
	/**
	* This class is list of IncomeAndExpenseObject
	*/
	global class IncomeAndExpenseObjects {
		WebService Integer returnCode;
		WebService String message;
 
		WebService List<IncomeAndExpenseObject> objects;
 
		/**
		* Empty constructor
		*/
		public IncomeAndExpenseObjects() {}
 
		/**
		* Constructor based on a list of XLR8CS__Income_and_Expense__c	
		*/
		public IncomeAndExpenseObjects(List<XLR8CS__Income_and_Expense__c> objList) {
			this.objects = new List<IncomeAndExpenseObject>();
			for (XLR8CS__Income_and_Expense__c o: objList) {
				this.objects.add(new IncomeAndExpenseObject(o));
			}
		}
	}
	
	/**
	* This class is list of InsuranceObjects
	*/
	global class EstateAndPlansGiftingObjects {
		WebService Integer returnCode;
		WebService String message;
 
		WebService List<EstateAndPlansGiftingObject> objects;
 
		/**
		* Empty constructor
		*/
		public EstateAndPlansGiftingObjects() {}
 
		/**
		* Constructor based on a list of XLR8CS__XLR8_Estate_Planning_Gifting__c	
		*/
		public EstateAndPlansGiftingObjects(List<XLR8CS__XLR8_Estate_Planning_Gifting__c> objList) {
			this.objects = new List<EstateAndPlansGiftingObject>();
			for (XLR8CS__XLR8_Estate_Planning_Gifting__c o: objList) {
				this.objects.add(new EstateAndPlansGiftingObject(o));
			}
		}
	}
}