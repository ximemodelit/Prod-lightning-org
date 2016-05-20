/*
 *Test class for PotentialRevenueTrigger
 *@author Ximena Lasserre
 *@since November 2015
 */
@isTest
public with sharing class PotentialRevenueTriggerTest {

	@testSetup static void setup(){
		Account acc1 = new Account();
		acc1.Name = 'Client Household Account';
		acc1.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Client Household').getRecordTypeId();
		insert acc1;
		
		Account acc2 = new Account();
		acc2.Name = 'Client Business Account';
		acc2.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Client Business').getRecordTypeId();
		insert acc2;		
		
		Potential_Revenue__c potentialRevenue = new Potential_Revenue__c();
		potentialRevenue.Name = 'Test Potential Revenue';
		potentialRevenue.Entity__c = acc1.Id; 
		potentialRevenue.RecordTypeId = Schema.SObjectType.Potential_Revenue__c.getRecordTypeInfosByName().get('Individual Life Insurance').getRecordTypeId();
		potentialRevenue.Referred_by_Other__c = 'Referred by Test';
		potentialRevenue.Opened_Date__c = Date.today();
		insert potentialRevenue;
		
	}
	
	static testmethod void testPotentialRevenueTrigger(){
		
		String exceptionExpected;
		
		Test.startTest();
		Id lifeInsuranceId = Schema.SObjectType.Potential_Revenue__c.getRecordTypeInfosByName().get('Individual Life Insurance').getRecordTypeId();
		
		List<Potential_Revenue__c> potentialRevs = [SELECT Id, RecordTypeId
													 FROM Potential_Revenue__c LIMIT 1];
		Id invalidRecordType = Schema.SObjectType.Potential_Revenue__c.getRecordTypeInfosByName().get('Commercial Insurance').getRecordTypeId();											 
		potentialRevs[0].RecordTypeId = invalidRecordType;
		
		try{
			update potentialRevs;
		}catch(Exception ex){
			exceptionExpected = ex.getMessage();
		}
		Test.stopTest();
		
		List<Potential_Revenue__c> potentialRevAfterUpdate = [SELECT Id, RecordTypeId
													            FROM Potential_Revenue__c LIMIT 1];
		
		system.assert(exceptionExpected != null, 'There was no exception when updating with invalid record type.');											            
		system.assert(potentialRevAfterUpdate[0].RecordTypeId.equals(lifeInsuranceId), 'The potential revenue record type changed. Trigger did not work.');											            
	}
}