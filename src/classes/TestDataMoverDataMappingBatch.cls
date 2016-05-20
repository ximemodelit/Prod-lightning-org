/**
 * Test the class DataMoverDataMappingBatch
 *
 * @author Ximena Lasserre
 * @since 2014 - 14
 */
@isTest
private class TestDataMoverDataMappingBatch {

	/**
	 * Tests that new objects taken from the source object
	 * are correctly inserted.
	 *
	 */
    static testMethod void testBatchInsert(){
        
        List<Id> mappingObjsIds = DataMoverDataMappingTestUtils.createObjectsToTestInsert();
        String jobName = 'test';
         
        System.assertEquals(0, database.countQuery('SELECT COUNT() ' +
              								    'FROM XLR8CS__XLR8_Assets_Liabilities__c ' +
              								  	'WHERE TIN_EIN__c = \'john@doe.com\''));
        
            
        Test.startTest();
        DataMoverDataMappingBatch sac = new DataMoverDataMappingBatch(mappingObjsIds, jobName, null);

        ID batchProcessedId = Database.executeBatch(sac, 201);
        Test.stopTest();
        
        //verify that there exists a new Assets_Liabilities__c object,
        //the tin ein value should have been cut   						
        System.assertEquals(1, database.countQuery('SELECT COUNT() ' +
              								    'FROM XLR8CS__XLR8_Assets_Liabilities__c ' +
              								  	'WHERE TIN_EIN__c = \'john@doe.co\'')); 
        
        //verify custodian exists
        SObject sObj = database.Query('SELECT Custodian__c ' +
              							'FROM XLR8CS__XLR8_Assets_Liabilities__c ' +
              							'WHERE TIN_EIN__c = \'john@doe.co\'');
        System.assertEquals('Larry', sObj.get('Custodian__c')); 								  	 
              								  	  
        //verify if mapped date is correct
        Date dt = Date.newInstance(2010, 5, 17);         
        SObject resultingDate = database.Query('SELECT Inactive_Date__c ' +
              								   'FROM XLR8CS__XLR8_Assets_Liabilities__c ' +
              								   'WHERE TIN_EIN__c = \'john@doe.co\'');     									
        System.assertEquals(dt, resultingDate.get('Inactive_Date__c'));  
        
        //verify if picklist is mapped correctly
        SObject status = database.Query('SELECT Status__c ' +
              							  'FROM XLR8CS__XLR8_Assets_Liabilities__c ' +
              							  'WHERE TIN_EIN__c = \'john@doe.co\'');
              								  	
        System.assertEquals('Inactive', status.get('Status__c'));      									
        
    }
    
    /**
     * Tests that the objects and fields taken from the source
     * object are correctly updated to the target objects
     *
     */
	static testMethod void testBatchUpdate(){
        
                        
        DataMoverDataMappingTestUtils dmtu = new DataMoverDataMappingTestUtils();
        Id mapObjId = dmtu.createObjectsToTestUpdate(); 
        List<Id> mappingObjsIds = new List<Id>();
        mappingObjsIds.add(mapObjId);
		
        String query = 'SELECT Name, Description, Email, Birthdate, AccountId, ' +
        			   		  'HasOptedOutOfFax, AssistantName ' +
          			     'FROM Contact';
        String sourceAPIName = 'Contact';
        String targetAPIName = 'XLR8CS__XLR8_Assets_Liabilities__c';
        String sourceExtID = 'Description';
        String targetExtID = 'Name';
        Boolean sourceExtIDIsName = false;
        Boolean targetExtIDIsName = true;
        String jobName = 'test';
         
        Date oldDate = Date.newInstance(2010, 5, 17);
        Date newDate = Date.newInstance(1999, 3, 16);
        
        System.assertEquals(1, database.countQuery('SELECT COUNT() ' +
              								       'FROM XLR8CS__XLR8_Assets_Liabilities__c ' +
              								  	   'WHERE Inactive_Date__c = :oldDate'));
        
        Test.startTest();
        DataMoverDataMappingBatch sac = new DataMoverDataMappingBatch(mappingObjsIds, jobName, null);        
		ID batchProcessedId = Database.executeBatch(sac);
		
        Test.stopTest();
        
              								  	
        System.assertEquals(1, database.countQuery('SELECT COUNT() ' +
              								       'FROM XLR8CS__XLR8_Assets_Liabilities__c ' +
              								  	   'WHERE Inactive_Date__c = :newDate'));
        
              						   								  	
        System.assertEquals(0, database.countQuery('SELECT COUNT() ' +
              								    'FROM XLR8CS__XLR8_Assets_Liabilities__c ' +
              								  	'WHERE Inactive_Date__c = :oldDate'));      								  	         								  	       								  	
              								  	
              								  	
	}
	
}