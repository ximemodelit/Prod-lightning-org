public with sharing class SettingsManager {
    public static Settings__c getSettings() {
        List<Settings__c> settings = Settings__c.getAll().values();
        if (!settings.isEmpty()) {
            return settings.get(0);
        }
        throw new ApplicationException('Please set up XLR8 custom settings.');
    
    }
}