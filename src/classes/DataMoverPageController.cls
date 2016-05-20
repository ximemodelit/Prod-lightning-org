/*
 * Controller for DataMover page
 *
 * @author - Ximena Lasserre
 * @since - Jan 2015 
 */
public with sharing class DataMoverPageController{
	
	//constant variables
	public static final String NOT_APPLICABLE_STRING = 'N/A';
	
   	//public DataMoverComponentControllerBase myComponentController;
  	public Map<String, DataMoverComponentControllerBase> componentControllerMap; 
  	public String selectedPackage {get;set;} 
  	public List<DataMoverObjectInfoWrapper> srcTrgWrappers {get;set;}
  	public Map<String, String> packagesMap {get;set;}
  	
  	//sole object information, key is object label
  	public Map<String, DataMoverOneObjectWrapper> onlyXlr8Objects{get;set;} 
  	public Map<String, DataMoverOneObjectWrapper> onlySourceObjects{get;set;}
  	
  	public Map<String, Schema.SObjectType> globalDescribe = Schema.getGlobalDescribe();
	public Map<String, Schema.SObjectType> packageDescribe {get;set;}
	
	public DataMoverObjectInfoWrapper currentObject {get;set;}
	public DataMoverOneObjectWrapper currentXlr8 {get;set;}
	public DataMoverOneObjectWrapper currentSource {get;set;}
	
		
	public Map<String, DataMoverObjectInfoWrapper> finalMapping {get;set;}
	public Map<String, DataMoverObjectInfoWrapper> xlr8ObjWrappers {get;set;}
	
  	public Boolean showStep1 {get;set;}
	public Boolean showStep2 {get;set;}
	public Boolean showStep3 {get;set;}
	public Boolean showStep4 {get;set;}
	public Boolean showAlertPackage {get;set;}
	public Boolean noObjectSelected {get;set;}
	public Boolean showPopUp {get;set;}
	public Boolean jobExists {get;set;} 
	
	//variables to control the pageController's repeated instantiation
	public Boolean initStep3Component {get;set;}
	public Boolean returnFromStep4 {get;set;}
	public Boolean initStep2Component {get;set;}
	public Boolean initStep4Component {get;set;}

	//new getter for the hashmap
	public Map<String, DataMoverComponentControllerBase> getComponentControllerMap(){
	    return componentControllerMap;
	}
	//new method for putting value in the hashmap
	public void setComponentControllerMap(String key, DataMoverComponentControllerBase compController){
	    if(componentControllerMap == null)
	        componentControllerMap = new Map<String, DataMoverComponentControllerBase>();
	    componentControllerMap.put(key,compController); 
	}
	
	/*public void setComponentController(DataMoverComponentControllerBase compController) {
	    myComponentController = compController;
	}*/
	
	public DataMoverPageController getThis() {
	    return this;
	}
		
	public DataMoverPageController(){
		initStep3Component = true;
		initStep2Component = true;
		initStep4Component = true;
		jobExists = false;
		componentControllerMap = new Map<String, DataMoverComponentControllerBase>(); 
		componentControllerMap.put('1', new DataMoverStep1ComponentController());
		componentControllerMap.put('2', new DataMoverStep2ComponentController());
		componentControllerMap.put('3', new DataMoverStep3ComponentController());
		componentControllerMap.put('4', new DataMoverStep4ComponentController()); 
		
		getPackagesCustomSettings();
		showStep1 = true; 
		showStep2 = false;
		showStep3 = false;
		showStep4 = false;
		showAlertPackage = false;
		noObjectSelected = false;
		returnFromStep4 = false;
	}
	
	/*
	 * Gets the custom settings for the packages and 
	 * fills packagesMap with the name and prefix of the package
	 */
	public void getPackagesCustomSettings(){
		packagesMap = new Map<String, String>();
		//get all the available packages
		Map<String,DataMoverSettings__c> custSet = DataMoverSettings__c.getAll();
		if(custSet != null && custSet.size() > 0){
			for(String cSet : custSet.keySet()){
				//the map will have the package name, and the package prefix
				packagesMap.put(custSet.get(cSet).Package_Name__c, custSet.get(cSet).Namespace_Prefix__c);
			}			
		}
	}
	
	/*
	 * Creates a list of options of the target objects (xlr8) name
	 * to display
	 * @return List<SelectOption> - list of options of trg objs to display
	 */
	public List<SelectOption> getOptionsTrgt(){	
		List<SelectOption> options = new List<SelectOption>();
		if(onlyXlr8Objects != null && onlyXlr8Objects.size() > 0){			
			for(String xlr8Lbl : onlyXlr8Objects.keyset()){
				//remove the securities from the select list because they are handled with the checkbox
				if(!xlr8Lbl.contains('Security')){
					options.add(new SelectOption(xlr8Lbl, xlr8Lbl));
				}
			}
		}
		options.sort();
		options.add(0, new SelectOption(NOT_APPLICABLE_STRING, NOT_APPLICABLE_STRING)); 
		return options;			
	}
	
	/*
	 * Creates a list of options of the target objects (xlr8) name
	 * to display without showing 'N/A'
	 * @return List<SelectOption> - list of options of trg objs to display
	 */
	public List<SelectOption> getOptionsTrgtWithoutNA(){
		List<SelectOption> options = new List<SelectOption>();
		if(onlyXlr8Objects != null && onlyXlr8Objects.size() > 0){			
			for(String xlr8Lbl : onlyXlr8Objects.keyset()){
				//remove the securities from the select list because they are handled with the checkbox in step 3
				//if(!xlr8Lbl.contains('Security')){
					options.add(new SelectOption(xlr8Lbl, xlr8Lbl));
				//}
			}	
		}
		options.sort();
		
		return options;
	}
	
	/*
	 * Creates a list of options of the source objects names
	 * @return List<SelectOption> - list of options of trg objs to display
	 */
	public List<SelectOption> getOptionsSrc(){
		List<SelectOption> options = new List<SelectOption>();
		if(onlySourceObjects != null && onlySourceObjects.size() > 0){			
			for(DataMoverOneObjectWrapper sourceWrapper : onlySourceObjects.values()){
				options.add(new SelectOption(sourceWrapper.objLabel, sourceWrapper.objLabel));
			}	
		}
		options.sort();
		options.add(0, new SelectOption(NOT_APPLICABLE_STRING, NOT_APPLICABLE_STRING)); 
		return options;	
	}
	/*
	  * Returns the field label by passing the api name, the object label and if the object is
	  * source or target
	  * @param String apiName: field api name
	  * @param String objectLbl: the object label
	  * @param String sourceOrTarget: if the object is 'source' or 'target'
	  * @return String: the field label
	  */
	 public String getFieldLabelFromApi(String apiName, String objectLbl, String sourceOrTarget){
	 	String returnLabel;
	 	if(sourceOrTarget == 'source'){
	 		for(DataMoverOneFieldWrapper oneFieldWrapper : onlySourceObjects.get(objectLbl).objectFields.values()){
	 			if(oneFieldWrapper.fieldApiName == apiName){
	 				return oneFieldWrapper.fieldLabel;
	 			}
	 		}
	 		return returnLabel;
	 	}
		if(sourceOrTarget == 'target'){
	 		for(DataMoverOneFieldWrapper oneFieldWrapper : onlyXlr8Objects.get(objectLbl).objectFields.values()){
	 			if(oneFieldWrapper.fieldApiName == apiName){
	 				return oneFieldWrapper.fieldLabel;
	 			}
	 		}
	 		return returnLabel;
	 	}
	 	return null;
	 }
	
	/*
	 * Shows the component
	 * for step 1
	 */
	public void goToStep1(){
		showStep1 = true;
		showStep2 = false;
		showStep3 = false;
		showStep4 = false;
	}
	
	/*
	 * Shows the component
	 * for step 2
	 */
	public void goToStep2(){
		showStep1 = false;
		showStep2 = true;
		showStep3 = false;
		showStep4 = false;
	}
	
	/*
	 * Sets the variable showAlertPackage to true
	 * to display the message that says the package 
	 * is not installed
	 */
	public void showNotAvailablePackage(){
		showAlertPackage = true;
	}
	
	/*
	 * Shows the component
	 * for step 3
	 */
	public void goToStep3(){
		showStep1 = false;
		showStep2 = false;
		showStep3 = true;
		showStep4 = false;
	}
	
	/*
	 * Shows the component
	 * for step 4
	 */
	public void goToStep4(){
		showStep1 = false;
		showStep2 = false;
		showStep3 = false;
		showStep4 = true;		
	}
		
}