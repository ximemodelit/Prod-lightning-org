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
private class TestXLR8API {

    private static Account createAccount(String entityName, String envelopeName, string serviceLevel, 
                                  String primaryAdvisor, String phone, String phoneType, String phone2, String phone2Type,
                                  String fax, String website, String clientSvcsAdmin){
        Account a = new Account();
        a.Name = entityName;
        a.XLR8CS__Envelope_Name__c = envelopeName;
        a.XLR8CS__Service_Level__c = serviceLevel;
        a.XLR8CS__Primary_Advisor__c = primaryAdvisor;
        a.Phone = phone;
        a.XLR8CS__Phone_Type__c = phoneType;
        a.XLR8CS__Phone_2__c = phone2;
        a.XLR8CS__Phone_2_Type__c = phone2Type;
        a.Fax = fax;
        a.Website = website;
        a.XLR8CS__Client_Svcs_Admin__c = clientSvcsAdmin;
        return a;
    }
    
    
    public static Contact createContact(Date birthdate, String socialSecurity, String gender, String maritalStatus, String employer,
                                 String employmentStatus, Date retirementDate, String occupation, Boolean primaryContact, Boolean corecontact,
                                 String email, String email2, String email3, String notes, String businessPhone, String homePhone, 
                                 String mobile, String fax, String accountId, String firstName, String lastName,
                                 String suffix, String informalName, String envelopeName, String relationToEntity, 
                                 String clientRole, String salutation, String middleName ){
                                 	
        Contact c = new Contact();
        c.Birthdate = birthdate;
        c.XLR8CS__Social_Security__c = socialSecurity;
        c.XLR8CS__Gender__c = gender;
        c.XLR8CS__Marital_Status__c = maritalStatus;
        c.XLR8CS__Employer__c = employer;
        c.XLR8CS__Employment_Status__c = employmentStatus;
        c.XLR8CS__Retirement_Date__c = retirementDate;
        c.XLR8CS__Occupation__c  = occupation;
        c.XLR8CS__Primary_Contact__c = primaryContact;
        c.XLR8CS__Core_Contact__c = coreContact;
        c.Email = email;
        c.XLR8CS__Email_2__c = email2;
        c.XLR8CS__Email_3__c = email3;
        c.XLR8CS__Critical_Notes__c = notes;
        c.XLR8CS__Business_Phone__c = businessPhone;
        c.HomePhone = homePhone;
        c.MobilePhone = mobile;
        c.Fax = fax;
        c.AccountId = accountId;
        c.FirstName = firstName;
        c.LastName = lastName;
        c.XLR8CS__Suffix__c = suffix;
		c.XLR8CS__Informal_Name__c = informalName;
		c.XLR8CS__Envelope_Name__c = envelopeName;
		c.XLR8CS__Relation_to_Entity__c = relationToEntity;
		c.XLR8CS__Client_Role__c = clientRole;
		c.Salutation = salutation;
		c.XLR8CS__middle_name__c = middleName;
        return c;
    }
    
    public static XLR8CS__XLR8_Assets_Liabilities__c createAsset(String assetAccountNumber, String entity, 
                                                          String assetCategory, String custodian, String registration, double valueBalance,
                                                          Date asofDate, Double cashValue, Double acquisitionValue,String assetClassification,
                                                          Boolean includeInNetWorth, Date acquiredOpenedDate, Date inactiveDate, String description, 
                                                          Double initialLoanAmount, String loanType, String rateStructure, Double amortizationTerm,
                                                          Double interestRate, Double paymentAmount, String paymentFrequency, Date maturityDate,
                                                          String primaryOwner, String secondaryOwner, String institution , String revolvinLoan){
        
        XLR8CS__XLR8_Assets_Liabilities__c a = new XLR8CS__XLR8_Assets_Liabilities__c();
        a.Name = assetAccountNumber;
        a.XLR8CS__Entity__c = entity;
        a.XLR8CS__Category__c = assetCategory;
        a.XLR8CS__Custodian__c = custodian;
        a.XLR8CS__Registration__c = registration;
        a.XLR8CS__Value_Balance__c = valueBalance;
        a.XLR8CS__As_Of_Date__c = asofDate;
        a.XLR8CS__Cash_Value__c = cashValue;
        a.XLR8CS__Aquisition_Value__c  = acquisitionValue;
        a.XLR8CS__Asset_Classification__c = assetClassification;
        a.XLR8CS__Include_In_Net_Worth__c = includeinNetWorth;
        a.XLR8CS__Acquired_Opened_Date__c = acquiredOpenedDate;
        a.XLR8CS__Inactive_Date__c = inactiveDate;
        a.XLR8CS__Description__c = description;
        a.XLR8CS__Initial_Loan_Amount__c = initialLoanAmount;
        a.XLR8CS__Loan_Type__c = loanType;
        a.XLR8CS__Rate_Structure__c = rateStructure;
        a.XLR8CS__Amortization_Term__c = amortizationTerm;
        a.XLR8CS__Interest_Rate__c = interestRate;
        a.XLR8CS__Payment_Amount__c = paymentAmount;
        a.XLR8CS__Payment_Frequency__c = paymentFrequency;
        a.XLR8CS__Maturity_Date__c = maturityDate;  
        a.XLR8CS__Primary_Owner__c = primaryOwner;
        a.XLR8CS__Secondary_Owner__c = secondaryOwner;
        a.XLR8CS__Institution__c = institution;
        a.XLR8CS__Revolving_Loan__c = revolvinLoan;
        
        return a;
    }
    
    public static XLR8CS__XLR8_Securities__c createHolding(String symbol, String financialAccount, Double quantityOfShares, 
                                                    String securityDescription, Double totalvalue, Date asOfDate, Decimal costBasis){
        XLR8CS__XLR8_Securities__c o = new XLR8CS__XLR8_Securities__c();
        o.Name = symbol;
        o.XLR8CS__Financial_Account__c = financialAccount;
        o.XLR8CS__Quantity_of_Shares__c = quantityOfShares;
        o.XLR8CS__Security_Description__c = securityDescription;
        o.XLR8CS__Total_Value__c = totalValue;
        o.XLR8CS__As_Of_Date__c = asOfDate;
        o.XLR8CS__Cost_Basis__c = costBasis;
        return o;
    }
    
    public static XLR8CS__XLR8_Insurance__c createInsurance(String entity, String policyNumberOrname, String policyHolder,
                                                    String insuredIndividual, string status, String policyType, string insuranceCompany, 
                                                    String description, double monthlyBenefit, Double surrenderValue, Double dailyBenefit, 
                                                    Double deathBenefit, Double maximumBenefit, Double deductible, Double faceValue, Double annualPremium,
                                                    String premiumFrequency, Date policyIssuedDate, Date policyExpirationDate, Date policyEffectiveDate,
                                                    String registeredPolicyOwner, String registeredInsuredIndividual){
        XLR8CS__XLR8_Insurance__c o = new XLR8CS__XLR8_Insurance__c();
        o.XLR8CS__Entity__c = entity ;
        o.Name = policyNumberOrName;
        o.XLR8CS__Policy_Holder__c = policyHolder;
        o.XLR8CS__Insured_Individual__c = insuredIndividual;
        o.XLR8CS__Status__c = status;
        o.XLR8CS__Policy_Type__c = policyType;
        o.XLR8CS__Insurance_Company__c = insuranceCompany;
        o.XLR8CS__Description__c = description;
        o.XLR8CS__Monthly_Benefit__c = monthlyBenefit;
        o.XLR8CS__Surrender_Value__c = surrenderValue;
        o.XLR8CS__Daily_Benefit__c = dailyBenefit;
        o.XLR8CS__Death_Benefit__c = deathBenefit;
        o.XLR8CS__Maximum_Benefit__c = maximumBenefit;
        o.XLR8CS__Deductible__c = deductible;
        o.XLR8CS__Face_Value__c = faceValue;
        o.XLR8CS__Annual_Premium__c = annualPremium;
        o.XLR8CS__Premium_Frequency__c = premiumFrequency;
        o.XLR8CS__Policy_Issued_Date__c = policyIssuedDate;
        o.XLR8CS__Policy_Expiration_Date__c = policyExpirationDate;
        o.XLR8CS__Policy_Effective_Date__c = policyEffectiveDate;
        o.XLR8CS__Registered_Policy_Owner__c = registeredPolicyOwner;
        o.XLR8CS__Registered_Insured_Individual__c = registeredInsuredIndividual;
        
        return o;
    }
    
    public static XLR8CS__Income_and_Expense__c createIncome(String entity, String incometype, String ownerRegistration,
                                                      String primaryOwner, String secondaryOwner, String description, Double amount,
                                                      Date asOfDate, String frequency, String notes, String howOftenRecurring, 
                                                      Double AnnualIncrease, Double yearsToContinue, String yearsExpectedtoBeIncurred){
        XLR8CS__Income_and_Expense__c o = new XLR8CS__Income_and_Expense__c();
        o.XLR8CS__Entity__c = entity;
        o.XLR8CS__Type__c = incomeType;
        o.XLR8CS__Owner_Registration__c = ownerRegistration;
        o.XLR8CS__Primary_Owner__c = primaryOwner;
        o.XLR8CS__Secondary_Owner__c = secondaryOwner;
        o.XLR8CS__Description__c = description;
        o.XLR8CS__Amount__c = amount;
        o.XLR8CS__As_Of_Date__c = asOfDate;
        o.XLR8CS__Frequency__c = frequency;
        o.XLR8CS__Notes__c = notes;
        o.XLR8CS__Recurring_How_Often__c = howOftenRecurring;
        o.XLR8CS__Pct_Annual_Increase__c = AnnualIncrease;
        o.XLR8CS__Years_to_Continue__c = yearsToContinue;
        o.XLR8CS__Year_Expected_to_be_Incurred__c = yearsExpectedToBeIncurred;
        return o;
    }
    
    public static XLR8CS__XLR8_Estate_Planning_Gifting__c createPlanAndGifting(String entity,String instrumentGiftType,
                                                                        String contact, String description, String status, Date dateGiven, Boolean recurring,
                                                                        String recipient, Double value, Date valueASOf, Date dateExecuted, String documentType){
        XLR8CS__XLR8_Estate_Planning_Gifting__c o = new XLR8CS__XLR8_Estate_Planning_Gifting__c();
        o.XLR8CS__Entity__c = entity;
        o.XLR8CS__Contact__c = contact;
        o.XLR8CS__Description__c = description;
        o.XLR8CS__Status__c = status;
        o.XLR8CS__Date_Given__c = dateGiven;
        o.XLR8CS__Recurring__c = recurring;
        o.XLR8CS__Recipient__c = recipient;
        o.XLR8CS__Value__c = value;
        o.XLR8CS__Value_as_of__c = valueAsOf;
        o.XLR8CS__Date_Executed__c = dateExecuted;
        o.XLR8CS__Document_Type__c = documentType;
        o.XLR8CS__Instrument_Gift_Type__c = instrumentGiftType;
        return o;
    }
    
