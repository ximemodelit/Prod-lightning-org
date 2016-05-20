/**
 * This is an utils class for the test classes TestDataMoverDataMappingBatch, TestDataMoverDataMappingWrapper,
 * and TestDataMoverControllers
 * @author Ximena Lasserre
 * @since 2014-12
 */
public class DataMoverDataMappingTestUtils {
	/**
	 * Create a source object (contact) with some data, a mapping object, 
	 * some field mapping related to that object to map that data
	 * and checkbox/picklist correlations
	 * @return Id: returns the id of the mapping object
	 */
	public static List<Id> createObjectsToTestInsert(){
		
		List<Id> mappingObjectsList = new List<Id>();
		//insert Account
        Account acc = new Account();
        acc.Name = 'Acme'; 
        
        insert acc;
                
        //insert Contact
        Contact cont = new Contact();
        cont.Description = 'John Doe';
        cont.Email = 'john@doe.com';
        cont.LastName = 'Dean';
        cont.AccountId = acc.Id; 
        cont.Birthdate = Date.newInstance(2010, 5, 17);
        cont.HasOptedOutOfFax = false;
        cont.AssistantName = 'Larry';
        
        insert cont;
        
		
        //create cron trigger to assign to job
        String cronExp = '0 29 12 09 4 ?';
        Id triggerId = system.schedule('test', cronExp, new DataMoverDataMappingScheduledBatch());
        
        //insert job
        Data_Mover_Scheduled_Job__c job = new Data_Mover_Scheduled_Job__c();
        job.Name = 'test';
        job.Creator_Email__c = 'john@mail.com';
        job.Cron_Expression__c = cronExp;
        Date endDate = Date.newInstance(2016, 12, 30);
        job.End_Date__c = endDate;
        job.Job_Id__c = triggerId;
        Date startDate = Date.newInstance(2015, 04, 07);
        job.Start_Date__c = startDate;
        
        insert job;
        
        //insert MappingObject
        Mapping_Object__c mapObj = new Mapping_Object__c(); 
        mapObj.Name = 'Contact to Assets & Liabilities';
        mapObj.Source_Object_API_Name__c = 'Contact'.toLowerCase();
        mapObj.Source_Object_Label__c = 'Contact';
        mapObj.Source_External_ID_Field__c = 'Description';
        mapObj.Source_External_ID_API_Name__c = 'Description'.toLowerCase();
        mapObj.Source_External_ID_Field_Type__c = 'STRING';
        mapObj.Source_External_ID_is_Name_Field__c = false;
        mapObj.Target_Object_API_Name__c = 'XLR8CS__XLR8_Assets_Liabilities__c'.toLowerCase();
        mapObj.Target_Object_Label__c = 'Assets & Liabilities';
        mapObj.Target_External_ID_Field__c = '	Asset/Account Number';
        mapObj.Target_External_ID_API_Name__c = 'Name'.toLowerCase();
        mapObj.Target_External_ID_Field_Type__c = 'STRING';
        mapObj.Target_External_ID_is_Name_Field__c = true;
        mapObj.Package_Name__c = 'sii14pkg'; 
        //mapObj.X18_Character_Job_Id__c = '';
        //mapObj.Scheduled_Job_Id__c = '';
        mapObj.Data_Mover_Scheduled_Job__c = job.Id;
        
        insert mapObj;
        mappingObjectsList.add(mapObj.id);
		
        //insert fieldMapping for Email/TIN EIN
        Field_Mapping__c field = new Field_Mapping__c();
        field.Object_Mapping__c = mapObj.Id;
        field.Source_Field_API_Name__c = 'Email'.toLowerCase();
        field.Source_Field_Label__c = 'Email';
        field.Source_Field_Required__c = 'false';
        field.Source_Field_Type__c = 'EMAIL';
        field.Source_Is_Name_Field__c = false;
        field.Target_Field_API_Name__c = 'TIN_EIN__c'.toLowerCase();
        field.Target_Field_Label__c = 'TIN/EIN';
        field.Target_Field_Required__c = 'false';
        field.Target_Field_Type__c = 'STRING';
        field.Target_Is_Name_Field__c = false;
      
        insert field;
        
        //insert fieldMapping for Account Name/Entity
        Field_Mapping__c field2 = new Field_Mapping__c();
        field2.Object_Mapping__c = mapObj.Id;
        field2.Source_Field_API_Name__c = 'AccountId'.toLowerCase();
        field2.Source_Field_Label__c = 'Account Name';
        field2.Source_Field_Required__c = 'false';
        field2.Source_Field_Type__c = 'REFERENCE';
        field2.Source_Is_Name_Field__c = false;
        field2.Target_Field_API_Name__c = 'Entity__c'.toLowerCase();
        field2.Target_Field_Label__c = 'Entity';
        field2.Target_Field_Type__c = 'REFERENCE';
        field2.Target_Field_Required__c = 'true';
        field2.Target_Is_Name_Field__c = false;
        
        insert field2;
        
        //insert Description/Acc nr
        Field_Mapping__c field4 = new Field_Mapping__c();
        field4.Object_Mapping__c = mapObj.Id; 
        field4.Source_Field_API_Name__c = 'Description'.toLowerCase();
        field4.Source_Field_Label__c = 'Description';
        field4.Source_Field_Type__c = 'TEXTAREA';
        field4.Source_Field_Required__c = 'false';
        field4.Source_Is_Name_Field__c = false;
        field4.Target_Field_API_Name__c = 'Name'.toLowerCase();
        field4.Target_Field_Label__c = 'Asset/Account Number';
        field4.Target_Field_Type__c = 'STRING';
        field4.Target_Field_Required__c = 'true';
        field4.Target_Is_Name_Field__c = false;
        
        insert field4;
        
        //insert Birthdate/Inactive Date
        Field_Mapping__c field5 = new Field_Mapping__c();
        field5.Object_Mapping__c = mapObj.Id; 
        field5.Source_Field_API_Name__c = 'Birthdate'.toLowerCase();
        field5.Source_Field_Label__c = 'Birthdate';
        field5.Source_Field_Type__c = 'DATE';
        field5.Source_Field_Required__c = 'false';
        field5.Source_Is_Name_Field__c = false;
        field5.Target_Field_API_Name__c = 'Inactive_Date__c'.toLowerCase();
        field5.Target_Field_Label__c = 'Inactive Date';
        field5.Target_Field_Type__c = 'DATE';
        field5.Target_Field_Required__c = 'false';
        field5.Target_Is_Name_Field__c = false;
        
        insert field5;
        
        //insert Fax Opt Out/Status
        Field_Mapping__c field6 = new Field_Mapping__c();
        field6.Object_Mapping__c = mapObj.Id; 
        field6.Source_Field_API_Name__c = 'HasOptedOutOfFax'.toLowerCase();
        field6.Source_Field_Label__c = 'Fax Opt Out';
        field6.Source_Field_Type__c = 'BOOLEAN';
        field6.Source_Field_Required__c = 'false';
        field6.Source_Is_Name_Field__c = false;
        field6.Target_Field_API_Name__c = 'Status__c'.toLowerCase();
        field6.Target_Field_Label__c = 'Status';
        field6.Target_Field_Type__c = 'PICKLIST';
        field6.Target_Field_Required__c = 'false';
        field6.Target_Is_Name_Field__c = false;
        
        insert field6;
        
        //insert Assistant/Custodian
        Field_Mapping__c field7 = new Field_Mapping__c();
        field7.Object_Mapping__c = mapObj.Id; 
        field7.Source_Field_API_Name__c = 'AssistantName'.toLowerCase();
        field7.Source_Field_Label__c = 'Assistant';
        field7.Source_Field_Type__c = 'STRING';
        field7.Source_Field_Required__c = 'false';
        field7.Source_Is_Name_Field__c = false;
        field7.Target_Field_API_Name__c = 'Custodian__c'.toLowerCase();
        field7.Target_Field_Label__c = 'Custodian';
        field7.Target_Field_Type__c = 'PICKLIST';
        field7.Target_Field_Required__c = 'false';
        field7.Target_Is_Name_Field__c = false;
        
        insert field7;
        
        //insert CheckBox_Picklist_Correlation__c
        CheckBox_Picklist_Correlation__c chckPick1 = new CheckBox_Picklist_Correlation__c();
        chckPick1.Field_Mapping__c = field6.Id;
        chckPick1.Source_Field_API_Name__c = 'HasOptedOutOfFax'.toLowerCase();
        chckPick1.Source_Value__c = 'True';
        chckPick1.Target_Field_API_Name__c = 'Status__c'.toLowerCase();
        chckPick1.Target_Value__c = 'Active';
        
        insert chckPick1;
        
        //insert CheckBox_Picklist_Correlation__c
        CheckBox_Picklist_Correlation__c chckPick2 = new CheckBox_Picklist_Correlation__c();
        chckPick2.Field_Mapping__c = field6.Id;
        chckPick2.Source_Field_API_Name__c = 'HasOptedOutOfFax'.toLowerCase();
        chckPick2.Source_Value__c = 'False';
        chckPick2.Target_Field_API_Name__c = 'Status__c'.toLowerCase();
        chckPick2.Target_Value__c = 'Inactive';
        
        insert chckPick2;
		
		//insert securities mapping object
        Mapping_Object__c mapObj2 = new Mapping_Object__c();
        mapObj2.Name = 'Contact to Security';
        mapObj2.Source_Object_API_Name__c = 'Contact'.toLowerCase();
        mapObj2.Source_Object_Label__c = 'Contact';
        mapObj2.Source_External_ID_Field__c = 'N/A';
        mapObj2.Source_External_ID_API_Name__c = 'N/A';
        mapObj2.Source_External_ID_Field_Type__c = 'N/A';
        mapObj2.Source_External_ID_is_Name_Field__c = false;
        mapObj2.Target_Object_API_Name__c = 'XLR8CS__XLR8_Securities__c'.toLowerCase();
        mapObj2.Target_Object_Label__c = 'Security';
        mapObj2.Target_External_ID_Field__c = '	N/A';
        mapObj2.Target_External_ID_API_Name__c = 'N/A';
        mapObj2.Target_External_ID_Field_Type__c = 'N/A';
        mapObj2.Target_External_ID_is_Name_Field__c = false;
        mapObj2.Data_Mover_Scheduled_Job__c = job.Id;
        mapObj2.Package_Name__c = 'XLR8';
        
        insert mapObj2;
        mappingObjectsList.add(mapObj2.Id);
        
        //insert fieldMapping for Symbol/Symbol
        Field_Mapping__c field8 = new Field_Mapping__c();
        field8.Object_Mapping__c = mapObj2.Id;
        field8.Source_Field_API_Name__c = 'AssistantName'.toLowerCase();
        field8.Source_Field_Label__c = 'Assistant';
        field8.Source_Field_Type__c = 'STRING';
        field8.Source_Field_Required__c = 'false';
        field8.Source_Is_Name_Field__c = false;
        field8.Target_Field_API_Name__c = 'Name'.toLowerCase();
        field8.Target_Field_Label__c = 'Symbol';
        field8.Target_Field_Required__c = 'false';
        field8.Target_Field_Type__c = 'STRING';
        field8.Target_Is_Name_Field__c = true;
        insert field8;
      
      	return mappingObjectsList;

		
	}
	
