/* This class contains methods to calculate the RMD Amount for requirements related to a specific Asset and Liability
 * @author Angelica Buffa
 * @since March 2015
 */
public with sharing class RMDAssetAndLiabilityCalculatorController {
	
	// Private instance variables
	@testVisible private List<String> errors { get; set; }
	
	// PUblic instance variables
	public String year { get; set; }
	public XLR8_Assets_Liabilities__c asset { get; set; }
	
	// Constructor
	public RMDAssetAndLiabilityCalculatorController(ApexPages.StandardController stdController){
		errors = new List<String>();
		
		init(stdController.getId());
	}
	
	/* This method retrieves the Name and Record Type information for current A&L
	 * @param - assetId id of the current asset and liability
	 * @return -
	 */
	private void init(Id assetId){
		if (assetId != null){
			List<XLR8_Assets_Liabilities__c> assets = [Select Id, Name, RecordType.Name 
														From XLR8_Assets_Liabilities__c 
													   Where Id =: assetId];
			if (assets.size() == 1){
				asset = assets.get(0);
			}
		}
		
		if (asset == null){
			errors.add('Asset And Liability not found.');
		}
	}
	
	
	/* This method calculates RMD for current Asset
	 * @param - -
	 * @return -
	 */
	public PageReference calculateRMDAmount(){
		PageReference page = null;
		errors = new List<String>();
		
		if (year == null || year == ''){
			errors.add('Year cannot be blank.');
		}
		
		if (year != null && year != '' && !RMDCalculatorUtils.validateYear(year)){
			errors.add('Year must be a four digitis number between 2000 and current year.');
		}
		
		if (errors.size() == 0){
			// Fetch the list of requirements related to the selected asset and year
			List<RMD_Requirement__c> rmdRequirements = RMDCalculatorUtils.getFinacialAccountsRMDRequirements(asset.Id, year);

			if (rmdRequirements.size() == 1){
				// Get the factors that match the spouse age, memer age and calculation type
				List<RMD_Factors__c> rmdFactors = RMDCalculatorUtils.getRMDFactors(rmdRequirements);
				
				if (rmdFactors != null && rmdFactors.size() > 0){
					Database.saveResult[] rmdCalculated = RMDCalculatorUtils.calculateRMDAmount(rmdFactors, rmdRequirements, system.now());
					boolean hasErrors = false;
					if (rmdCalculated != null){
						for(Database.saveResult result : rmdCalculated){
							if(!result.isSuccess()){
								hasErrors = true;
							}
						}
					}					
					// Verify if the rmd was calculated
					if (!hasErrors){
						page = new PageReference('/' + rmdRequirements.get(0).Id);
					}else{
						errors.add('An error occurred and the RMD was not calculated.');
					}					
				}else{
					errors.add('There was no entry found for this RMD Member\'s age on the RMD Factor table.');
				}
			}else if (rmdRequirements.size() > 1){
				errors.add('This Retirment Asset & Liability has more than one RMD Requirement record for ' + year + 
							'. Please review your records to proceed with the calculation.');
			}else{
				errors.add('No RMD Requirements were found');
			}		
		}
		
		if (errors.size() > 0){
			showErrors();
		}
		
		return page;
	}

	public void showErrors(){
		for (String error : errors){
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,error));
		}
	}
}