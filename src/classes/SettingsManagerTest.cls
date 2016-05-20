/*
 *Test class for SettingsManager class
 *@author Ximena Lasserre
 *@since October 2015
 */
@isTest
public with sharing class SettingsManagerTest {

	@testSetup static void setup(){
		Settings__c settings = new Settings__c();
		settings.Name = 'Default Settings';
		settings.UseTaskHistory__c = true;
		insert settings;
	}
	
	static testmethod void SettingsManagerTest(){
		Test.startTest();
		
		Settings__c settingsObj = SettingsManager.getSettings();
		
		Test.stopTest();
		
		system.assert(settingsObj != null, 'There were no settings returned.');
	}
}