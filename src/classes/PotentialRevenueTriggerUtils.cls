public with sharing class PotentialRevenueTriggerUtils{

    public static void validateRecordTypes(List<Potential_Revenue__c > newRecords, Map<Id,Potential_Revenue__c> oldRecords){
        Set<Id> entityIds = new Set<Id>();
        Set<Id> potentialRevenueRecordTypeIds = new Set<Id>();
        List<Potential_Revenue__c> potentialRevenues = new List<Potential_Revenue__c>();
        
        
        for(Potential_Revenue__c potentialRevenue : newRecords){
            if (potentialRevenue.RecordTypeId != null && 
                (oldRecords == null || 
                (potentialRevenue.RecordTypeId != oldRecords.get(potentialRevenue.Id).RecordTypeId || 
                 potentialRevenue.Entity__c != oldRecords.get(potentialRevenue.Id).Entity__c))){
                entityIds.add(potentialRevenue.Entity__c);
                potentialRevenueRecordTypeIds.add(potentialRevenue.RecordTypeId);
                potentialRevenues.add(potentialRevenue);
            }
        }
        
        if (entityIds.size() > 0){
            Map<Id,String> entityRecordTypes = NFPUtils.getEntityRecordTypeNames(entityIds);
            Map<Id,String> potentialRevenueRecordTypes = NFPUtils.getPotentialRevenueRecordTypes(potentialRevenueRecordTypeIds);
            for(Potential_Revenue__c potentialRevenue : potentialRevenues){
                String entityRecordTypeName= entityRecordTypes.get(potentialRevenue.Entity__c);
                String potentialRevenueRecordTypeName = potentialRevenueRecordTypes.get(potentialRevenue.RecordTypeId);
                if(!NFPUtils.checkIfPotentialRevenueRecordTypeValid(potentialRevenueRecordTypeName,entityRecordTypeName)){
                    potentialRevenue.addError('The selected record type is not available for the entity record type.');
                }
            }
        }
    }

}