    static testMethod void getAccount() {
    	
    	
    	
        // Create one account
        Account a = createAccount('Salesforce.com', 'Envelope Name', 'A', 
                                  UserInfo.getUserId(), '1-111-111-1111' , 'Business', '1-111-111-2222', 'Home',
                                  '1-111-111-1113', 'www.salesforce.com', UserInfo.getUserId());
        
       insert a;
       system.assertNotEquals(a.Id, null);
       
       XLR8APITypes.AccountObject accountObject = XLR8API.getAccount(a.Id);
       
       Account o = XLR8APIUtils.getAccount(a.Id);
       system.assertNotEquals(accountObject, null);
       system.assertEquals(accountObject.returnCode,200);
       system.assertEquals(accountObject.message,'Success');   
       
       //Verify data was loaded
        System.assertNotEquals(accountObject, null);
        system.assertEquals(accountObject.id,o.ID);
        system.assertEquals(accountObject.entityName,o.Name);
        system.assertEquals(accountObject.recordType,o.RecordType.Name);
        system.assertEquals(accountObject.envelopeName,o.XLR8CS__Envelope_Name__c);
        system.assertEquals(accountObject.serviceLevel,o.XLR8CS__Service_Level__c);
        system.assertEquals(accountObject.primaryAdvisor,o.XLR8CS__Primary_Advisor__r.Name);
        system.assertEquals(accountObject.secondaryAdvisor,o.XLR8CS__Secondary_Advisor__r.Name);
        system.assertEquals(accountObject.phone, o.Phone);
        system.assertEquals(accountObject.phoneType, o.XLR8CS__Phone_Type__c);
        system.assertEquals(accountObject.phone2,o.XLR8CS__Phone_2__c);
        system.assertEquals(accountObject.phone2Type,o.XLR8CS__Phone_2_Type__c);
        system.assertEquals(accountObject.fax,o.Fax);
        system.assertEquals(accountObject.website, o.Website);
        system.assertEquals(accountObject.mergeCO,o.XLR8CS__Merge_C_O__c);
        system.assertEquals(accountObject.mergeStreet,o.XLR8CS__Merge_Street__c);
        system.assertEquals(accountObject.mergeCity,o.XLR8CS__Merge_City__c);
        system.assertEquals(accountObject.mergeState, o.XLR8CS__Merge_State__c);
        system.assertEquals(accountObject.mergeZip,o.XLR8CS__Merge_Zip__c);
        system.assertEquals(accountObject.mergeCountry,o.XLR8CS__Merge_Country__c);
        system.assertEquals(accountObject.clientSvcsAdmin,o.XLR8CS__Client_Svcs_Admin__r.Name);
       
       // Request account with null id
       accountObject = XLR8API.getAccount(null);
       system.assertNotEquals(accountObject, null);
       system.assertEquals(accountObject.returnCode,400);
       system.assertEquals(accountObject.message,'Invalid account id');   
       
       // Request account with empty id
       accountObject = XLR8API.getAccount('');
       system.assertNotEquals(accountObject, null);
       system.assertEquals(accountObject.returnCode,400);
       system.assertEquals(accountObject.message,'Invalid account id');
       
       // Request account with non existing id
       accountObject = XLR8API.getAccount('001F000001340u6');
       system.assertNotEquals(accountObject, null);
       system.assertEquals(accountObject.returnCode,404);
       system.assertEquals(accountObject.message,'Unable to find account by account Id');
       
       // Request records with an invalid account id
       accountObject = XLR8API.getAccount('foo');
       system.assertNotEquals(accountObject, null);
       system.assertEquals(accountObject.returnCode,404);
       system.assertEquals(accountObject.message,'Account ID null or blank');
    }
    
    static testMethod void getContacts() {
    	
    	
        
        // Create two accounts
        List<Account>accounts = new List<Account>();
        Account a1 = createAccount('Salesforce.com', 'Envelope Name', 'A', 
                                  UserInfo.getUserId(), '1-111-111-1111' , 'Business', '1-111-111-2222', 'Home',
                                  '1-111-111-1113', 'www.salesforce.com', null);
       
        accounts.add(a1);
        Account a2 = createAccount('Ucla', 'Envelope Name', 'A', 
                                  UserInfo.getUserId(), '1-111-111-1111' , 'Business', '1-111-111-2222', 'Home',
                                  '1-111-111-1113', 'www.lala.com', null);
       
        accounts.add(a2);
        insert accounts;
        system.assertNotEquals(a1.Id, null);
        system.assertNotEquals(a2.Id, null);
       
        // Insert three contacts. The first two will be related to account 1. 
        List<Contact> contacts = new List<Contact>();
        Contact c1 = createContact(system.today().addYears(-20),'43800170', 'Female', 'Single', 'Global', 'Employed',
                                   system.today().addYears(2), 'Software Developer', false, true, 'test@test.com', 
                                   'test2@test.com', '', 'Notes', ' 1-123-123-2233', '1-123-222-2222','1-345-555-6677',
                                    '1-345-444-5353', a1.Id, 'Contact 1', 'Test',
                                    'Mr', 'Sweet','Mr Sweet', 'Consultant', 'Client', 'Salutation', 'Middle Name'  );
        contacts.add(c1);
       
        Contact c2 = createContact(system.today().addYears(-20),'55800170', 'Female', 'Single', 'Global', 'Employed',
                                    system.today().addYears(2), 'Software Developer', false, true, 'atest@test.com', 
                                    'atest2@test.com', '', 'Notes', ' 1-123-123-2233', '1-123-222-2222','1-345-555-6677', 
                                    '1-345-444-5353', a1.Id, 'Contact 2', 'Test', 'Mr', 'Sweet','Mr Sweet', 
                                    'Consultant', 'Client', 'Salutation', 'Middle Name');
        contacts.add(c2);
       
        Contact c3 = createContact(system.today().addYears(-20),'55800170', 'Female', 'Single', 'Global', 'Employed',
                                    system.today().addYears(2), 'Software Developer', false, true, 'atest@test.com', 
                                    'atest2@test.com', '', 'Notes', ' 1-123-123-2233', '1-123-222-2222','1-345-555-6677', 
                                    '1-345-444-5353', a2.Id, 'Contact 3', 'Test', 'Mr', 'Sweet','Mr Sweet', 
                                    'Consultant', 'Client', 'Salutation', 'Middle Name' );
        contacts.add(c3);
       
        insert contacts;
        
        system.assertNotEquals(c1.Id, null);
        system.assertNotEquals(c2.Id, null);
        system.assertNotEquals(c3.Id, null);
        
        // Get contacts for account 1
        XLR8APITypes.ContactObjects contactObjects = XLR8API.getContacts(a1.Id); 
        system.assertNotEquals(contactObjects, null);
        system.assertNotEquals(contactObjects.objects, null);
        system.assertEquals(contactObjects.objects.size(), 2);
       system.assertEquals(contactObjects.returnCode,200);
       system.assertEquals(contactObjects.message,'Success');    
             
        XLR8APITypes.ContactObject contact1 = null;
        XLR8APITypes.ContactObject contact2 = null;
        for (XLR8APITypes.ContactObject c : contactObjects.objects){
            if (c.email == c1.Email){
                contact1 = c;
            }else{
                contact2 = c;
            }
        }

        c1 = [Select birthdate, Account.Name, XLR8CS__Social_Security__c, XLR8CS__Gender__c, XLR8CS__Marital_Status__c, 
                     XLR8CS__Employer__c, XLR8CS__Employment_Status__c, XLR8CS__Retirement_Date__c, XLR8CS__Occupation__c,
                     XLR8CS__Primary_Contact__c, XLR8CS__Core_Contact__c, Email,XLR8CS__Email_2__c, XLR8CS__Email_3__c,
                     XLR8CS__Critical_Notes__c, XLR8CS__Business_Phone__c, HomePhone, MobilePhone, Fax, XLR8CS__Merge_C_O__c,
                     XLR8CS__Merge_Street__c, XLR8CS__Merge_City__c, XLR8CS__Merge_State__c, XLR8CS__Merge_Zip__c, 
                     XLR8CS__Merge_Country__c, XLR8CS__Suffix__c,XLR8CS__Informal_Name__c,XLR8CS__Envelope_Name__c,
                     XLR8CS__Relation_To_Entity__c,XLR8CS__Client_Role__c, FirstName, LastName
              from Contact where id =: c1.Id];
        system.assertEquals(contact1.birthdate,c1.Birthdate);
        system.assertEquals(contact1.socialSecurity,c1.XLR8CS__Social_Security__c);
        system.assertEquals(contact1.gender,c1.XLR8CS__Gender__c);
        system.assertEquals(contact1.maritalStatus,c1.XLR8CS__Marital_Status__c);
        system.assertEquals(contact1.employer,c1.XLR8CS__Employer__c);
        system.assertEquals(contact1.employmentStatus,c1.XLR8CS__Employment_Status__c);
        system.assertEquals(contact1.retirementDate,c1.XLR8CS__Retirement_Date__c);
        system.assertEquals(contact1.occupation, c1.XLR8CS__Occupation__c); 
        system.assertEquals(contact1.primaryContact, c1.XLR8CS__Primary_Contact__c);
        system.assertEquals(contact1.coreContact, c1.XLR8CS__Core_Contact__c);
        system.assertEquals(contact1.email, c1.Email);
        system.assertEquals(contact1.email2, c1.XLR8CS__Email_2__c);
        system.assertEquals(contact1.email3, c1.XLR8CS__Email_3__c);
        system.assertEquals(contact1.notes, c1.XLR8CS__Critical_Notes__c);
        system.assertEquals(contact1.businessPhone, c1.XLR8CS__Business_Phone__c);
        system.assertEquals(contact1.homePhone, c1.HomePhone);
        system.assertEquals(contact1.mobile, c1.MobilePhone);
        system.assertEquals(contact1.fax, c1.Fax);
        system.assertEquals(contact1.mergeCO, c1.XLR8CS__Merge_C_O__c);
        system.assertEquals(contact1.mergeStreet, c1.XLR8CS__Merge_Street__c);
        system.assertEquals(contact1.mergeCity, c1.XLR8CS__Merge_City__c);
        system.assertEquals(contact1.mergeState, c1.XLR8CS__Merge_State__c);
        system.assertEquals(contact1.mergeZip, c1.XLR8CS__Merge_Zip__c);
        system.assertEquals(contact1.mergeCountry, c1.XLR8CS__Merge_Country__c);
        system.assertEquals(contact1.suffix, c1.XLR8CS__Suffix__c);
        system.assertEquals(contact1.informalName, c1.XLR8CS__Informal_Name__c);
        system.assertEquals(contact1.envelopeName, c1.XLR8CS__Envelope_Name__c);
        system.assertEquals(contact1.relationToEntity, c1.XLR8CS__Relation_To_Entity__c);
        system.assertEquals(contact1.clientRole, c1.XLR8CS__Client_Role__c);
        system.assertEquals(contact1.firstName, c1.FirstName);
        system.assertEquals(contact1.lastName, c1.lastName);
        system.assertEquals(contact1.accountName, c1.Account.Name);

        c2 = [Select birthdate, Account.Name, XLR8CS__Social_Security__c, XLR8CS__Gender__c, XLR8CS__Marital_Status__c, 
                                         XLR8CS__Employer__c, XLR8CS__Employment_Status__c, XLR8CS__Retirement_Date__c, XLR8CS__Occupation__c,
                                         XLR8CS__Primary_Contact__c, XLR8CS__Core_Contact__c, Email,XLR8CS__Email_2__c, XLR8CS__Email_3__c,
                                         XLR8CS__Critical_Notes__c, XLR8CS__Business_Phone__c, HomePhone, MobilePhone, Fax, XLR8CS__Merge_C_O__c,
                                         XLR8CS__Merge_Street__c, XLR8CS__Merge_City__c, XLR8CS__Merge_State__c, XLR8CS__Merge_Zip__c, 
                                         XLR8CS__Merge_Country__c, XLR8CS__Suffix__c,XLR8CS__Informal_Name__c,XLR8CS__Envelope_Name__c,
                                         XLR8CS__Relation_To_Entity__c,XLR8CS__Client_Role__c, FirstName, LastName
                                         from Contact where id =: c2.Id];
        system.assertEquals(contact2.birthdate,c2.Birthdate);
        system.assertEquals(contact2.socialSecurity,c2.XLR8CS__Social_Security__c);
        system.assertEquals(contact2.gender,c2.XLR8CS__Gender__c);
        system.assertEquals(contact2.maritalStatus,c2.XLR8CS__Marital_Status__c);
        system.assertEquals(contact2.employer,c2.XLR8CS__Employer__c);
        system.assertEquals(contact2.employmentStatus,c2.XLR8CS__Employment_Status__c);
        system.assertEquals(contact2.retirementDate,c2.XLR8CS__Retirement_Date__c);
        system.assertEquals(contact2.occupation, c2.XLR8CS__Occupation__c); 
        system.assertEquals(contact2.primaryContact, c2.XLR8CS__Primary_Contact__c);
        system.assertEquals(contact2.coreContact, c2.XLR8CS__Core_Contact__c);
        system.assertEquals(contact2.email, c2.Email);
        system.assertEquals(contact2.email2, c2.XLR8CS__Email_2__c);
        system.assertEquals(contact2.email3, c2.XLR8CS__Email_3__c);
        system.assertEquals(contact2.notes, c2.XLR8CS__Critical_Notes__c);
        system.assertEquals(contact2.businessPhone, c2.XLR8CS__Business_Phone__c);
        system.assertEquals(contact2.homePhone, c2.HomePhone);
        system.assertEquals(contact2.mobile, c2.MobilePhone);
        system.assertEquals(contact2.fax, c2.Fax);
        system.assertEquals(contact2.mergeCO, c2.XLR8CS__Merge_C_O__c);
        system.assertEquals(contact2.mergeStreet, c2.XLR8CS__Merge_Street__c);
        system.assertEquals(contact2.mergeCity, c2.XLR8CS__Merge_City__c);
        system.assertEquals(contact2.mergeState, c2.XLR8CS__Merge_State__c);
        system.assertEquals(contact2.mergeZip, c2.XLR8CS__Merge_Zip__c);
        system.assertEquals(contact2.mergeCountry, c2.XLR8CS__Merge_Country__c);
        system.assertEquals(contact2.suffix, c2.XLR8CS__Suffix__c);
        system.assertEquals(contact2.informalName, c2.XLR8CS__Informal_Name__c);
        system.assertEquals(contact2.envelopeName, c2.XLR8CS__Envelope_Name__c);
        system.assertEquals(contact2.relationToEntity, c2.XLR8CS__Relation_To_Entity__c);
        system.assertEquals(contact2.clientRole, c2.XLR8CS__Client_Role__c);
        system.assertEquals(contact2.firstName, c2.FirstName);
        system.assertEquals(contact2.lastName, c2.lastName);
		system.assertEquals(contact2.accountName, c2.Account.Name);
		
		
       // Request account with null id
       contactObjects = XLR8API.getContacts(null);
       system.assertNotEquals(contactObjects, null);
       system.assertEquals(contactObjects.returnCode,400);
       system.assertEquals(contactObjects.message,'Invalid account id');   
       
       // Request account with empty id
       contactObjects = XLR8API.getContacts('');
       system.assertNotEquals(contactObjects, null);
       system.assertEquals(contactObjects.returnCode,400);
       system.assertEquals(contactObjects.message,'Invalid account id');
       
       // Request account with non existing id
       contactObjects = XLR8API.getContacts('001F000001340u6');
       system.assertNotEquals(contactObjects, null);
       system.assertEquals(contactObjects.returnCode,404);
       system.assertEquals(contactObjects.message,'Unable to find contacts related to given account Id: 001F000001340u6');
       
       // Request records with an invalid account id
       contactObjects = XLR8API.getContacts('foo');
       system.assertNotEquals(contactObjects, null);
       system.assertEquals(contactObjects.returnCode,404);
       system.assertEquals(contactObjects.message,'Account ID null or blank');
    }
    