	/**
	 * Create a source object (contact) with some data, a target object (assets and liabilities)
	 * which has the same data than the source, a mapping object, and
	 * some field mappings related to that object to map that data
	 */
	public Id createObjectsToTestUpdate(){
		
		//insert Account
        Account acc = new Account();
        acc.Name = 'Acme';
        
        insert acc;
        
        //insert Asset
        XLR8CS__XLR8_Assets_Liabilities__c asset = new XLR8CS__XLR8_Assets_Liabilities__c();
        asset.XLR8CS__TIN_EIN__c = 'oh@test.com';
        asset.XLR8CS__Inactive_Date__c = Date.newInstance(2010, 5, 17);
        asset.XLR8CS__Entity__c = acc.Id;
        asset.Name = 'Mr. Account Description';
        
        insert asset;
                
        //insert Contact
        Contact cont = new Contact();
        cont.Email = 'oh@test.com';
        cont.LastName = 'Dean';
        cont.Birthdate = Date.newInstance(1999, 3, 16);
        cont.AccountId = acc.Id;
        cont.Description  = 'Mr. Account Description';
        
        insert cont;
        
        //create cron trigger to assign to job
        String cronExp = '0 29 12 09 4 ?';
        Id triggerId = system.schedule('test', cronExp, new DataMoverDataMappingScheduledBatch());
        
        //insert job
        Data_Mover_Scheduled_Job__c job = new Data_Mover_Scheduled_Job__c();
        job.Name = 'test';
        job.Creator_Email__c = 'john@mail.com';
        job.Cron_Expression__c = cronExp;
        Date endDate = Date.newInstance(2016, 12, 30);
        job.End_Date__c = endDate;
        job.Job_Id__c = triggerId;
        Date startDate = Date.newInstance(2015, 04, 07);
        job.Start_Date__c = startDate;
        
        insert job;
        
        //insert MappingObject
        Mapping_Object__c mapObj = new Mapping_Object__c();
        mapObj.Name = 'Contact to Assets & Liabilities';
        mapObj.Source_Object_API_Name__c = 'Contact'.toLowercase();
        mapObj.Source_Object_Label__c = 'Contact';
        mapObj.Source_External_ID_Field__c = 'Description';
        mapObj.Source_External_ID_API_Name__c = 'Description'.toLowercase();
        mapObj.Source_External_ID_Field_Type__c = 'STRING';
        mapObj.Source_External_ID_is_Name_Field__c = false;
        mapObj.Target_Object_API_Name__c = 'XLR8CS__XLR8_Assets_Liabilities__c'.toLowercase();
        mapObj.Target_Object_Label__c = 'Assets & Liabilities';
        mapObj.Target_External_ID_Field__c = '	Asset/Account Number';
        mapObj.Target_External_ID_API_Name__c = 'Name'.toLowercase();
        mapObj.Target_External_ID_Field_Type__c = 'STRING';
        mapObj.Target_External_ID_is_Name_Field__c = true;
        //mapObj.Package_Name__c = 'sii14pkg'; 
        //mapObj.X18_Character_Job_Id__c = '';
        //mapObj.Scheduled_Job_Id__c = '';
        mapObj.Data_Mover_Scheduled_Job__c = job.Id;
        
        insert mapObj;
        
        //insert fieldMapping for Email/TIN EIN
        Field_Mapping__c field = new Field_Mapping__c();
        field.Object_Mapping__c = mapObj.Id;
        field.Source_Field_API_Name__c = 'Email'.toLowercase();
        field.Source_Field_Label__c = 'Email';
        field.Source_Field_Required__c = 'false';
        field.Source_Field_Type__c = 'EMAIL';
        field.Source_Is_Name_Field__c = false;
        field.Target_Field_API_Name__c = 'TIN_EIN__c'.toLowercase();
        field.Target_Field_Label__c = 'TIN/EIN';
        field.Target_Field_Required__c = 'false';
        field.Target_Field_Type__c = 'STRING';
        field.Target_Is_Name_Field__c = false;
      
        insert field;
        
        //insert fieldMapping for Account Name/Entity
        Field_Mapping__c field2 = new Field_Mapping__c();
        field2.Object_Mapping__c = mapObj.Id;
        field2.Source_Field_API_Name__c = 'AccountId'.toLowercase();
        field2.Source_Field_Label__c = 'Account Name';
        field2.Source_Field_Required__c = 'false';
        field2.Source_Field_Type__c = 'REFERENCE';
        field2.Source_Is_Name_Field__c = false;
        field2.Target_Field_API_Name__c = 'Entity__c'.toLowercase();
        field2.Target_Field_Label__c = 'Entity';
        field2.Target_Field_Type__c = 'REFERENCE';
        field2.Target_Field_Required__c = 'true';
        field2.Target_Is_Name_Field__c = false;
        
        insert field2;
        
        //insert Description/Acc nr
        Field_Mapping__c field4 = new Field_Mapping__c();
        field4.Object_Mapping__c = mapObj.Id; 
        field4.Source_Field_API_Name__c = 'Description'.toLowercase();
        field4.Source_Field_Label__c = 'Description';
        field4.Source_Field_Type__c = 'TEXTAREA';
        field4.Source_Field_Required__c = 'false';
        field4.Source_Is_Name_Field__c = false;
        field4.Target_Field_API_Name__c = 'Name'.toLowercase();
        field4.Target_Field_Label__c = 'Asset/Account Number';
        field4.Target_Field_Type__c = 'STRING';
        field4.Target_Field_Required__c = 'true';
        field4.Target_Is_Name_Field__c = false;
        
        insert field4;
        
        //insert Birthdate/Inactive Date
        Field_Mapping__c field5 = new Field_Mapping__c();
        field5.Object_Mapping__c = mapObj.Id; 
        field5.Source_Field_API_Name__c = 'Birthdate'.toLowercase();
        field5.Source_Field_Label__c = 'Birthdate';
        field5.Source_Field_Type__c = 'DATE';
        field5.Source_Field_Required__c = 'false';
        field5.Source_Is_Name_Field__c = false;
        field5.Target_Field_API_Name__c = 'Inactive_Date__c'.toLowercase();
        field5.Target_Field_Label__c = 'Inactive Date';
        field5.Target_Field_Type__c = 'DATE';
        field5.Target_Field_Required__c = 'false';
        field5.Target_Is_Name_Field__c = false;
        
        insert field5;
        
        return mapObj.Id;
	}
	
