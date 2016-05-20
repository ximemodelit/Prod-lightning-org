/*
 * Trigger that prevents the user from updating Spouse or Member
 * if there are any RMD Requirements created
 * @author Ximena Lasserre
 * @since Mar 2015
 */
trigger AssetsAndLiabilitiesTrigger on XLR8_Assets_Liabilities__c (before update) {

    if(Trigger.isBefore && Trigger.isUpdate){
        AssetsAndLiabilitiesTriggerUtils assetsUtils = new AssetsAndLiabilitiestriggerUtils();
        assetsUtils.verifyIfRMDRequirements(Trigger.newMap, Trigger.oldMap);
    }
}