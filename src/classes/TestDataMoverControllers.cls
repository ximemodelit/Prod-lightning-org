/*
 * Test class to test the DataMoverPageController
 * and its component controllers
 * 
 * @author Ximena Lasserre
 * @since Feb 2015
 */

@isTest
private class TestDataMoverControllers {

	public static TestMethod void testDataMover(){
		
		//create custom settings 
		DataMoverDataMappingTestUtils.createCustomSettings();
		DataMoverDataMappingTestUtils.createObjectsToTestInsert();
				
		Test.startTest();
		
		//delete any existing job
		List<CronTrigger> ct = [SELECT Id, CronJobDetailId
								FROM CronTrigger];
								
		for(CronTrigger cron : ct){
			system.abortJob(cron.Id);
		}
				
		PageReference pageRef = Page.DataMover;
		Test.setCurrentPage(pageRef); 
		
		//instantiate controller
		DataMoverPageController pageController = new DataMoverPageController(); 
		pageController.getPackagesCustomSettings();
		pageController.getComponentControllerMap();
		pageController.getThis();
		pageController.getOptionsTrgtWithoutNA();
		pageController.showNotAvailablePackage();
		
		//instantiate component controller for step 1
		DataMoverStep1ComponentController step1Controller = new DataMoverStep1ComponentController();
		step1Controller.pageController = pageController;
		step1Controller.getPackages();
		step1Controller.goToStep2From1();
		
		//verify that the selected package is not installed
		pageController.selectedPackage = 'Test_Pack';
		system.assert(step1Controller.checkIfSelectedPackageInstalled() == false, 'The Test_Pack was valid, when it should be invalid.');
		
		pageController.selectedPackage = 'XLR8';		
		
		//instantiate component controller for step 2
		DataMoverStep2ComponentController step2Controller = new DataMoverStep2ComponentController();
		step2Controller.pageController = pageController;
		pageController.srcTrgWrappers = DataMoverDataMappingTestUtils.createListOfDataMoverObjInfoWrap();
		
		system.assert(pageController.srcTrgWrappers[0].allMatchingFieldsRequired.size() == 1, 'All matching fields required does not have one element');		
				
		system.assert(pageController.srcTrgWrappers[0].allMatchingFieldsNotRequired.size() == 1, 'All matching fields not required does not have one element');		
		
		step2Controller.goToStep3From2();	
		
		//instantiate component controller for step 3
		DataMoverStep3ComponentController step3Controller = new DataMoverStep3ComponentController();
		step3Controller.pageController = pageController;
		step3Controller.popUps();
		step3Controller.getTargetOneFieldWrapper();
		step3Controller.getTargetFieldLabelsForCurrentWithoutBooleansAndPicklists();
        step3Controller.newCurrent = 'Individual Insurance';
		step3Controller.changeCurrentObject();
		step3Controller.newTrgtLabel = '';
		step3Controller.currentSrcFieldToShow = '';
		step3Controller.showNoRequired = false;
		step3Controller.thereAreErrors = false;
		
		//asserts
		system.assert(step3Controller.getSourceFieldLabelsForCurrent().size() > 0, 'getSourceFieldLabelsForCurrent().size() is not > 0');
		system.assert(step3Controller.getTargetFieldLabelsForCurrent().size() > 0, 'getTargetFieldLabelsForCurrent().size() is not > 0');
		
		step3Controller.checkThatRequiredFieldsAndExtIdAreCompleted();
		system.debug('------ ' + pageController.srcTrgWrappers);
		//system.assert(true == false, 'jlk'); 
		step3Controller.checkThatAllValuesWereMapped();
		step3Controller.goToStep4From3();
		//instantiate component controller for step 4
		for(DataMoverObjectInfoWrapper obj : pageController.srcTrgWrappers){
			for(DataMoverFieldInfoWrapper f : obj.allMatchingFieldsRequired.values()){
				f.trgIsNameField = false;
			}
			for(DataMoverFieldInfoWrapper f : obj.allMatchingFieldsNotRequired.values()){
				f.trgIsNameField = false;
			}
		}
		DataMoverStep4ComponentController step4Controller = new DataMoverStep4ComponentController();
		step4Controller.pageController = pageController;
		system.assert(step4Controller.getDaysOfMonth().size() > 0, 'getDaysOfMonth().size() is not > 0');
		system.assert(step4Controller.getDaysOfWeek().size() > 0, 'getDaysOfWeek().size() is not > 0');
		system.assert(step4Controller.getOrdinals().size() > 0, 'getOrdinals().size() is not > 0');
		system.assert(step4Controller.getHoursOfDay().size() > 0, 'getOrdinals().size() is not > 0');
		step4Controller.jobName = 'Test job';
		step4Controller.weeklyOrMonthly = 'Monthly';
		step4Controller.dateOrDays = 'Days';
		step4Controller.selectedDate = '25';
		step4Controller.timeToStart = '13';
		step4Controller.startDate = '04/07/2015';
		step4Controller.endDate ='12/30/2016';
		step4Controller.saveAllMapping();	
		Test.stopTest();	
		
		List<CronTrigger> cronTggr = [SELECT Id, CronJobDetailId
									  FROM CronTrigger];
									  
		system.assert(cronTggr.size() == 1, 'There is not one scheduled cron trigger');	
		
		List<Mapping_Object__c> listOfMapObjs = [SELECT Id FROM Mapping_Object__c];
		
		system.assert(listOfMapObjs.size() == 3, 'There are not three mapping objects');	
		
		List<Field_Mapping__c> listOfFieldMaps = [SELECT Id FROM Field_Mapping__c];
		
		system.assert(listOfFieldMaps.size() == 10, 'There are not 10 field mappings, there are ' + listOfFieldMaps.size());	
		
		List<CheckBox_Picklist_Correlation__c> listOfCheckPick = [SELECT ID FROM CheckBox_Picklist_Correlation__c];
		
		system.assert(listOfCheckPick.size() == 4, 'There are not 4 checkbox and picklist correlations');
		
		DataMoverComponentsUtils.checkIfObjectExistsAndFill(pageController.srcTrgWrappers[0]);						
	}
	