    static testMethod void getAssets() {
        
        
        // Create two accounts
        List<Account>accounts = new List<Account>();
        Account a1 = createAccount('Salesforce.com', 'Envelope Name', 'A', 
                                  UserInfo.getUserId(), '1-111-111-1111' , 'Business', '1-111-111-2222', 'Home',
                                  '1-111-111-1113', 'www.salesforce.com', null);
       
        accounts.add(a1);
        Account a2 = createAccount('Ucla', 'Envelope Name', 'A', 
                                  UserInfo.getUserId(), '1-111-111-1111' , 'Business', '1-111-111-2222', 'Home',
                                  '1-111-111-1113', 'www.lala.com', null);
       
        accounts.add(a2);
        insert accounts;
        system.assertNotEquals(a1.Id, null);
        system.assertNotEquals(a2.Id, null);
        
         // Insert three contacts. The first two will be related to account 1. 
        List<Contact> contacts = new List<Contact>();
        Contact c1 = createContact(system.today().addYears(-20),'43800170', 'Female', 'Single', 'Global', 'Employed',
                                   system.today().addYears(2), 'Software Developer', false, true, 'test@test.com', 
                                   'test2@test.com', '', 'Notes', ' 1-123-123-2233', '1-123-222-2222','1-345-555-6677',
                                    '1-345-444-5353', a1.Id, 'Contact 1', 'Test',
                                    'Mr', 'Sweet','Mr Sweet', 'Consultant', 'Client', 'Salutation', 'Middle Name'  );
        contacts.add(c1);
       
        Contact c2 = createContact(system.today().addYears(-20),'55800170', 'Female', 'Single', 'Global', 'Employed',
                                    system.today().addYears(2), 'Software Developer', false, true, 'atest@test.com', 
                                    'atest2@test.com', '', 'Notes', ' 1-123-123-2233', '1-123-222-2222','1-345-555-6677', 
                                    '1-345-444-5353', a1.Id, 'Contact 2', 'Test', 'Mr', 'Sweet','Mr Sweet', 
                                    'Consultant', 'Client', 'Salutation', 'Middle Name');
        contacts.add(c2);
        insert contacts;
        System.assertNotEquals(c1.Id, null);
        System.assertNotEquals(c2.Id, null);
       
        List<XLR8CS__XLR8_Assets_Liabilities__c> records = new List<XLR8CS__XLR8_Assets_Liabilities__c>();
        XLR8CS__XLR8_Assets_Liabilities__c o1 = createAsset('Asset 1', a1.Id, 
                                                          'IRA', 'Schawb', 'Client', 1000,
                                                          system.today(), 2000, 100, 'Real Estate',
                                                          false, system.today().adddays(-5), null, 'Description', 
                                                          1500, 'Funded', 'Rate', 13,
                                                          5, 100, 'Monthly', system.today().addYears(1), c1.Id, c2.Id,
                                                          'AmSouth Bank', 'Yes' );
        records.add(o1);
        
        XLR8CS__XLR8_Assets_Liabilities__c o2 = createAsset('Asset 2', a1.Id, 
                                                          'IRA', 'Fidelity', 'Client', 5000,
                                                          system.today().addDays(3), 1000, 140, 'Real Estate',
                                                          true, system.today().adddays(-5), null, 'Description 2', 
                                                          2500, 'Funded', 'Rate', 13,
                                                          58, 400, 'Monthly', system.today().addYears(4), null, null,
                                                          'Bank of America', 'no' );
        records.add(o2);
        
        XLR8CS__XLR8_Assets_Liabilities__c o3 = createAsset('Asset 1', a2.Id, 
                                                          'IRA', 'Schawb', 'Client', 1000,
                                                          system.today(), 2000, 100, 'Real Estate',
                                                          false, system.today().adddays(-5), null, 'Description', 
                                                          1500, 'Funded', 'Rate', 13,
                                                          5, 100, 'Monthly', system.today().addYears(1), c1.Id, c2.Id,
                                                          'AmSouth Bank', 'Yes' );
        records.add(o3);        
        insert records;
        
        system.assertNotEquals(o1.Id, null);
        system.assertNotEquals(o2.Id, null);
        system.assertNotEquals(o3.Id, null);
        
        // Get contacts for account 1
        XLR8APITypes.AssetObjects assetObjects = XLR8API.getAssets(a1.Id); 
        system.assertNotEquals(assetObjects, null);
        system.assertNotEquals(assetObjects.objects, null);
        system.assertEquals(assetObjects.objects.size(), 2);
        system.assertEquals(assetObjects.returnCode,200);
        system.assertEquals(assetObjects.message,'Success');  
       
        XLR8APITypes.AssetObject asset1 = null;
        XLR8APITypes.AssetObject asset2 = null;
        for (XLR8APITypes.AssetObject a : assetObjects.objects){
            if (a.id == o1.id){
                asset1 = a;
            }else{
                asset2 = a;
            }
        }

        o1 = [Select ID, Name, RecordType.Name, XLR8CS__Entity__r.Name, XLR8CS__Category__c, 
                      XLR8CS__Custodian__c, XLR8CS__Registration__c, XLR8CS__Value_Balance__c, 
                      XLR8CS__As_Of_Date__c, XLR8CS__Cash_Value__c, XLR8CS__Aquisition_Value__c, 
                      XLR8CS__Asset_Classification__c, XLR8CS__Include_In_Net_Worth__c, 
                      XLR8CS__Acquired_Opened_Date__c, XLR8CS__Inactive_Date__c, XLR8CS__Description__c, 
                      XLR8CS__Initial_Loan_Amount__c, XLR8CS__Loan_Type__c, XLR8CS__Rate_Structure__c, 
                      XLR8CS__Amortization_Term__c, XLR8CS__Interest_Rate__c, XLR8CS__Payment_Amount__c, 
                      XLR8CS__Payment_Frequency__c, XLR8CS__Maturity_Date__c, XLR8CS__Primary_Owner__r.Name,
                      XLR8CS__Secondary_Owner__r.Name, XLR8CS__Institution__c, XLR8CS__Revolving_Loan__c 
              From XLR8CS__XLR8_Assets_Liabilities__c 
              Where Id =: o1.Id];
        
    
    
        system.assertEquals(asset1.id, o1.ID);
        system.assertEquals(asset1.assetAccountNumber, o1.Name);
        system.assertEquals(asset1.recordType, o1.RecordType.Name);
        system.assertEquals(asset1.entity, o1.XLR8CS__Entity__c);
        system.assertEquals(asset1.entityName, o1.XLR8CS__Entity__r.Name);
        system.assertEquals(asset1.assetCategory, o1.XLR8CS__Category__c);
        system.assertEquals(asset1.custodian, o1.XLR8CS__Custodian__c);
        system.assertEquals(asset1.registration, o1.XLR8CS__Registration__c);
        system.assertEquals(asset1.valueBalance, o1.XLR8CS__Value_Balance__c);
        system.assertEquals(asset1.asofDate, o1.XLR8CS__As_Of_Date__c);
        system.assertEquals(asset1.cashValue, o1.XLR8CS__Cash_Value__c);
        system.assertEquals(asset1.acquisitionValue, o1.XLR8CS__Aquisition_Value__c );
        system.assertEquals(asset1.assetClassification, o1.XLR8CS__Asset_Classification__c);
        system.assertEquals(asset1.includeinNetWorth, o1.XLR8CS__Include_In_Net_Worth__c);
        system.assertEquals(asset1.acquiredOpenedDate, o1.XLR8CS__Acquired_Opened_Date__c);
        system.assertEquals(asset1.inactiveDate, o1.XLR8CS__Inactive_Date__c);
        system.assertEquals(asset1.description, o1.XLR8CS__Description__c);
        system.assertEquals(asset1.initialLoanAmount, o1.XLR8CS__Initial_Loan_Amount__c);
        system.assertEquals(asset1.loanType, o1.XLR8CS__Loan_Type__c);
        system.assertEquals(asset1.rateStructure, o1.XLR8CS__Rate_Structure__c);
        system.assertEquals(asset1.amortizationTerm, o1.XLR8CS__Amortization_Term__c);
        system.assertEquals(asset1.interestRate, o1.XLR8CS__Interest_Rate__c);
        system.assertEquals(asset1.paymentAmount, o1.XLR8CS__Payment_Amount__c);
        system.assertEquals(asset1.paymentFrequency, o1.XLR8CS__Payment_Frequency__c);
        system.assertEquals(asset1.maturityDate, o1.XLR8CS__Maturity_Date__c);
        system.assertEquals(asset1.primaryOwner, o1.XLR8CS__Primary_Owner__r.Name);
        system.assertEquals(asset1.secondaryOwner, o1.XLR8CS__Secondary_Owner__r.Name);
        system.assertEquals(asset1.institution, o1.XLR8CS__Institution__c);
        system.assertEquals(asset1.revolvingLoan, o1.XLR8CS__Revolving_Loan__c);
        
        o2 = [Select ID, Name, RecordType.Name, XLR8CS__Entity__r.Name, XLR8CS__Category__c, 
                      XLR8CS__Custodian__c, XLR8CS__Registration__c, XLR8CS__Value_Balance__c, 
                      XLR8CS__As_Of_Date__c, XLR8CS__Cash_Value__c, XLR8CS__Aquisition_Value__c, 
                      XLR8CS__Asset_Classification__c, XLR8CS__Include_In_Net_Worth__c, 
                      XLR8CS__Acquired_Opened_Date__c, XLR8CS__Inactive_Date__c, XLR8CS__Description__c, 
                      XLR8CS__Initial_Loan_Amount__c, XLR8CS__Loan_Type__c, XLR8CS__Rate_Structure__c, 
                      XLR8CS__Amortization_Term__c, XLR8CS__Interest_Rate__c, XLR8CS__Payment_Amount__c, 
                      XLR8CS__Payment_Frequency__c, XLR8CS__Maturity_Date__c, XLR8CS__Primary_Owner__r.Name,
                      XLR8CS__Secondary_Owner__r.Name, XLR8CS__Institution__c, XLR8CS__Revolving_Loan__c 
              From XLR8CS__XLR8_Assets_Liabilities__c 
              Where Id =: o2.Id];
    
    
    
        system.assertEquals(asset2.id, o2.ID);
        system.assertEquals(asset2.assetAccountNumber, o2.Name);
        system.assertEquals(asset2.recordType, o2.RecordType.Name);
        system.assertEquals(asset2.entity, o2.XLR8CS__Entity__c);
        system.assertEquals(asset2.entityName, o2.XLR8CS__Entity__r.Name);
        system.assertEquals(asset2.assetCategory, o2.XLR8CS__Category__c);
        system.assertEquals(asset2.custodian, o2.XLR8CS__Custodian__c);
        system.assertEquals(asset2.registration, o2.XLR8CS__Registration__c);
        system.assertEquals(asset2.valueBalance, o2.XLR8CS__Value_Balance__c);
        system.assertEquals(asset2.asofDate, o2.XLR8CS__As_Of_Date__c);
        system.assertEquals(asset2.cashValue, o2.XLR8CS__Cash_Value__c);
        system.assertEquals(asset2.acquisitionValue, o2.XLR8CS__Aquisition_Value__c );
        system.assertEquals(asset2.assetClassification, o2.XLR8CS__Asset_Classification__c);
        system.assertEquals(asset2.includeinNetWorth, o2.XLR8CS__Include_In_Net_Worth__c);
        system.assertEquals(asset2.acquiredOpenedDate, o2.XLR8CS__Acquired_Opened_Date__c);
        system.assertEquals(asset2.inactiveDate, o2.XLR8CS__Inactive_Date__c);
        system.assertEquals(asset2.description, o2.XLR8CS__Description__c);
        system.assertEquals(asset2.initialLoanAmount, o2.XLR8CS__Initial_Loan_Amount__c);
        system.assertEquals(asset2.loanType, o2.XLR8CS__Loan_Type__c);
        system.assertEquals(asset2.rateStructure, o2.XLR8CS__Rate_Structure__c);
        system.assertEquals(asset2.amortizationTerm, o2.XLR8CS__Amortization_Term__c);
        system.assertEquals(asset2.interestRate, o2.XLR8CS__Interest_Rate__c);
        system.assertEquals(asset2.paymentAmount, o2.XLR8CS__Payment_Amount__c);
        system.assertEquals(asset2.paymentFrequency, o2.XLR8CS__Payment_Frequency__c);
        system.assertEquals(asset2.maturityDate, o2.XLR8CS__Maturity_Date__c);
        system.assertEquals(asset2.primaryOwner, o2.XLR8CS__Primary_Owner__r.Name);
        system.assertEquals(asset2.secondaryOwner, o2.XLR8CS__Secondary_Owner__r.Name);
        system.assertEquals(asset2.institution, o2.XLR8CS__Institution__c);
        system.assertEquals(asset2.revolvingLoan, o2.XLR8CS__Revolving_Loan__c);
        
       // Request account with null id
       assetObjects = XLR8API.getAssets(null);
       system.assertNotEquals(assetObjects, null);
       system.assertEquals(assetObjects.returnCode,400);
       system.assertEquals(assetObjects.message,'Invalid account id');   
       
       // Request account with empty id
       assetObjects = XLR8API.getAssets('');
       system.assertNotEquals(assetObjects, null);
       system.assertEquals(assetObjects.returnCode,400);
       system.assertEquals(assetObjects.message,'Invalid account id');
       
       // Request account with non existing id
       assetObjects = XLR8API.getAssets('001F000001340u6');
       system.assertNotEquals(assetObjects, null);
       system.assertEquals(assetObjects.returnCode,404);
       system.assertEquals(assetObjects.message,'Unable to find assets related to given account Id: 001F000001340u6');
       
       // Request records with an invalid account id
       assetObjects = XLR8API.getAssets('foo');
       system.assertNotEquals(assetObjects, null);
       system.assertEquals(assetObjects.returnCode,404);
       system.assertEquals(assetObjects.message,'Account ID null or blank');
    }
    
