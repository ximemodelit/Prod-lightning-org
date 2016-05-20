/*
 * Controller for Step 4 component (DataMover)
 *
 * @author - Ximena Lasserre
 * @since - Jan 2015
 */
public with sharing class DataMoverStep4ComponentController extends DataMoverComponentControllerBase{
	
	public String jobName {get;set;}
	public String weeklyOrMonthly {get;set;}
	public List<String> selectedDaysOfTheWeek {get;set;}
	public String dateOrDays {get;set;}	
	public String selectedDayOfMonth {get;set;}
	public String selectedDate {get;set;}
	public String selectedDayWeekForMonthly {get;set;}
	public String timeToStart {get;set;}
	public Boolean showWeekInfo {get;set;}
	public Boolean showMonthInfo {get;set;}
	public Boolean showDatePanel {get;set;}
	public Boolean showDayPanel {get;set;}
	public List<String> errorMsgs {get; set;}
	public String startDate {get; set;}
	public String endDate {get;set;}
	public List<String> mappingObjectNamesOfObjectsWithJobs {get;set;}
	public Boolean atLeastOneJobOfOldObjectModified {get;set;}
    public List<Id> jobsIds {get;set;}
    
	
	/*
	 * Constructor
	 */
	public DataMoverStep4ComponentController(){	
		weeklyOrMonthly = 'Weekly';
		dateOrDays = 'Date';
		showWeekInfo = true;
		showMonthInfo = false;
		showDatePanel = true;
		showDayPanel = false;
		errorMsgs = new List<String>();
		selectedDaysOfTheWeek = new List<String>();
		atLeastOneJobOfOldObjectModified = false;
		mappingObjectNamesOfObjectsWithJobs = new List<String>();
	} 
	
	
	public DataMoverPageController pageController{ 
    	get;
	    set {
            if (value != null && value.initStep4Component){
			    pageController = value;
			    system.debug('>>> past step 4');
			    mappingObjectNamesOfObjectsWithJobs = getMappingObjectNamesOfObjectsWithJobs();
			    system.debug('>>> getMappingObjectNamesOfObjectsWithJobs()');
			    jobsIds =  getJobIdsOfCurrentMappingObjects();
			    system.debug('>>> past getJobIdsOfCurrentMappingObjects()');
			    pageController.initStep4Component = false;
		    }
	    }
	}
	
	/*
	 * Validate data
	 *
	 * @return Boolean
	 */
    private Boolean validateData() {
		
		// Validate required data
		if (jobName == '') {
			return false;
		}
		if (timeToStart == 'None') {
			return false;
		}
		if(weeklyOrMonthly == 'Weekly'){
			if(selectedDaysOfTheWeek.size() == 0) {
				return false;
			}
			
		}else{
			if(dateOrDays == 'Date'){
				if(selectedDayOfMonth == 'None'){
					return false;
				}
			}
			
		}	   		  
		return true;	      		  		   
	}
	
	/*
	 * Returns a list of select options 
	 * with 30 days
	 * @return List<SelectOption>: list of select options with 30 days 
	 */
	public List<SelectOption> getDaysOfMonth(){
		List<SelectOption> opt = new List<SelectOption>();
		for(Integer num = 1; num <= 31; num++){ //how to do with the 31-day months 
			opt.add(new SelectOption(String.valueOf(num), String.valueOf(num)));
		}
		opt.add(new SelectOption('L', 'Last day'));
		return opt;
	}
	
	/*
	 * Returns a list of select options 
	 * with the 7 days of the week
	 * @return List<SelectOption>: list of select options with the 7 days of the week
	 */
	public List<SelectOption> getDaysOfWeek(){
		List<SelectOption> opt = new List<SelectOption>();
		opt.add(new SelectOption('1', 'Sunday'));
		opt.add(new SelectOption('2', 'Monday'));
		opt.add(new SelectOption('3', 'Tuesday'));
		opt.add(new SelectOption('4', 'Wednesday'));
		opt.add(new SelectOption('5', 'Thursday'));
		opt.add(new SelectOption('6', 'Friday'));
		opt.add(new SelectOption('7', 'Saturday'));
		return opt;
	}
	
	/*
	 * Returns a list of select options 
	 * with the first four ordinal numbers, a none option and a Last option
	 * @return List<SelectOption>: list of select options with the first four ordinal numbers
	 */
	public List<SelectOption> getOrdinals(){
		List<SelectOption> opt = new List<SelectOption>();
		opt.add(new SelectOption('None', '--None--'));
		opt.add(new SelectOption('1', '1st'));
		opt.add(new SelectOption('2', '2nd'));
		opt.add(new SelectOption('3', '3rd'));
		opt.add(new SelectOption('4', '4th'));
		opt.add(new SelectOption('L', 'Last'));
		return opt;
	}
	
	/*
	 * Returns a list of select options 
	 * with a days hours
	 * @return List<SelectOption>: list of select options with a days hours
	 */
	public List<SelectOption> getHoursOfDay(){
		List<SelectOption> opt = new List<SelectOption>();
		opt.add(new SelectOption('None','--None--'));
        opt.add(new SelectOption('0','12:00 AM'));
        opt.add(new SelectOption('1','1:00 AM'));
        opt.add(new SelectOption('2','2:00 AM'));
        opt.add(new SelectOption('3','3:00 AM'));
		opt.add(new SelectOption('4','4:00 AM'));
		opt.add(new SelectOption('5','5:00 AM'));
		opt.add(new SelectOption('6','6:00 AM'));
		opt.add(new SelectOption('7','7:00 AM'));
		opt.add(new SelectOption('8','8:00 AM'));
		opt.add(new SelectOption('9','9:00 AM'));
		opt.add(new SelectOption('10','10:00 AM'));
		opt.add(new SelectOption('11','11:00 AM'));
		opt.add(new SelectOption('12','12:00 PM'));
        opt.add(new SelectOption('13','1:00 PM'));
        opt.add(new SelectOption('14','2:00 PM'));
        opt.add(new SelectOption('15','3:00 PM'));
		opt.add(new SelectOption('16','4:00 PM'));
		opt.add(new SelectOption('17','5:00 PM'));
		opt.add(new SelectOption('18','6:00 PM'));
		opt.add(new SelectOption('19','7:00 PM'));
		opt.add(new SelectOption('20','8:00 PM'));
		opt.add(new SelectOption('21','9:00 PM'));
		opt.add(new SelectOption('22','10:00 PM'));
		opt.add(new SelectOption('23','11:00 PM'));
        return opt;
	}
	
	/*
	 * Changes the displayed panel
	 * according to the selected 
	 * radiobutton
	 */
	public void changePanel(){
		if(weeklyOrMonthly == 'Weekly'){
			showWeekInfo = true;
			showMonthInfo = false;
			
		}else{
			showWeekInfo = false;
			showMonthInfo = true;
		}		
	}
	
	/*
	 * Changes the displayed panel
	 * according to the selected radiobutton
	 */
	public void changePanelDayDate(){
		if(dateOrDays == 'Date'){
			showDatePanel = true;
			showDayPanel = false;
		}else{
			showDatePanel = false;
			showDayPanel = true;
		}
	}
		
	/*
	 * First it inserts or updates all the objects,
	 * then it creates a scheduled job with the 
	 * specified data and adds the job id
	 * to the corresponding object mapping
	 */
	public void saveAllMapping(){
		
		Id jobId = null;
		if(validateData()){
			jobId = SchedulerUtility.schedule(jobName, weeklyOrMonthly, timeToStart, selectedDaysOfTheWeek, selectedDate, selectedDayWeekForMonthly, selectedDayOfMonth);
		}
		
    	//if the job was processed, then insert the objects and insert the job id in the corresponding mapping object
    	if(jobId != null){
    		//upsert objects
			createSFObjectsAndInsert();
			
			//insert the job
			Data_Mover_Scheduled_Job__c jobToUpsert = createScheduledJobObject(jobId);
			Database.SaveResult insertResults = Database.insert(jobToUpsert, false);
			
			boolean successfulJobInsert = true;
			if(!insertResults.isSuccess()){
				successfulJobInsert = false;
			}
			
			if(successfulJobInsert){
				    		
    			//abort the previous jobs, first query them
    			DataMoverComponentsUtils.abortJobs(jobsIds);
    			
    			
    			
    			//list of mapping objects where the job has to be added, whether new or old    			
				List<Mapping_Object__c> objectsToUpdate = DataMoverComponentsUtils.queryForTheMappingObjectWithThatJob(jobsIds);
    			Set<Id> objectsToUpdateSet = new Set<Id>();
    			if(objectsToUpdate != null){
    				for(Mapping_Object__c mappingObj : objectsToUpdate)
    				objectsToUpdateSet.add(mappingObj.Id);
    			}
    			//check if the objs created are already in the set, if not, add
    			for(DataMoverObjectInfoWrapper objWrapper : pageController.finalMapping.values()){
    				Mapping_Object__c mapping = objWrapper.mappingObjectCreated;
    				if(!objectsToUpdateSet.contains(mapping.Id)){
    					if(objectsToUpdate == null){
    						objectsToUpdate = new List<Mapping_Object__c>();
    					}
    					objectsToUpdate.add(mapping);
    				}
    			}
    			    			
    			//delete the previous scheduled job objects
    			DataMoverComponentsUtils.deleteOldJobs(jobsIds);
    			
    			if(objectsToUpdate != null && objectsToUpdate.size() > 0){
		    		for(Mapping_Object__c obj : objectsToUpdate){
		    			obj.Scheduled_Job_Id__c = jobId;
		    			obj.Data_Mover_Scheduled_Job__c = jobToUpsert.Id;
		    		}
		    		
		    		Database.saveResult[] res = Database.update(objectsToUpdate, true);
		    		
    			}
			}
    	}else{
    		String scheduleError = SchedulerUtility.getErrorMsg();
    		if(!scheduleError.equals('')){
    			errorMsgs.add(scheduleError);
    		}
    	}
	}
	
	/*
	 * Creates the mappingObject, fieldMapping,
	 * and CheckBox-Picklist Correlation objects
	 * and upserts them
	 */
	public void createSFObjectsAndInsert(){
		List<Mapping_Object__c> mapObjectsToInsert = new List<Mapping_Object__c>();
		
		if(pageController.finalMapping != null && pageController.finalMapping.size() > 0){
			for(DataMoverObjectInfoWrapper dmInfoWrapObj : pageController.finalMapping.values()){
				
				//create the mapping_Object__c
				Mapping_Object__c mapObj = new Mapping_Object__c(Id = dmInfoWrapObj.mapppingObjectId);
				mapObj.Name = dmInfoWrapObj.sourceLabel + ' to ' + dmInfoWrapObj.targetLabel;
				mapObj.Package_Name__c = pageController.selectedPackage;
				mapObj.Source_Object_API_Name__c = dmInfoWrapObj.sourceApiName;
				mapObj.Source_Object_Label__c = dmInfoWrapObj.sourceLabel;
				mapObj.Source_External_ID_is_Name_Field__c = dmInfoWrapObj.sourceExtIdFieldIsNameField; 
				mapObj.Source_External_ID_Field__c = dmInfoWrapObj.sourceExtIdField;
				mapObj.Source_External_ID_Field_Type__c = dmInfoWrapObj.sourceExtIdFieldType;
				mapObj.Source_External_ID_API_Name__c = dmInfoWrapObj.sourceExtIdFieldAPI;
				mapObj.Target_Object_API_Name__c = dmInfoWrapObj.targetApiName;
				mapObj.Target_Object_Label__c = dmInfoWrapObj.targetLabel;
				mapObj.Target_External_ID_is_Name_Field__c = dmInfoWrapObj.targetExtIdFieldIsNameField;
				mapObj.Target_External_ID_Field__c = dmInfoWrapObj.targetExtIdField;
				mapObj.Target_External_ID_Field_Type__c = dmInfoWrapObj.targetExtIdFieldType;
				mapObj.Target_External_ID_API_Name__c = dmInfoWrapObj.targetExtIdFieldAPI;
				dmInfoWrapObj.mappingObjectCreated = mapObj;
				mapObjectsToInsert.add(mapObj);
			}
		}
		
		//insert the objects into salesforce
		Database.upsertResult[] insertObjectsResult = Database.upsert(mapObjectsToInsert, true);
		//if the objects were inserted, the fields are inserted 
		Boolean allInserted = true;
		for(Database.upsertResult ur : insertObjectsResult){
			if(!ur.isSuccess()){
				allInserted = false;
				for(Database.Error err : ur.getErrors()){
					system.debug('Error: ' + err.getMessage());
				}
			}
		}
		if(allInserted){
			
			List<Field_Mapping__c> fieldMappingsToInsert = new List<Field_Mapping__c>();
			for(DataMoverObjectInfoWrapper dmInfoWrapObj : pageController.finalMapping.values()){
				
				//first iterate over allmatchingfieldsrequired
				if(dmInfoWrapObj.allMatchingFieldsRequired.size() > 0){
					for(DataMoverFieldInfoWrapper fieldObj : dmInfoWrapObj.allMatchingFieldsRequired.values()){
						if(!fieldObj.srcFieldLbl.equals('') && !fieldObj.trgFieldLbl.equals('')){
							Field_Mapping__c fieldToInsert = new Field_Mapping__c(Id = fieldObj.fieldMappingId);
							createFieldMappingObject(fieldToInsert, fieldObj, dmInfoWrapObj);
							fieldMappingsToInsert.add(fieldToInsert);
						}
					}
				}
				//then iterate over allmatchingfieldsnotrequired
				if(dmInfoWrapObj.allMatchingFieldsNotRequired.size() > 0){
					for(DataMoverFieldInfoWrapper fieldObj : dmInfoWrapObj.allMatchingFieldsNotRequired.values()){
						if(!fieldObj.srcFieldLbl.equals('') && !fieldObj.trgFieldLbl.equals('')){
							Field_Mapping__c fieldToInsert = new Field_Mapping__c(Id = fieldObj.fieldMappingId);
							createFieldMappingObject(fieldToInsert, fieldObj, dmInfoWrapObj);
							fieldMappingsToInsert.add(fieldToInsert);
						}
					}
				}
				//create field mapping for external id field info wrapper if it is filled
				if(dmInfoWrapObj.externalIdFieldMapping.trgFieldLbl != null){
					Field_Mapping__c fieldToInsert = new Field_Mapping__c(Id = dmInfoWrapObj.externalIdFieldMapping.fieldMappingId);
					createFieldMappingObject(fieldToInsert, dmInfoWrapObj.externalIdFieldMapping, dmInfoWrapObj);
					fieldMappingsToInsert.add(fieldToInsert);
				}
			}
			
			//insert the fields
			Database.upsertResult[]insertFieldsResult = Database.upsert(fieldMappingsToInsert, true);
			
			Boolean allFieldsInserted = true;
			for(Database.upsertResult ur : insertFieldsResult){
				if(!ur.isSuccess()){
					allFieldsInserted = false;
					for(Database.Error err : ur.getErrors()){
						system.debug('Error: ' + err.getMessage());
					}
				}
			}	
			
			//if all the fields were upserted, upsert the CheckBox_Picklist_Correlation__c
			if(allFieldsInserted){
				
				List<CheckBox_Picklist_Correlation__c> chckPickToInsert = new List<CheckBox_Picklist_Correlation__c>();
				
				for(DataMoverObjectInfoWrapper dmInfoWrapObj : pageController.finalMapping.values()){
					
					//first iterate over allmatchingfieldsrequired
					if(dmInfoWrapObj.allMatchingFieldsRequired.size() > 0){
						for(DataMoverFieldInfoWrapper fieldObj : dmInfoWrapObj.allMatchingFieldsRequired.values()){
							
							if(fieldObj.matchingValues.size() > 0){
								for(DataMoverValueInfoWrapper dmVal : fieldObj.matchingValues){
									CheckBox_Picklist_Correlation__c cpCorr = new CheckBox_Picklist_Correlation__c(Id = dmVal.checkboxPicklistId);
									cpCorr.Source_Value__c = dmVal.srcValue;
									cpCorr.Target_Value__c = dmVal.trgValue;
									cpCorr.Source_Field_API_Name__c = fieldObj.srcFieldApiName;
									cpCorr.Target_Field_API_Name__c = fieldObj.trgFieldApiName;
									cpCorr.Field_Mapping__c = fieldObj.fieldMappingCreated.Id; 
									chckPickToInsert.add(cpCorr);
								}
							}
						}
					}
					if(dmInfoWrapObj.allMatchingFieldsNotRequired.size() > 0){
						for(DataMoverFieldInfoWrapper fieldObj : dmInfoWrapObj.allMatchingFieldsNotRequired.values()){
							
							if(fieldObj.matchingValues.size() > 0){
								for(DataMoverValueInfoWrapper dmVal : fieldObj.matchingValues){
									CheckBox_Picklist_Correlation__c cpCorr = new CheckBox_Picklist_Correlation__c(Id = dmVal.checkboxPicklistId);
									cpCorr.Source_Value__c = dmVal.srcValue;
									cpCorr.Target_Value__c = dmVal.trgValue;
									cpCorr.Source_Field_API_Name__c = fieldObj.srcFieldApiName;
									cpCorr.Target_Field_API_Name__c = fieldObj.trgFieldApiName;
									cpCorr.Field_Mapping__c = fieldObj.fieldMappingCreated.Id; 
									chckPickToInsert.add(cpCorr);
								}
							}
						}
					}
				}
				//insert the CheckBox_Picklist_Correlation__c
				Database.upsertResult[] insertChckPickValuesResult = Database.upsert(chckPickToInsert, true);
				
				for(Database.upsertResult ur : insertChckPickValuesResult){
				if(!ur.isSuccess()){
					for(Database.Error err : ur.getErrors()){
						system.debug('Error: ' + err.getMessage());
					}
				}
			}	
			}
		}
	}
	
	/*
	 * Fills with information the Field_Mapping__c object passed as param
	 * @param Field_Mapping__c fieldToInsert
	 * @param DataMoverFieldInfoWrapper fieldObj
	 * @param DataMoverObjectInfoWrapper dmInfoWrapObj
	 */
	public void createFieldMappingObject(Field_Mapping__c fieldToInsert, DataMoverFieldInfoWrapper fieldObj, DataMoverObjectInfoWrapper dmInfoWrapObj){
		fieldToInsert.Name = fieldObj.srcFieldLbl + ' to ' + fieldObj.trgFieldLbl;
		fieldToInsert.Source_Field_API_Name__c = fieldObj.srcFieldApiName;
		fieldToInsert.Source_Field_Label__c = fieldObj.srcFieldLbl;
		fieldToInsert.Source_Field_Type__c = fieldObj.srcFieldType;
		if(fieldObj.srcFieldRequired == true){
			fieldToInsert.Source_Field_Required__c = 'true';
		}else{
			fieldToInsert.Source_Field_Required__c = 'false';
		}
		fieldToInsert.Source_Is_Name_Field__c = fieldObj.srcIsNameField; 
		fieldToInsert.Target_Field_API_Name__c = fieldObj.trgFieldApiName;
		fieldToInsert.Target_Field_Label__c = fieldObj.trgFieldLbl;
		fieldToInsert.Target_Field_Type__c = fieldObj.trgFieldType;
		if(fieldObj.trgFieldRequired == true){
			fieldToInsert.Target_Field_Required__c = 'true';
		}else{
			fieldToInsert.Target_Field_Required__c = 'false';
		}
		fieldToInsert.Target_Is_Name_Field__c = fieldObj.trgIsNameField; 
		fieldToInsert.Object_Mapping__c = dmInfoWrapObj.mappingObjectCreated.Id; 
		fieldObj.fieldMappingCreated = fieldToInsert;
	}
	
	/*
	 * Creates the Data Mover Scheduled Job object 
	 * @param Id jobId: Id of the scheduled job
	 * @return Data_Mover_Scheduled_Job__c: The created object 
	 */
	public Data_Mover_Scheduled_Job__c createScheduledJobObject(Id jobId){
		if(jobId != null){
			Data_Mover_Scheduled_Job__c scheduledJob = new Data_Mover_Scheduled_Job__c();
			scheduledJob.Creator_Email__c = UserInfo.getUserEmail();
			scheduledJob.Cron_Expression__c = SchedulerUtility.getCronTriggerExpression(weeklyOrMonthly, timeToStart, selectedDaysOfTheWeek, selectedDate, selectedDayWeekForMonthly, selectedDayOfMonth);
			scheduledJob.End_Date__c = date.parse(endDate);
			scheduledJob.Name = jobName;
			scheduledJob.Start_Date__c = date.parse(startDate);
			scheduledJob.Job_Id__c = jobId;
			return scheduledJob;
		}
		return null;
	}
	
	/*
	 * Returns a list of the source and target object of each mapping object
	 * that has any of the jobs related to the mapping objects being modified
	 * The format is '[Source object label] to [Target object label]'
	 * @return List<String>: list of string with the format above said
	 */
	public List<String> getMappingObjectNamesOfObjectsWithJobs(){
				
		//get the list of jobs ids of the current mapping objects
		List<Id> jobsIds = getJobIdsOfCurrentMappingObjects();
		
		List<String> srcToTrgStrings = new List<String>();
		try{
			if(jobsIds != null && jobsIds.size() > 0){
				//get a map with the source and target label of objects with the scheduled jobs
				List<Mapping_Object__c> listMappings = DataMoverComponentsUtils.queryForTheMappingObjectWithThatJob(jobsIds);
				if(listMappings.size() > 0){
					for(Mapping_Object__c mapping : listMappings){
						srcToTrgStrings.add(mapping.Source_Object_Label__c + ' to ' + mapping.Target_Object_Label__c);					
					}
				}
			}
		}catch(Exception ex){
			system.debug('Exception message: ' + ex.getMessage());
			system.debug('Exception line number: ' + ex.getLineNumber());
			system.debug('Exception cause: ' + ex.getCause());
		} 
		return srcToTrgStrings;
	}
	
	/*
	 * Gets the scheduled job objects' ids of the mapping objects being created
	 * @return List<Id>: list of job ids 
	 */
	public List<Id> getJobIdsOfCurrentMappingObjects(){
		
		//list of mapping objects being handled
		List<Mapping_Object__c> mappingObjects = new List<Mapping_Object__c>();
    	system.debug('*****1 getJobIdsOfCurrentMappingObjects() ' + pageController.finalMapping);
    	List<Id> jobsIds = new List<Id>(); 
    	try{	
			for(DataMoverObjectInfoWrapper objectWrapper : pageController.finalMapping.values()){
				if(objectWrapper.mappingObjectCreated != null){
					mappingObjects.add(objectWrapper.mappingObjectCreated);
				}
			}		    				
			
			if(mappingObjects.size() > 0){
				for(Mapping_Object__c mapObj : mappingObjects){
					//if it is diff than null then it is an old object
					if(mapObj.Data_Mover_Scheduled_Job__c != null){
						jobsIds.add(mapObj.Data_Mover_Scheduled_Job__c);
					}
				}
			}
		}catch(Exception ex){
			system.debug('Exception message: ' + ex.getMessage());
			system.debug('Exception line number: ' + ex.getLineNumber());
			system.debug('Exception cause: ' + ex.getCause());
		} 
		return jobsIds;
	}
	
	/*
	 * It takes the user back to step 3,
	 * and takes back all the methods
	 * executed in step 3 and in the 
	 * instantiation of component 4
	 */
	public void goBackToStep3(){
		//make the first in srcTrgWrappers the current again
		pageController.returnFromStep4 = true;
		pageController.finalMapping = null;
		pageController.goToStep3();
	}
	
	/*
	 * Checks if the name of the job passed as a parameter already exists
	 * If job name does not exist, it calls method saveAllMapping() 
	 */
	public void checkIfScheduledJobNameAlreadyExists(){
		//get the job name passed as a parameter
		String jobNameParam = Apexpages.currentPage().getParameters().get('jobName');
		pageController.jobExists = DataMoverComponentsUtils.checkIfJobNameAlreadyExists(jobNameParam);
		//if job name does not exist, save all
		if(!pageController.jobExists){
			saveAllMapping();
		}
	}
	
	
}