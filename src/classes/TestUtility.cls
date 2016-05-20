public with sharing class TestUtility {
	
	public static Process_Template__c createProcessTemplate(String name, String templateType, String templateCategory, String description, Boolean autoCreateTasks){
		Process_Template__c result = new Process_Template__c();
		result.Name = name;
		result.Type__c = templateType;
		result.Category__c = templateCategory;
		result.Description__c = description;
		result.Auto_Create_Tasks_Default__c = autoCreateTasks;
		return result;
	}
	
	public static Process_Template__c createProcessTemplate(String name, String templateType){
		Process_Template__c result = new Process_Template__c();
		result.Name = name;
		result.Type__c = templateType;
		return result;
	}
	
	public static Process_Template_Step__c createProcessTemplateStep(String name, String details, Integer duration, Id templateId, Id userId, String caseRole){
		Process_Template_Step__c result = new Process_Template_Step__c();
		result.Name = name;
		result.Details__c = details;
		result.Duration_In_Days__c = duration;
		result.Process_Template__c = templateId;
		result.Assign_to_User__c = userId;
		result.Assign_To_Case_Role__c = caseRole;
		
		return result;
	}
	
	public static Process_Template_Step__c createProcessTemplateStep(String name, Id templateId, Integer sequence, String caseRole){
		Process_Template_Step__c result = new Process_Template_Step__c();
		result.Name = name;
		result.Process_Template__c = templateId;
		result.Sequence__c = sequence;
		result.Assign_To_Case_Role__c = caseRole;
		return result;
	}
	
	public static Process__c createProcess(String name, Id templateId, Id caseId){
		Process__c result = new Process__c();
		result.Name = name;
		result.Process_Template__c = templateId;
		result.Case__c = caseId;
		
		return result;	
	}
	
	public static Process__c createAccountProcess(String name, Id templateId, Id accountId){
		Process__c result = new Process__c();
		result.Name = name;
		result.Process_Template__c = templateId;
		result.Entity__c = accountId;
		
		return result;	
	}
	
	public static Process_Step__c createProcessStep(String name, Id processId, String status, Integer sequence){
		Process_Step__c result = new Process_Step__c();
		result.Name = name;
		result.Process__c = processId;
		result.Status__c = status;
		result.Sequence__c = sequence;
		return result;
	}
	
	public static Case createCase(String status, String origin){
		Case result = new Case();
		result.Status = status;
		result.Origin = origin;
		
		return result;
	}
	
	public static Account createAccount(String name){
		Account result = new Account();
		result.Name = name;
		return result;
	}
	
	public static Contact createContact(String firstName, String lastName){
		Contact result = new Contact();
		result.FirstName = firstName;
		result.LastName = lastName;
		return result;
	}
	
	public static Lead createLead(String firstName, String lastName, String company, String status){
		Lead result = new Lead();
		result.FirstName = firstName;
		result.LastName = lastName;
		result.Company = company;
		result.Status = status;
		return result;
	}
	
	public static Opportunity createOpportunity(String Name, Date closeDate, String stage){
		Opportunity result = new Opportunity();
		result.Name = name;
		result.CloseDate = closeDate;
		result.StageName = stage;
		return result;
	}
	
	public static User createUser (String userName,Id userProfile, String alias, String firstName, String lastName ){ 
        return new User(Username= userName+'@test.com', FirstName=firstName, LastName=lastName, 
                             Email= userName+'@test.com', Alias=alias, CommunityNickname=userName, 
                             IsActive=true, TimeZoneSidKey='America/Los_Angeles', 
                             LocaleSidKey='en_US', EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US', ProfileId = userProfile); 
    }
	
	public static XLR8_Assets_Liabilities__c createAsset(Id entityId){
        XLR8_Assets_Liabilities__c asset = new XLR8_Assets_Liabilities__c();
        
        asset.Entity__c = entityId;
        
        return asset;
    }
    
    public static RMD_Factors__c createFactor(Integer age, Integer age2, String calculationType, Decimal factor){
    	RMD_Factors__c factor1 = new RMD_Factors__c();
        factor1.Age_EOY__c = age; 
        factor1.Age_EOY_2__c = age2; 
        factor1.Calculation_Type__c = calculationType;
        factor1.RMD_Factor__c = factor;
        
        return factor1;
    }
	
}