    static testMethod void getHoldings() {
        
        
        // Create two accounts
        List<Account>accounts = new List<Account>();
        Account a1 = createAccount('Salesforce.com', 'Envelope Name', 'A', 
                                  UserInfo.getUserId(), '1-111-111-1111' , 'Business', '1-111-111-2222', 'Home',
                                  '1-111-111-1113', 'www.salesforce.com', null);
       
        accounts.add(a1);
        Account a2 = createAccount('Ucla', 'Envelope Name', 'A', 
                                  UserInfo.getUserId(), '1-111-111-1111' , 'Business', '1-111-111-2222', 'Home',
                                  '1-111-111-1113', 'www.lala.com', null);
       
        accounts.add(a2);
        insert accounts;
        system.assertNotEquals(a1.Id, null);
        system.assertNotEquals(a2.Id, null);
       
        List<XLR8CS__XLR8_Assets_Liabilities__c> records = new List<XLR8CS__XLR8_Assets_Liabilities__c>();
        XLR8CS__XLR8_Assets_Liabilities__c o1 = createAsset('Asset 1', a1.Id, 
                                                          'IRA', 'Schawb', 'Client', 1000,
                                                          system.today(), 2000, 100, 'Real Estate',
                                                          false, system.today().adddays(-5), null, 'Description', 
                                                          1500, 'Funded', 'Rate', 13,
                                                          5, 100, 'Monthly', system.today().addYears(1), null, null,
                                                          'Bank of America', 'Yes' );
        records.add(o1);
        
        XLR8CS__XLR8_Assets_Liabilities__c o2 = createAsset('Asset 2', a1.Id, 
                                                          'IRA', 'Fidelity', 'Client', 5000,
                                                          system.today().addDays(3), 1000, 140, 'Real Estate',
                                                          true, system.today().adddays(-5), null, 'Description 2', 
                                                          2500, 'Funded', 'Rate', 13,
                                                          58, 400, 'Monthly', system.today().addYears(4),null, null,
                                                          'Charter One Mortgage', 'Yes' );
        records.add(o2);
        
        XLR8CS__XLR8_Assets_Liabilities__c o3 = createAsset('Asset 1', a2.Id, 
                                                          'IRA', 'Schawb', 'Client', 1000,
                                                          system.today(), 2000, 100, 'Real Estate',
                                                          false, system.today().adddays(-5), null, 'Description', 
                                                          1500, 'Funded', 'Rate', 13,
                                                          5, 100, 'Monthly', system.today().addYears(1),null, null,
                                                          'Citigroup', 'Yes' );
        records.add(o3);        
        insert records;
        
        system.assertNotEquals(o1.Id, null);
        system.assertNotEquals(o2.Id, null);
        system.assertNotEquals(o3.Id, null);
        
        // Create holdings related to account 1, 2 and 3
        
        List<XLR8CS__XLR8_Securities__c> securities = new List<XLR8CS__XLR8_Securities__c>();
        XLR8CS__XLR8_Securities__c s1 = createHolding('Cash', o1.Id, 50, 'Security 1', 1000, system.today(), 100);
        securities.add(s1);
        XLR8CS__XLR8_Securities__c s2 = createHolding('Cash', o2.Id, 500, 'Security 1', 10000, system.today(), 200);
        securities.add(s2);
        XLR8CS__XLR8_Securities__c s3 = createHolding('Cash', o3.Id, 5000, 'Security 1', 100000, system.today(), 300);
        securities.add(s3);
        XLR8CS__XLR8_Securities__c s4 = createHolding('Cash', o3.Id, 50000, 'Security 1', 100000, system.today(), 400);
        securities.add(s4);
        
        insert securities;
        system.assertNotEquals(s1.Id, null);
        system.assertNotEquals(s2.Id, null);
        system.assertNotEquals(s3.Id, null);
        system.assertNotEquals(s4.Id, null);
        
        // Get holdings for account 1
        XLR8APITypes.HoldingObjects holdingObjects = XLR8API.getHoldings(a1.Id); 
        system.assertNotEquals(holdingObjects, null);
        system.assertNotEquals(holdingObjects.objects, null);
        system.assertEquals(holdingObjects.objects.size(), 2);
        system.assertEquals(holdingObjects.returnCode,200);
        system.assertEquals(holdingObjects.message,'Success');  
        
        XLR8APITypes.HoldingObject holding1 = null;
        XLR8APITypes.HoldingObject holding2 = null;
        for (XLR8APITypes.HoldingObject s : holdingObjects.objects){
            if (s.id == s1.id){
                holding1 = s;
            }else{
                holding2 = s;
            }
        }

        s1 = [Select ID, Name, XLR8CS__Financial_Account__c, XLR8CS__Quantity_of_Shares__c, 
              			XLR8CS__Security_Description__c, XLR8CS__Total_Value__c, 
              			XLR8CS__As_Of_Date__c, XLR8CS__Cost_Basis__c,XLR8CS__Financial_Account__r.XLR8CS__Entity__c
              From XLR8CS__XLR8_Securities__c 
              Where Id =: s1.Id];
        
    
    
        system.assertEquals(holding1.id, s1.ID);
        system.assertEquals(holding1.symbol, s1.Name);
        system.assertEquals(holding1.financialAccount, s1.XLR8CS__Financial_Account__c);
        system.assertEquals(holding1.entityId, s1.XLR8CS__Financial_Account__r.XLR8CS__Entity__c);
        system.assertEquals(holding1.quantityOfShares, s1.XLR8CS__Quantity_of_Shares__c);
        system.assertEquals(holding1.securityDescription, s1.XLR8CS__Security_Description__c);
        system.assertEquals(holding1.totalValue, s1.XLR8CS__Total_Value__c);
        system.assertEquals(holding1.asOfDate, s1.XLR8CS__As_Of_Date__c);
        system.assertEquals(holding1.costBasis, s1.XLR8CS__Cost_Basis__c);
        system.assertEquals(holding1.entityID, s1.XLR8CS__Financial_Account__r.XLR8CS__Entity__c);
        
        s2 = [Select ID, Name, XLR8CS__Financial_Account__c, XLR8CS__Quantity_of_Shares__c, 
              		XLR8CS__Security_Description__c, XLR8CS__Total_Value__c, XLR8CS__As_Of_Date__c,
              		XLR8CS__Cost_Basis__c,XLR8CS__Financial_Account__r.XLR8CS__Entity__c
              From XLR8CS__XLR8_Securities__c 
              Where Id =: s2.Id];
        
    
    
        system.assertEquals(holding2.id, s2.ID);
        system.assertEquals(holding2.symbol, s2.Name);
        system.assertEquals(holding2.financialAccount, s2.XLR8CS__Financial_Account__c);
        system.assertEquals(holding2.quantityOfShares, s2.XLR8CS__Quantity_of_Shares__c);
        system.assertEquals(holding2.securityDescription, s2.XLR8CS__Security_Description__c);
        system.assertEquals(holding2.totalValue, s2.XLR8CS__Total_Value__c);
        system.assertEquals(holding2.asOfDate, s2.XLR8CS__As_Of_Date__c);
        system.assertEquals(holding2.costBasis, s2.XLR8CS__Cost_Basis__c);
        system.assertEquals(holding2.entityID, s2.XLR8CS__Financial_Account__r.XLR8CS__Entity__c);
        
       // Request account with null id
       holdingObjects = XLR8API.getHoldings(null);
       system.assertNotEquals(holdingObjects, null);
       system.assertEquals(holdingObjects.returnCode,400);
       system.assertEquals(holdingObjects.message,'Invalid account id');   
       
       // Request account with empty id
       holdingObjects = XLR8API.getHoldings('');
       system.assertNotEquals(holdingObjects, null);
       system.assertEquals(holdingObjects.returnCode,400);
       system.assertEquals(holdingObjects.message,'Invalid account id');
       
       // Request account with non existing id
       holdingObjects = XLR8API.getHoldings('001F000001340u6');
       system.assertNotEquals(holdingObjects, null);
       system.assertEquals(holdingObjects.returnCode,404);
       system.assertEquals(holdingObjects.message,'Unable to find holdings related to given account Id: 001F000001340u6');
       
       // Request records with an invalid account id
       holdingObjects = XLR8API.getHoldings('foo');
       system.assertNotEquals(holdingObjects, null);
       system.assertEquals(holdingObjects.returnCode,404);
       system.assertEquals(holdingObjects.message,'Account ID null or blank');
    }
    
