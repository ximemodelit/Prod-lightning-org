/*
 * Utils class for ContactTrigger 
 *
 * @author Ximena Lasserre
 * @since Mar 2015
 */
public with sharing class ContactTriggerUtils {
	/*
     * Checks if the Assets & Liabilities related to the contact
     * has at least one Total_RMD_Requirement_Records__c and if
     * it is a Member or Spouse in that Asset, if so, the
     * oject cannot be deleted
     * @param Map<Id, Contact> oldMap: the map of Contacts that are going to be deleted
     */
    public void checkIfAssetsAndLiabilitiesHasRMDRequest(Map<Id, Contact> oldMap){
        Set<Id> listOfContactIds = new Set<Id>();
        for(Id idOfContact : oldMap.keyset()){
            listOfContactIds.add(idOfContact);
        }
        List<XLR8_Assets_Liabilities__c> listAssetsContacts = [SELECT Id, Total_RMD_Requirement_Records__c, RMD_Member__c, 
        															  RMD_Spouse__c
	                                                             FROM XLR8_Assets_Liabilities__c
	                                                            WHERE RMD_Member__c IN :listOfContactIds OR
	                                                            	  RMD_Spouse__c IN :listOfContactIds];      
	                                                           	                                                 
        if(listAssetsContacts.size() > 0){
            for(XLR8_Assets_Liabilities__c asset : listAssetsContacts){
                if(asset.Total_RMD_Requirement_Records__c > 0){
                	if(listOfContactIds.contains(asset.RMD_Spouse__c)){
                    	oldMap.get(asset.RMD_Spouse__c).addError(' This RMD Spouse cannot be deleted because a related Assets & Liabilities has RMD Requirements');
                	}
                	if(listOfcontactIds.contains(asset.RMD_Member__c)){
                    	oldMap.get(asset.RMD_Member__c).addError(' This RMD Member cannot be deleted because a related Assets & Liabilities has RMD Requirements');
                	}
                }
            }  
        }                                                 
    }
}