/*
 * Trigger for Contact object
 * @author Ximena Lasserre
 * @since Mar 2015
 */
trigger ContactTrigger on Contact (before delete) {
	if(Trigger.isBefore && Trigger.isDelete){
        ContactTriggerUtils contactUtils = new ContactTriggerUtils();
        contactUtils.checkIfAssetsAndLiabilitiesHasRMDRequest(Trigger.oldMap);
    }
}