    static testMethod void getInsurances() {
        
        
        // Create two accounts
        List<Account>accounts = new List<Account>();
        Account a1 = createAccount('Salesforce.com', 'Envelope Name', 'A', 
                                  UserInfo.getUserId(), '1-111-111-1111' , 'Business', '1-111-111-2222', 'Home',
                                  '1-111-111-1113', 'www.salesforce.com', null);
       
        accounts.add(a1);
        Account a2 = createAccount('Ucla', 'Envelope Name', 'A', 
                                  UserInfo.getUserId(), '1-111-111-1111' , 'Business', '1-111-111-2222', 'Home',
                                  '1-111-111-1113', 'www.lala.com', null);
       
        accounts.add(a2);
        insert accounts;
        system.assertNotEquals(a1.Id, null);
        system.assertNotEquals(a2.Id, null);
       
        //Insert contacts 
        List<Contact> contacts = new List<Contact>();
        Contact c1 = createContact(system.today().addYears(-20),'43800170', 'Female', 'Single', 'Global', 'Employed',
                                   system.today().addYears(2), 'Software Developer', false, true, 'test@test.com', 
                                   'test2@test.com', '', 'Notes', ' 1-123-123-2233', '1-123-222-2222','1-345-555-6677',
                                    '1-345-444-5353', a1.Id, 'Contact 1', 'Test', 'Mr', 'Sweet','Mr Sweet', 'Consultant', 
                                    'Client', 'Salutation', 'Middle Name' );
        c1.AccountId = a1.Id;
        contacts.add(c1);
       
        Contact c2 = createContact(system.today().addYears(-20),'55800170', 'Female', 'Single', 'Global', 'Employed',
                                    system.today().addYears(2), 'Software Developer', false, true, 'atest@test.com', 
                                    'atest2@test.com', '', 'Notes', ' 1-123-123-2233', '1-123-222-2222','1-345-555-6677', 
                                    '1-345-444-5353', a1.Id, 'Contact 2', 'Test', 'Mr', 'Sweet','Mr Sweet', 'Consultant', 
                                    'Client', 'Salutation', 'Middle Name');
        c2.AccountId = a1.Id;
        contacts.add(c2);
       
        Contact c3 = createContact(system.today().addYears(-20),'55800170', 'Female', 'Single', 'Global', 'Employed',
                                    system.today().addYears(2), 'Software Developer', false, true, 'atest@test.com', 
                                    'atest2@test.com', '', 'Notes', ' 1-123-123-2233', '1-123-222-2222','1-345-555-6677', 
                                    '1-345-444-5353', a2.Id, 'Contact 3', 'Test', 'Mr', 'Sweet','Mr Sweet', 'Consultant', 
                                    'Client', 'Salutation', 'Middle Name' );
        c3.AccountId = a2.Id;
        contacts.add(c3);
       
        insert contacts;
        system.assertNotEquals(c1.Id, null);
        system.assertNotEquals(c2.Id, null);
        system.assertNotEquals(c3.Id, null);
        
        // Insert three contacts. The first two will be related to account 1. 
        List<XLR8CS__XLR8_Insurance__c> insurances = new List<XLR8CS__XLR8_Insurance__c>();
        XLR8CS__XLR8_Insurance__c i1 = createInsurance(a1.Id, 'Insurance 1', c1.Id,
                                                    c1.Id, 'Proposed', 'Additional Life', 'Mapfre', 
                                                    'Descroiption', 5, 10, 1, 
                                                    1000000, 2000000, 1000, 19, 100,
                                                    'Quarterly', system.today().addDays(-15), system.today().addYears(1), 
                                                    system.today(),'Client', 'Client');
        
        insurances.add(i1);
       
        XLR8CS__XLR8_Insurance__c i2 = createInsurance(a1.Id, 'Insurance 1', c1.Id,
                                                    c1.Id, 'Proposed', 'Additional Life', 'Mapfre', 
                                                    'Descroiption', 5, 10, 1, 
                                                    1000000, 2000000, 1000, 19, 100,
                                                    'Quarterly', system.today().addDays(-15), system.today().addYears(1), 
                                                    system.today(), 'Co-Client', 'Co-Client');
        
        insurances.add(i2);
       
        XLR8CS__XLR8_Insurance__c i3 = createInsurance(a1.Id, 'Insurance 1', c1.Id,
                                                    c2.Id, 'Proposed', 'Additional Life', 'Mapfre', 
                                                    'Descroiption', 5, 10, 1, 
                                                    1000000, 2000000, 1000, 19, 100,
                                                    'Quarterly', system.today().addDays(-15), system.today().addYears(1), 
                                                    system.today(), 'Client', 'Client');
        
        insurances.add(i3);       
        insert insurances;
        
        
        system.assertNotEquals(i1.Id, null);
        system.assertNotEquals(i2.Id, null);
        system.assertNotEquals(i3.Id, null);
        
        // Get contacts for account 1
        XLR8APITypes.InsuranceObjects insuranceObjects = XLR8API.getInsurances(a1.Id); 
        system.assertNotEquals(insuranceObjects, null);
        system.assertNotEquals(insuranceObjects.objects, null);
        system.assertEquals(insuranceObjects.objects.size(), 3);
        system.assertEquals(insuranceObjects.returnCode,200);
        system.assertEquals(insuranceObjects.message,'Success');  
        
        XLR8APITypes.InsuranceObject insurance1 = null;
        XLR8APITypes.InsuranceObject insurance2 = null;
        for (XLR8APITypes.InsuranceObject i : insuranceObjects.objects){
            if (i.Id == i1.Id){
                insurance1 = i;
            }
            if(i.Id == i2.Id){
                insurance2 = i;
            }
        }

        i1 = [Select ID, RecordType.Name, XLR8CS__Entity__r.Name, Name, XLR8CS__Policy_Holder__r.Name, 
                         XLR8CS__Insured_Individual__r.Name, XLR8CS__Status__c, XLR8CS__Policy_Type__c, 
                         XLR8CS__Insurance_Company__c, XLR8CS__Description__c, XLR8CS__Monthly_Benefit__c, 
                         XLR8CS__Surrender_Value__c, XLR8CS__Daily_Benefit__c, XLR8CS__Death_Benefit__c ,
                         XLR8CS__Maximum_Benefit__c, XLR8CS__Deductible__c, XLR8CS__Face_Value__c ,
                         XLR8CS__Annual_Premium__c, XLR8CS__Premium_Frequency__c, XLR8CS__Policy_Issued_Date__c, 
                         XLR8CS__Policy_Expiration_Date__c, XLR8CS__Policy_Effective_Date__c, XLR8CS__Registered_Policy_Owner__c,
                         XLR8CS__Registered_Insured_Individual__c
                      From XLR8CS__XLR8_Insurance__c 
                      Where Id  =: i1.Id];
        system.assertEquals(insurance1.id, i1.ID);
        system.assertEquals(insurance1.recordType, i1.RecordType.Name);
        system.assertEquals(insurance1.entity, i1.XLR8CS__Entity__r.Name );
        system.assertEquals(insurance1.policyNumberOrName, i1.Name);
        system.assertEquals(insurance1.policyHolder, i1.XLR8CS__Policy_Holder__r.Name);
        system.assertEquals(insurance1.insuredIndividual, i1.XLR8CS__Insured_Individual__r.Name);
        system.assertEquals(insurance1.status, i1.XLR8CS__Status__c);
        system.assertEquals(insurance1.policyType, i1.XLR8CS__Policy_Type__c);
        system.assertEquals(insurance1.insuranceCompany, i1.XLR8CS__Insurance_Company__c);
        system.assertEquals(insurance1.description, i1.XLR8CS__Description__c);
        system.assertEquals(insurance1.monthlyBenefit, i1.XLR8CS__Monthly_Benefit__c);
        system.assertEquals(insurance1.surrenderValue, i1.XLR8CS__Surrender_Value__c);
        system.assertEquals(insurance1.dailyBenefit, i1.XLR8CS__Daily_Benefit__c);
        system.assertEquals(insurance1.deathBenefit, i1.XLR8CS__Death_Benefit__c);
        system.assertEquals(insurance1.maximumBenefit, i1.XLR8CS__Maximum_Benefit__c);
        system.assertEquals(insurance1.deductible, i1.XLR8CS__Deductible__c);
        system.assertEquals(insurance1.faceValue, i1.XLR8CS__Face_Value__c);
        system.assertEquals(insurance1.annualPremium, i1.XLR8CS__Annual_Premium__c);
        system.assertEquals(insurance1.premiumFrequency, i1.XLR8CS__Premium_Frequency__c);
        system.assertEquals(insurance1.policyIssuedDate, i1.XLR8CS__Policy_Issued_Date__c);
        system.assertEquals(insurance1.policyExpirationDate, i1.XLR8CS__Policy_Expiration_Date__c);
        system.assertEquals(insurance1.policyEffectiveDate, i1.XLR8CS__Policy_Effective_Date__c);
        system.assertEquals(insurance1.registeredPolicyOwner, i1.XLR8CS__Registered_Policy_Owner__c);
        system.assertEquals(insurance1.registeredInsuredIndividual, i1.XLR8CS__Registered_Insured_Individual__c);

        i2 = [Select ID, RecordType.Name, XLR8CS__Entity__r.Name, Name, XLR8CS__Policy_Holder__r.Name, 
                     XLR8CS__Insured_Individual__r.Name, XLR8CS__Status__c, XLR8CS__Policy_Type__c, 
                     XLR8CS__Insurance_Company__c, XLR8CS__Description__c, XLR8CS__Monthly_Benefit__c, 
                     XLR8CS__Surrender_Value__c, XLR8CS__Daily_Benefit__c, XLR8CS__Death_Benefit__c ,
                     XLR8CS__Maximum_Benefit__c, XLR8CS__Deductible__c, XLR8CS__Face_Value__c ,
                     XLR8CS__Annual_Premium__c, XLR8CS__Premium_Frequency__c, XLR8CS__Policy_Issued_Date__c, 
                     XLR8CS__Policy_Expiration_Date__c, XLR8CS__Policy_Effective_Date__c, XLR8CS__Registered_Policy_Owner__c,
                     XLR8CS__Registered_Insured_Individual__c
                  From XLR8CS__XLR8_Insurance__c 
                              Where Id  =: i2.Id];
        system.assertEquals(insurance2.id, i2.ID);
        system.assertEquals(insurance2.recordType, i2.RecordType.Name);
        system.assertEquals(insurance2.entity, i2.XLR8CS__Entity__r.Name );
        system.assertEquals(insurance2.policyNumberOrName, i2.Name);
        system.assertEquals(insurance2.policyHolder, i2.XLR8CS__Policy_Holder__r.Name);
        system.assertEquals(insurance2.insuredIndividual, i2.XLR8CS__Insured_Individual__r.Name);
        system.assertEquals(insurance2.status, i2.XLR8CS__Status__c);
        system.assertEquals(insurance2.policyType, i2.XLR8CS__Policy_Type__c);
        system.assertEquals(insurance2.insuranceCompany, i2.XLR8CS__Insurance_Company__c);
        system.assertEquals(insurance2.description, i2.XLR8CS__Description__c);
        system.assertEquals(insurance2.monthlyBenefit, i2.XLR8CS__Monthly_Benefit__c);
        system.assertEquals(insurance2.surrenderValue, i2.XLR8CS__Surrender_Value__c);
        system.assertEquals(insurance2.dailyBenefit, i2.XLR8CS__Daily_Benefit__c);
        system.assertEquals(insurance2.deathBenefit, i2.XLR8CS__Death_Benefit__c);
        system.assertEquals(insurance2.maximumBenefit, i2.XLR8CS__Maximum_Benefit__c);
        system.assertEquals(insurance2.deductible, i2.XLR8CS__Deductible__c);
        system.assertEquals(insurance2.faceValue, i2.XLR8CS__Face_Value__c);
        system.assertEquals(insurance2.annualPremium, i2.XLR8CS__Annual_Premium__c);
        system.assertEquals(insurance2.premiumFrequency, i2.XLR8CS__Premium_Frequency__c);
        system.assertEquals(insurance2.policyIssuedDate, i2.XLR8CS__Policy_Issued_Date__c);
        system.assertEquals(insurance2.policyExpirationDate, i2.XLR8CS__Policy_Expiration_Date__c);
        system.assertEquals(insurance2.policyEffectiveDate, i2.XLR8CS__Policy_Effective_Date__c);
        system.assertEquals(insurance2.registeredPolicyOwner, i2.XLR8CS__Registered_Policy_Owner__c);
        system.assertEquals(insurance2.registeredInsuredIndividual, i2.XLR8CS__Registered_Insured_Individual__c);
      
       // Request account with null id
       insuranceObjects = XLR8API.getInsurances(null);
       system.assertNotEquals(insuranceObjects, null);
       system.assertEquals(insuranceObjects.returnCode,400);
       system.assertEquals(insuranceObjects.message,'Invalid account id');   
       
       // Request account with empty id
       insuranceObjects = XLR8API.getInsurances('');
       system.assertNotEquals(insuranceObjects, null);
       system.assertEquals(insuranceObjects.returnCode,400);
       system.assertEquals(insuranceObjects.message,'Invalid account id');
       
       // Request account with non existing id
       insuranceObjects = XLR8API.getInsurances('001F000001340u6');
       system.assertNotEquals(insuranceObjects, null);
       system.assertEquals(insuranceObjects.returnCode,404);
       system.assertEquals(insuranceObjects.message,'Unable to find insurances related to given account Id: 001F000001340u6');
       
       // Request records with an invalid account id
       insuranceObjects = XLR8API.getInsurances('foo');
       system.assertNotEquals(insuranceObjects, null);
       system.assertEquals(insuranceObjects.returnCode,404);
       system.assertEquals(insuranceObjects.message,'Account ID null or blank');
    }
    
