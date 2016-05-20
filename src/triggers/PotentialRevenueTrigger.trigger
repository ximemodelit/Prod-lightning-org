trigger PotentialRevenueTrigger on Potential_Revenue__c (before insert, before update) {
    if((Trigger.isInsert || Trigger.isUpdate) && Trigger.isBefore){
        PotentialRevenueTriggerUtils.validateRecordTypes(Trigger.new, Trigger.oldMap);
    }
}