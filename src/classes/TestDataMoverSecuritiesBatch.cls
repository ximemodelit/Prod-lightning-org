/*
 *Test class to test Securities batch
 *@author Ximena Lasserre
 *@since September 2015
 */
@isTest
public with sharing class TestDataMoverSecuritiesBatch {

	/*
	 * Tests the correct functioning of the securities batch
	 */
	static testMethod void testSecuritiesBatch(){
		Map<String, Id> objsIds = DataMoverDataMappingTestUtils.createObjectsForSecurityBatch();
        String jobName = 'testmethod';
        String query = 'SELECT AssistantName FROM Contact';
            
        Test.startTest();
        
        DataMoverSecuritiesDataMappingBatch dmSecuritiesBatch =  new DataMoverSecuritiesDataMappingBatch(query, 'N/A', 'N/A', 'Contact',
        'XLR8CS__XLR8_Securities__c', String.valueOf(objsIds.get('MappingObject')), false, false, jobName, objsIds.get('JobLog'), 'XLR8');
        Database.executeBatch(dmSecuritiesBatch, 200);
        
        Test.stopTest();
        
        
        //verify there is one security
        List<SObject> securities = database.Query('SELECT Id FROM XLR8CS__XLR8_Securities__c');
        system.AssertEquals(1, securities.size());
        
        //verify the job log is updated
        List<Data_Mover_Job_Log__c> jobLog = database.Query('SELECT Id, Number_of_Processed_Records__c FROM Data_Mover_Job_Log__c');
        system.assert(1 == jobLog[0].Number_of_Processed_Records__c, 'The number of records processed was not one, it was ' + jobLog[0].Number_of_Processed_Records__c);
        
        //verify the security has the field value from the Contact
        List<XLR8_Securities__c> securityWithField = database.Query('SELECT Id, Name FROM XLR8CS__XLR8_Securities__c');
        system.AssertEquals('Larry', securityWithField[0].Name);
        
	}
}