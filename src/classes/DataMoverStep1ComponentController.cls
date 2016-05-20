/*
 * Controller for Step 1 component (DataMover)
 *
 * @author - Ximena Lasserre
 * @since - Jan 2015
 */
public with sharing class DataMoverStep1ComponentController extends DataMoverComponentControllerBase{
	
	public List<String> errorMsgs {get;set;}
	public String PACKAGE_NOT_INSTALLED_ERROR_MSG = 'The selected package is not available.';
	public String SELECT_PACKAGE_ERROR_MSG = 'Please select a package.';
	
	public DataMoverPageController pageController{
    	get;
	    set {
            if (value != null){
			    pageController = value;		   
		    }
	    }
	}
		
	public DataMoverStep1ComponentController(){
		errorMsgs = new List<String>();
	}
	
	/*
	 * Creates a list of options to display the packages 
	 * names on the page
	 * @return List<SelectOption> - list of the packages names
	 */
	public List<SelectOption> getPackages(){
		
		if(pageController.packagesMap != null){
			List<SelectOption> opt = new List<SelectOption>();
			opt.add(new SelectOption('None', 'Select Package'));
			for(String pack : pageController.packagesMap.keyset()){
				opt.add(new SelectOption(pack, pack));
			}
			return opt; 
		}else{
			return null;
		}		
	}
	
	/*
	 * Checks if the selected package is currently installed
	 * @return a boolean, if true, the selected package is installed, if not it isnt 
	 */
	public boolean checkIfSelectedPackageInstalled(){
		
		//check if the package is installed
		String selectedPackPref = pageController.packagesMap.get(pageController.selectedPackage);
		return DataMoverComponentsUtils.checkInstalledPackage(selectedPackPref);				
	}

	/*
	 * Takes the user to step 2
	 */
	public void goToStep2From1(){
		errorMsgs.clear();
		if(!checkIfSelectedPackageInstalled()){
			if(pageController.selectedPackage == 'None'){
				errorMsgs.add(SELECT_PACKAGE_ERROR_MSG);
			}else{
				errorMsgs.add(PACKAGE_NOT_INSTALLED_ERROR_MSG);
			}
		}else{
			errorMsgs.clear();
			pageController.goToStep2();
		}
	}
	
	
	
}