    static testMethod void getIncomeAndExpenses() {
                
        // Create two accounts
        List<Account>accounts = new List<Account>();
        Account a1 = createAccount('Salesforce.com', 'Envelope Name', 'A', 
                                  UserInfo.getUserId(), '1-111-111-1111' , 'Business', '1-111-111-2222', 'Home',
                                  '1-111-111-1113', 'www.salesforce.com', null);
       
        accounts.add(a1);
        Account a2 = createAccount('Ucla', 'Envelope Name', 'A', 
                                  UserInfo.getUserId(), '1-111-111-1111' , 'Business', '1-111-111-2222', 'Home',
                                  '1-111-111-1113', 'www.lala.com', null);
       
        accounts.add(a2);
        insert accounts;
        system.assertNotEquals(a1.Id, null);
        system.assertNotEquals(a2.Id, null);
       
        //Insert contacts 
        List<Contact> contacts = new List<Contact>();
        Contact c1 = createContact(system.today().addYears(-20),'43800170', 'Female', 'Single', 'Global', 'Employed',
                                   system.today().addYears(2), 'Software Developer', false, true, 'test@test.com', 
                                   'test2@test.com', '', 'Notes', ' 1-123-123-2233', '1-123-222-2222','1-345-555-6677',
                                    '1-345-444-5353', a1.Id, 'Contact 1', 'Test', 'Mr', 'Sweet','Mr Sweet', 'Consultant', 
                                    'Client', 'Salutation', 'Middle Name');
        contacts.add(c1);
       
        Contact c2 = createContact(system.today().addYears(-20),'55800170', 'Female', 'Single', 'Global', 'Employed',
                                    system.today().addYears(2), 'Software Developer', false, true, 'atest@test.com', 
                                    'atest2@test.com', '', 'Notes', ' 1-123-123-2233', '1-123-222-2222','1-345-555-6677', 
                                    '1-345-444-5353', a1.Id, 'Contact 2', 'Test', 'Mr', 'Sweet','Mr Sweet', 'Consultant', 
                                    'Client', 'Salutation', 'Middle Name');
        contacts.add(c2);
       
        Contact c3 = createContact(system.today().addYears(-20),'55800170', 'Female', 'Single', 'Global', 'Employed',
                                    system.today().addYears(2), 'Software Developer', false, true, 'atest@test.com', 
                                    'atest2@test.com', '', 'Notes', ' 1-123-123-2233', '1-123-222-2222','1-345-555-6677', 
                                    '1-345-444-5353', a2.Id, 'Contact 3', 'Test','Mr', 'Sweet','Mr Sweet', 'Consultant', 
                                    'Client', 'Salutation', 'Middle Name' );
        contacts.add(c3);
       
        insert contacts;
        system.assertNotEquals(c1.Id, null);
        system.assertNotEquals(c2.Id, null);
        system.assertNotEquals(c3.Id, null);
        
        // Insert three contacts. The first two will be related to account 1. 
        List<XLR8CS__Income_and_Expense__c> incomes = new List<XLR8CS__Income_and_Expense__c>();
        XLR8CS__Income_and_Expense__c i1 = createIncome(a1.Id, 'Childs Education', 'Client',
                                                     c1.Id, c2.Id, 'Description', 1000,
                                                      system.today(), 'Monthly', 'Notes', '5', 
                                                      5, 7, '2');
        incomes.add(i1);
       
        XLR8CS__Income_and_Expense__c i2 = createIncome(a1.Id, 'Living Expenses Pre-Retirement', 'Partner',
                                                     c2.Id, c3.Id, 'Description', 4600,
                                                      system.today().adddays(2), 'Annually', 'Notes', '5', 
                                                      10, 7, '2');
        incomes.add(i2);
       
        XLR8CS__Income_and_Expense__c i3 = createIncome(a2.Id, 'Living Expenses Pre-Retirement', 'Partner',
                                                     c2.Id, c3.Id, 'Description', 4600,
                                                      system.today().adddays(2), 'Annually', 'Notes', '5', 
                                                      33, 7, '2');
        incomes.add(i3);
       
        insert incomes;
        
        system.assertNotEquals(i1.Id, null);
        system.assertNotEquals(i2.Id, null);
        system.assertNotEquals(i3.Id, null);
        
        // Get contacts for account 1
        XLR8APITypes.IncomeAndExpenseObjects incomeObjects = XLR8API.getIncomeAndExpenses(a1.Id); 
        system.assertNotEquals(incomeObjects, null);
        system.assertNotEquals(incomeObjects.objects, null);
        system.assertEquals(incomeObjects.objects.size(), 2);
        system.assertEquals(incomeObjects.returnCode,200);
        system.assertEquals(incomeObjects.message,'Success'); 
        
        XLR8APITypes.IncomeAndExpenseObject income1 = null;
        XLR8APITypes.IncomeAndExpenseObject income2 = null;
        for (XLR8APITypes.IncomeAndExpenseObject i : incomeObjects.objects){
            if (i.Id == i1.Id){
                income1 = i;
            }else{
                income2 = i;
            }
        }

        i1 = [Select ID, RecordType.Name, XLR8CS__Entity__r.Name, XLR8CS__Type__c, XLR8CS__Owner_Registration__c,
						 XLR8CS__Primary_Owner__r.Name, XLR8CS__Secondary_Owner__r.Name, XLR8CS__Description__c, 
						 XLR8CS__Amount__c, XLR8CS__As_Of_Date__c,XLR8CS__Frequency__c, XLR8CS__Notes__c,
						 XLR8CS__Recurring_How_Often__c, XLR8CS__Pct_Annual_Increase__c, XLR8CS__Years_to_Continue__c, 
						 XLR8CS__Year_Expected_to_be_Incurred__c
					  From XLR8CS__Income_and_Expense__c 
					  Where Id  =: i1.Id];
					  
        system.assertEquals(income1.id, i1.ID);
        system.assertEquals(income1.recordType, i1.RecordType.Name);
        system.assertEquals(income1.entity, i1.XLR8CS__Entity__r.Name );
        system.assertEquals(income1.incomeType, i1.XLR8CS__Type__c);
        system.assertEquals(income1.ownerRegistration, i1.XLR8CS__Owner_Registration__c);
        system.assertEquals(income1.primaryOwner, i1.XLR8CS__Primary_Owner__r.Name);
        system.assertEquals(income1.secondaryOwner, i1.XLR8CS__Secondary_Owner__r.Name);
        system.assertEquals(income1.description, i1.XLR8CS__Description__c);
        system.assertEquals(income1.amount, i1.XLR8CS__Amount__c);
        system.assertEquals(income1.asOfDate, i1.XLR8CS__As_Of_Date__c);
        system.assertEquals(income1.frequency, i1.XLR8CS__Frequency__c);
        system.assertEquals(income1.notes, i1.XLR8CS__Notes__c);
        system.assertEquals(income1.howOftenRecurring, i1.XLR8CS__Recurring_How_Often__c);
        system.assertEquals(income1.AnnualIncrease, i1.XLR8CS__Pct_Annual_Increase__c);
        system.assertEquals(income1.yearsToContinue, i1.XLR8CS__Years_to_Continue__c);
        system.assertEquals(income1.yearsExpectedToBeIncurred, i1.XLR8CS__Year_Expected_to_be_Incurred__c);

        i2 = [Select ID, RecordType.Name, XLR8CS__Entity__r.Name, XLR8CS__Type__c, XLR8CS__Owner_Registration__c,
						 XLR8CS__Primary_Owner__r.Name, XLR8CS__Secondary_Owner__r.Name, XLR8CS__Description__c, 
						 XLR8CS__Amount__c, XLR8CS__As_Of_Date__c,XLR8CS__Frequency__c, XLR8CS__Notes__c,
						 XLR8CS__Recurring_How_Often__c, XLR8CS__Pct_Annual_Increase__c, XLR8CS__Years_to_Continue__c, 
						 XLR8CS__Year_Expected_to_be_Incurred__c
					  From XLR8CS__Income_and_Expense__c 
					  Where Id  =: i2.Id];
					  
        system.assertEquals(income2.id, i2.ID);
        system.assertEquals(income2.recordType, i2.RecordType.Name);
        system.assertEquals(income2.entity, i2.XLR8CS__Entity__r.Name );
        system.assertEquals(income2.incomeType, i2.XLR8CS__Type__c);
        system.assertEquals(income2.ownerRegistration, i2.XLR8CS__Owner_Registration__c);
        system.assertEquals(income2.primaryOwner, i2.XLR8CS__Primary_Owner__r.Name);
        system.assertEquals(income2.secondaryOwner, i2.XLR8CS__Secondary_Owner__r.Name);
        system.assertEquals(income2.description, i2.XLR8CS__Description__c);
        system.assertEquals(income2.amount, i2.XLR8CS__Amount__c);
        system.assertEquals(income2.asOfDate, i2.XLR8CS__As_Of_Date__c);
        system.assertEquals(income2.frequency, i2.XLR8CS__Frequency__c);
        system.assertEquals(income2.notes, i2.XLR8CS__Notes__c);
        system.assertEquals(income2.howOftenRecurring, i2.XLR8CS__Recurring_How_Often__c);
        system.assertEquals(income2.AnnualIncrease, i2.XLR8CS__Pct_Annual_Increase__c);
        system.assertEquals(income2.yearsToContinue, i2.XLR8CS__Years_to_Continue__c);
        system.assertEquals(income2.yearsExpectedToBeIncurred, i2.XLR8CS__Year_Expected_to_be_Incurred__c);
      
       // Request account with null id
		incomeObjects = XLR8API.getIncomeAndExpenses(null); 
       system.assertNotEquals(incomeObjects, null);
       system.assertEquals(incomeObjects.returnCode,400);
       system.assertEquals(incomeObjects.message,'Invalid account id');   
       
       // Request account with empty id
       incomeObjects = XLR8API.getIncomeAndExpenses('');
       system.assertNotEquals(incomeObjects, null);
       system.assertEquals(incomeObjects.returnCode,400);
       system.assertEquals(incomeObjects.message,'Invalid account id');
       
       // Request account with non existing id
       incomeObjects = XLR8API.getIncomeAndExpenses('001F000001340u6');
       system.assertNotEquals(incomeObjects, null);
       system.assertEquals(incomeObjects.returnCode,404);
       system.assertEquals(incomeObjects.message,'Unable to find Income and Expenses related to given account Id: 001F000001340u6');
       
       // Request records with an invalid account id
       incomeObjects = XLR8API.getIncomeAndExpenses('foo');
       system.assertNotEquals(incomeObjects, null);
       system.assertEquals(incomeObjects.returnCode,404);
       system.assertEquals(incomeObjects.message,'Account ID null or blank');
    }
    