	/*
	 * Creates an account object and depending on objType (source or target), it
	 * creates the source or target object to use in the test class TestSearchAndCopyWrapper
	 * @param String that indicates if it is 'source' or 'target' 
	 * @retun The created SObject
	 */
	public SObject createSourceOrTargetObjectToTestWrapper(String objType){
		
		Account acc = new Account();
        acc.Name = 'Acme';
        insert acc;
        
        if(objType == 'source'){
        	SObject source = new Contact();
			source.put('Email', 'oh@test.com');
	        source.put('Description', 'John Doe');
	        source.put('Birthdate', Date.newInstance(2010, 5, 17));
	        source.put('AccountId', acc.Id);
	        source.put('LastName', 'Dean');
	        insert source; 
	        
	        return source;  
        }   
        else if(objType == 'target'){
        	
        	SObject target = new XLR8CS__XLR8_Assets_Liabilities__c();
	        target.put('TIN_EIN__c', 'oh@test.com');
	        target.put('Inactive_Date__c', Date.newInstance(2010, 5, 17));
	        target.put('Entity__c', acc.Id);
	        target.put('Name', 'Great Asset');
	        insert target;
	        
	        return target;
        }    
        return null;		     
	}
	
	/*
	 * Creates and inserts the custom settings (Data_Mover_XLR8_Objects__c
	 * and DataMoverSettings__c) to be used in 
	 * TestDataMoverControllers 
	 */
	public static void createCustomSettings(){
		
		DataMoverSettings__c dmCustSetXLR8 = new DataMoverSettings__c();
		dmCustSetXLR8.Name = 'XLR8';
		dmCustSetXLR8.Package_Name__c = 'XLR8';
		dmCustSetXLR8.Namespace_Prefix__c = 'XLR8CS';
		insert dmCustSetXLR8;
		
		DataMoverSettings__c dmCustNonExistent = new DataMoverSettings__c();
		dmCustNonExistent.Name = 'Test';
		dmCustNonExistent.Package_Name__c = 'Test_Pack';
		dmCustNonExistent.Namespace_Prefix__c = 'test';
		insert dmCustNonExistent;
		
		Data_Mover_XLR8_Objects__c objToBeUsed1 = new Data_Mover_XLR8_Objects__c();
		objToBeUsed1.API_Name__c = 'XLR8CS__XLR8_Securities__c';
		objToBeUsed1.Name = 'Security';
		insert objToBeUsed1;
		
		Data_Mover_XLR8_Objects__c objToBeUsed2 = new Data_Mover_XLR8_Objects__c();
		objToBeUsed2.API_Name__c = 'XLR8CS__XLR8_Insurance__c';
		objToBeUsed2.Name = 'Insurance';
		insert objToBeUsed2;
	}
	