	public static TestMethod void testJobAndErrorLog(){
		
		//create new job log wrapper
		JobLogWrapper jobLog = new JobLogWrapper();
		
		system.assert(0 == jobLog.nrOfRecords, 'The number of records when job log is instantiated is not 0');
		system.assert(null != jobLog.startDateTime, 'Start datetime is null');
		system.assert(null != jobLog.errorLogs, 'The error logs list is null');
		system.assert(0 == jobLog.errorLogs.size(), 'The size of the error logs is not 0, it is ' + jobLog.errorLogs.size());
		system.assert(null == jobLog.scheduledJob, 'The scheduled Job is not null');
		
		//create new error log wrapper
		ErrorLogWrapper errorLog = new ErrorLogWrapper('Test message', 'Test Status', 'Test src', 'Test trg',
		'Test value of external id');
		system.assert(errorLog.errorDescription.equals('Test message'), 'The error description is incorrect.');
		system.assert(errorLog.status.equals('Test Status'), 'The error status is incorrect.');
		system.assert(errorLog.sourceObj.equals('Test src'), 'The error source object is incorrect.');
		system.assert(errorLog.targetObj.equals('Test trg'), 'The error target object is incorrect.');
		system.assert(errorLog.valueOfObjectExtId.equals('Test value of external id'), 'The error\'s value of external id is incorrect.');
		
		//add error to job log
		jobLog.errorLogs.add(errorLog);
		system.assert(jobLog.errorLogs.size() == 1, 'The error logs list does not have one element, it has ' + jobLog.errorLogs.size());
	}
	
}