    static testMethod void getEstatePlannings() {
        
        
        // Create two accounts
        List<Account>accounts = new List<Account>();
        Account a1 = createAccount('Salesforce.com', 'Envelope Name', 'A', 
                                  UserInfo.getUserId(), '1-111-111-1111' , 'Business', '1-111-111-2222', 'Home',
                                  '1-111-111-1113', 'www.salesforce.com', null);
       
        accounts.add(a1);
        Account a2 = createAccount('Ucla', 'Envelope Name', 'A', 
                                  UserInfo.getUserId(), '1-111-111-1111' , 'Business', '1-111-111-2222', 'Home',
                                  '1-111-111-1113', 'www.lala.com', null);
       
        accounts.add(a2);
        insert accounts;
        system.assertNotEquals(a1.Id, null);
        system.assertNotEquals(a2.Id, null);
       
        //Insert contacts 
        List<Contact> contacts = new List<Contact>();
        Contact c1 = createContact(system.today().addYears(-20),'43800170', 'Female', 'Single', 'Global', 'Employed',
                                   system.today().addYears(2), 'Software Developer', false, true, 'test@test.com', 
                                   'test2@test.com', '', 'Notes', ' 1-123-123-2233', '1-123-222-2222','1-345-555-6677',
                                    '1-345-444-5353', a1.Id, 'Contact 1', 'Test','Mr', 'Sweet','Mr Sweet', 'Consultant', 
                                    'Client', 'Salutation', 'Middle Name');
        contacts.add(c1);
       
        Contact c2 = createContact(system.today().addYears(-20),'55800170', 'Female', 'Single', 'Global', 'Employed',
                                    system.today().addYears(2), 'Software Developer', false, true, 'atest@test.com', 
                                    'atest2@test.com', '', 'Notes', ' 1-123-123-2233', '1-123-222-2222','1-345-555-6677', 
                                    '1-345-444-5353', a1.Id, 'Contact 2', 'Test','Mr', 'Sweet','Mr Sweet', 'Consultant', 
                                    'Client', 'Salutation', 'Middle Name');
        contacts.add(c2);
       
        Contact c3 = createContact(system.today().addYears(-20),'55800170', 'Female', 'Single', 'Global', 'Employed',
                                    system.today().addYears(2), 'Software Developer', false, true, 'atest@test.com', 
                                    'atest2@test.com', '', 'Notes', ' 1-123-123-2233', '1-123-222-2222','1-345-555-6677', 
                                    '1-345-444-5353', a2.Id, 'Contact 3', 'Test','Mr', 'Sweet','Mr Sweet', 'Consultant', 
                                    'Client', 'Salutation', 'Middle Name');
        contacts.add(c3);
       
        insert contacts;
        system.assertNotEquals(c1.Id, null);
        system.assertNotEquals(c2.Id, null); 
        system.assertNotEquals(c3.Id, null);
        
        // Insert three contacts. The first two will be related to account 1. 
        List<XLR8CS__XLR8_Estate_Planning_Gifting__c> estatePlannings = new List<XLR8CS__XLR8_Estate_Planning_Gifting__c>();
        XLR8CS__XLR8_Estate_Planning_Gifting__c e1 = createPlanAndGifting(a1.Id, 'Art',
                                                    c1.Id, 'Description', 'In Effect', system.today(), true,
                                                    'Recipient', 100, system.today().addDays(1), System.today().addDays(5), 'Grantor Retained Unitrust');
        estatePlannings.add(e1);
       
        XLR8CS__XLR8_Estate_Planning_Gifting__c e2 = createPlanAndGifting(a1.Id, 'Art',
                                                    c2.Id, 'Description 2', 'Proposed', system.today().addDays(-4), true,
                                                    'Recipient', 100, system.today().addDays(4), System.today().addDays(10), 'Grantor Retained Unitrust');
        estatePlannings.add(e2);
       
        XLR8CS__XLR8_Estate_Planning_Gifting__c e3 = createPlanAndGifting(a2.Id, 'Art',
                                                    c1.Id, 'Description', 'In Effect', system.today(), true,
                                                    'Recipient', 100, system.today().addDays(1), System.today().addDays(5), 'Grantor Retained Unitrust');
        estatePlannings.add(e3);
       
        insert estatePlannings;
        
        system.assertNotEquals(e1.Id, null);
        system.assertNotEquals(e2.Id, null);
        system.assertNotEquals(e3.Id, null);
        
        // Get contacts for account 1
        XLR8APITypes.EstateAndPlansGiftingObjects estateObjects = XLR8API.getEstatePlannings(a1.Id); 
        system.assertNotEquals(estateObjects, null);
        system.assertNotEquals(estateObjects.objects, null);
        system.assertEquals(estateObjects.objects.size(), 2);
        system.assertEquals(estateObjects.returnCode,200);
        system.assertEquals(estateObjects.message,'Success'); 
        
        XLR8APITypes.EstateAndPlansGiftingObject estate1 = null;
        XLR8APITypes.EstateAndPlansGiftingObject estate2 = null;
        for (XLR8APITypes.EstateAndPlansGiftingObject i : estateObjects.objects){
            if (i.Id == e1.Id){
                estate1 = i;
            }else{
                estate2 = i;
            }
        }

        e1 = [Select ID, RecordType.Name, Name, XLR8CS__Entity__r.Name, XLR8CS__Contact__r.Name,
									  XLR8CS__Description__c, XLR8CS__Status__c, XLR8CS__Date_Given__c,
									  XLR8CS__Recurring__c, XLR8CS__Recipient__c, XLR8CS__Value__c, XLR8CS__Value_as_of__c,
									  XLR8CS__Date_Executed__c, XLR8CS__Document_Type__c, XLR8CS__Instrument_Gift_Type__c
			  From XLR8CS__XLR8_Estate_Planning_Gifting__c 
			  Where Id  =: e1.Id];
					  
        system.assertEquals(estate1.id, e1.ID);
		system.assertEquals(estate1.recordType, e1.RecordType.Name);
		system.assertEquals(estate1.planGiftID, e1.Name);
		system.assertEquals(estate1.entity, e1.XLR8CS__Entity__r.Name);
		system.assertEquals(estate1.contact, e1.XLR8CS__Contact__r.Name);
		system.assertEquals(estate1.description, e1.XLR8CS__Description__c);
		system.assertEquals(estate1.status, e1.XLR8CS__Status__c);
		system.assertEquals(estate1.dateGiven, e1.XLR8CS__Date_Given__c);
		system.assertEquals(estate1.recurring, e1.XLR8CS__Recurring__c);
		system.assertEquals(estate1.recipient, e1.XLR8CS__Recipient__c);
		system.assertEquals(estate1.value, e1.XLR8CS__Value__c);
		system.assertEquals(estate1.valueAsOf, e1.XLR8CS__Value_as_of__c);
		system.assertEquals(estate1.dateExecuted, e1.XLR8CS__Date_Executed__c);
		system.assertEquals(estate1.documentType, e1.XLR8CS__Document_Type__c);
		system.assertEquals(estate1.instrumentGiftType, e1.XLR8CS__Instrument_Gift_Type__c);

         e2 = [Select ID, RecordType.Name, Name, XLR8CS__Entity__r.Name, XLR8CS__Contact__r.Name,
									  XLR8CS__Description__c, XLR8CS__Status__c, XLR8CS__Date_Given__c,
									  XLR8CS__Recurring__c, XLR8CS__Recipient__c, XLR8CS__Value__c, XLR8CS__Value_as_of__c,
									  XLR8CS__Date_Executed__c, XLR8CS__Document_Type__c, XLR8CS__Instrument_Gift_Type__c
			  From XLR8CS__XLR8_Estate_Planning_Gifting__c 
			  Where Id  =: e2.Id];
					  
        system.assertEquals(estate2.id, e2.ID);
		system.assertEquals(estate2.recordType, e2.RecordType.Name);
		system.assertEquals(estate2.planGiftID, e2.Name);
		system.assertEquals(estate2.entity, e2.XLR8CS__Entity__r.Name);
		system.assertEquals(estate2.contact, e2.XLR8CS__Contact__r.Name);
		system.assertEquals(estate2.description, e2.XLR8CS__Description__c);
		system.assertEquals(estate2.status, e2.XLR8CS__Status__c);
		system.assertEquals(estate2.dateGiven, e2.XLR8CS__Date_Given__c);
		system.assertEquals(estate2.recurring, e2.XLR8CS__Recurring__c);
		system.assertEquals(estate2.recipient, e2.XLR8CS__Recipient__c);
		system.assertEquals(estate2.value, e2.XLR8CS__Value__c);
		system.assertEquals(estate2.valueAsOf, e2.XLR8CS__Value_as_of__c);
		system.assertEquals(estate2.dateExecuted, e2.XLR8CS__Date_Executed__c);
		system.assertEquals(estate2.documentType, e2.XLR8CS__Document_Type__c);
		system.assertEquals(estate2.instrumentGiftType, e2.XLR8CS__Instrument_Gift_Type__c);
      
       // Request account with null id
		estateObjects = XLR8API.getEstatePlannings(null); 
       system.assertNotEquals(estateObjects, null);
       system.assertEquals(estateObjects.returnCode,400);
       system.assertEquals(estateObjects.message,'Invalid account id');   
       
       // Request account with empty id
       estateObjects = XLR8API.getEstatePlannings('');
       system.assertNotEquals(estateObjects, null);
       system.assertEquals(estateObjects.returnCode,400);
       system.assertEquals(estateObjects.message,'Invalid account id');
       
       // Request account with non existing id
       estateObjects = XLR8API.getEstatePlannings('001F000001340u6');
       system.assertNotEquals(estateObjects, null);
       system.assertEquals(estateObjects.returnCode,404);
       system.assertEquals(estateObjects.message,'Unable to find Estate Plans & Giftings related to given account Id: 001F000001340u6');
       
       // Request records with an invalid account id
       estateObjects = XLR8API.getEstatePlannings('foo');
       system.assertNotEquals(estateObjects, null);
       system.assertEquals(estateObjects.returnCode,404);
       system.assertEquals(estateObjects.message,'Account ID null or blank');
    }
}