	/*
	 * Creates a list to be assigned to srcTrgWrappers
	 * with one DataMoverObjectInfoWrapper object
	 * @return List<DataMoverObjectInfoWrapper>: list of DataMoverObjectInfoWrapper objects
	 */
	public static List<DataMoverObjectInfoWrapper> createListOfDataMoverObjInfoWrap(){
		
		//create values for field
		DataMoverValueInfoWrapper dmVal1 = new DataMoverValueInfoWrapper();
		dmVal1.srcValue = 'Long Term';
		dmVal1.trgValue = 'Manual';
		
		DataMoverValueInfoWrapper dmVal2 = new DataMoverValueInfoWrapper();
		dmVal2.srcValue = 'Short Term';
		dmVal2.trgValue = 'Import';
		List<DataMoverValueInfoWrapper> listVal = new List<DataMoverValueInfoWrapper>();
		listVal.add(dmVal1);
		listVal.add(dmVal2);
		
		//create non required fields
		DataMoverFieldInfoWrapper dmField1 = new DataMoverFieldInfoWrapper();
		dmField1.srcFieldLbl = 'Disability Type-Text-xlr8cs__disability_type__c';
		dmField1.srcFieldApiName = 'xlr8cs__disability_type__c';
		dmField1.srcFieldType = 'PICKLIST';
		dmField1.srcFieldRequired = false;
		dmField1.srcIsNameField = false;
		dmField1.srcObjApi = 'xlr8cs__xlr8_insurance__c';
		dmField1.trgFieldLbl = 'Data Source';
		dmField1.trgFieldApiName = 'xlr8cs__data_source__c';
		dmField1.trgFieldType = 'PICKLIST';
		dmField1.trgFieldRequired = false;
		dmField1.trgIsNameField = false;
		dmField1.trgObjApi = 'xlr8cs__xlr8_securities__c';
		dmField1.matchingValues = listVal;		
		
		Map<String, DataMoverFieldInfoWrapper> notReq = new Map<String, DataMoverFieldInfoWrapper>();
		notReq.put(dmField1.trgFieldApiName, dmField1);
		
		//create required fields  
		DataMoverFieldInfoWrapper dmField2 = new DataMoverFieldInfoWrapper();
		dmField2.srcFieldLbl = 'Import ID-Text-xlr8cs__import_id__c';
		dmField2.srcFieldApiName = 'xlr8cs__import_id__c';
		dmField2.srcFieldType = 'STRING';
		dmField2.srcFieldRequired = false;
		dmField1.srcIsNameField = false;
		dmField2.srcObjApi = 'xlr8cs__xlr8_insurance__c';
		dmField2.trgFieldLbl = 'Import ID';
		dmField2.trgFieldApiName = 'xlr8cs__import_id__c';
		dmField2.trgFieldType = 'STRING';
		dmField2.trgFieldRequired = false;
		dmField1.trgIsNameField = false;
		dmField2.trgObjApi = 'xlr8cs__xlr8_securities__c';
		dmField2.matchingValues = new List<DataMoverValueInfoWrapper>();		
		
		Map<String, DataMoverFieldInfoWrapper> req = new Map<String, DataMoverFieldInfoWrapper>();
		req.put(dmField2.trgFieldApiName, dmField2);
		
		//create object
		List<DataMoverObjectInfoWrapper> listObjsInfo = new List<DataMoverObjectInfoWrapper>();
		DataMoverObjectInfoWrapper objToBeAdded = new DataMoverObjectInfoWrapper();
		objToBeAdded.sourceApiName = 'xlr8cs__xlr8_insurance__c';
		objToBeAdded.sourceLabel = 'Individual Insurance';
		objToBeAdded.sourceExtIdField = 'Policy Notes-STRING-xlr8cs__description__c';
		objToBeAdded.sourceExtIdFieldType = 'STRING';
		objToBeAdded.sourceExtIdFieldAPI = 'XLR8CS__description__c';
		objToBeAdded.sourceExtIdFieldIsNameField = false;
		objToBeAdded.targetApiName = 'xlr8cs__xlr8_securities__c';
		objToBeAdded.targetLabel = 'Security';
		objToBeAdded.targetExtIdField = 'Security Description-STRING-xlr8cs__security_description__c';
		objToBeAdded.targetExtIdFieldType = 'STRING';
		objToBeAdded.targetExtIdFieldAPI = 'xlr8cs__security_description__c';
		objToBeAdded.targetExtIdFieldIsNameField = false;
		objToBeAdded.allMatchingFieldsNotRequired = notReq;
		objToBeAdded.allMatchingFieldsRequired = req;
		listObjsInfo.add(objToBeAdded);
		return listObjsInfo;
	}
	
