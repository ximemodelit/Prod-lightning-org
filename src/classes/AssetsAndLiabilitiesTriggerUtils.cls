/*
 * Utils class for AssetsAndLiabilitiesTrigger
 * @author Ximena Lasserre
 * @since Mar 2015
 */
public class AssetsAndLiabilitiesTriggerUtils {
	
	/*
     * Checks if every asset that is passed as an argument
     * has at least one total rmd requirement record, if not
     * it adds an error to the object
     * @param Map<Id, XLR8_Assets_Liabilities__c> mapNew - map of the new XLR8_Assets_Liabilities__c 
     * @param Map<Id, XLR8_Assets_Liabilities__c> mapOld - map of the original XLR8_Assets_Liabilities__c  
     */
    public void verifyIfRMDRequirements(Map<Id, XLR8_Assets_Liabilities__c> mapNew, Map<Id, XLR8_Assets_Liabilities__c> mapOld){
        
       
        		List<Id> allAssetsIds = new List<Id>();
		        for(XLR8_Assets_Liabilities__c asset : mapNew.values()){
		            if(asset.Total_RMD_Requirement_Records__c != null && asset.Total_RMD_Requirement_Records__c > 0 &&
		            (mapOld.get(asset.Id).RMD_Spouse__c != null || mapOld.get(asset.Id).RMD_Member__c != null) &&
		            (asset.RMD_Spouse__c != mapOld.get(asset.Id).RMD_Spouse__c || asset.RMD_Member__c != mapOld.get(asset.Id).RMD_Member__c)){
		            	allAssetsIds.add(asset.Id);
		            }
		        }
		        //query the rmdRequirements whose financial account id is the same as in allAssetsIds
		        List<RMD_Requirement__c> rmdRequirements = new List<RMD_Requirement__c>(); 
		        if(allAssetsIds.size() > 0){
		        	rmdRequirements = [SELECT Id, Financial_Account__c, RMD_Year__c
		            				   FROM RMD_Requirement__c
		                               WHERE Financial_Account__c IN :allAssetsIds];
		        }
		        
		        
		        String currentYear = String.valueOf(date.today().year());
		        
		        if(rmdRequirements.size() > 0){
			        for(RMD_Requirement__c rmd : rmdRequirements){
			            if(rmd.RMD_Year__c == currentYear){
			                mapNew.get(rmd.Financial_Account__c).addError(' The RMD Member and RMD Spouse cannot be modified if an ' +
			                        'RMD Requirement record exists for this Retirement Asset for the current RMD year.');
			            }
			        }   
		        }     
                                              
    }
}