	public static Map<String, Id> createObjectsForSecurityBatch(){
		
		Map<String, Id> mapOfIds = new Map<String, Id>();
		
		List<Id> mappingObjectsList = new List<Id>();
		//insert Account
        Account acc = new Account(); 
        acc.Name = 'Acme'; 
        
        insert acc;
               
        //insert Contact
        Contact cont = new Contact();
        cont.Description = 'John Doe';
        cont.Email = 'john@doe.com';
        cont.LastName = 'Dean';
        cont.AccountId = acc.Id; 
        cont.Birthdate = Date.newInstance(2010, 5, 17);
        cont.HasOptedOutOfFax = false;
        cont.AssistantName = 'Larry'; 
        
        insert cont;
        
        //create cron trigger to assign to job
        String cronExp = '0 29 12 09 4 ?';
        
        //insert job
        Data_Mover_Scheduled_Job__c job = new Data_Mover_Scheduled_Job__c();
        job.Name = 'testmethod';
        job.Creator_Email__c = 'john@mail.com';
        job.Cron_Expression__c = cronExp;
        Date endDate = Date.newInstance(2016, 12, 30);
        job.End_Date__c = endDate;
        Date startDate = Date.newInstance(2015, 04, 07);
        job.Start_Date__c = startDate;
        
        insert job;
        mapOfIds.put('Job', job.Id);
        
        //insert securities mapping object
        Mapping_Object__c mapObj2 = new Mapping_Object__c();
        mapObj2.Name = 'Contact to Security';
        mapObj2.Source_Object_API_Name__c = 'Contact';
        mapObj2.Source_Object_Label__c = 'Contact';
        mapObj2.Source_External_ID_Field__c = 'N/A';
        mapObj2.Source_External_ID_API_Name__c = 'N/A';
        mapObj2.Source_External_ID_Field_Type__c = 'N/A';
        mapObj2.Source_External_ID_is_Name_Field__c = false;
        mapObj2.Target_Object_API_Name__c = 'XLR8CS__XLR8_Securities__c';
        mapObj2.Target_Object_Label__c = 'Security';
        mapObj2.Target_External_ID_Field__c = '	N/A';
        mapObj2.Target_External_ID_API_Name__c = 'N/A';
        mapObj2.Target_External_ID_Field_Type__c = 'N/A';
        mapObj2.Target_External_ID_is_Name_Field__c = false;
        mapObj2.Data_Mover_Scheduled_Job__c = job.Id;
        mapObj2.Package_Name__c = 'XLR8';
        
        insert mapObj2;
        mapOfIds.put('MappingObject', mapObj2.Id);
        
        //insert fieldMapping for Symbol/Symbol
        Field_Mapping__c field8 = new Field_Mapping__c();
        field8.Object_Mapping__c = mapObj2.Id;
        field8.Source_Field_API_Name__c = 'AssistantName';
        field8.Source_Field_Label__c = 'Assistant';
        field8.Source_Field_Type__c = 'STRING';
        field8.Source_Field_Required__c = 'false';
        field8.Source_Is_Name_Field__c = false;
        field8.Target_Field_API_Name__c = 'Name';
        field8.Target_Field_Label__c = 'Symbol';
        field8.Target_Field_Required__c = 'false';
        field8.Target_Field_Type__c = 'STRING';
        field8.Target_Is_Name_Field__c = true;
        insert field8;
      
      	//create dm job log
      	Data_Mover_Job_Log__c jobLog = new Data_Mover_Job_Log__c();
      	jobLog.Data_Mover_Scheduled_Job__c = job.Id;
      	jobLog.Number_of_Processed_Records__c = 0;
      	jobLog.Start_DateTime__c = system.now();
      	
      	insert jobLog;
      	mapOfIds.put('JobLog', jobLog.Id);
      	
      	return mapOfIds;
	}
	
}