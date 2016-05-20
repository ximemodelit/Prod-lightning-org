public with sharing class MassCreateProcessController {
    
    // Private instance variables
    private List<sObject> records {get;set;}
    private Date processDeadline {get;set;}
    
    // Public instance variables
    public List<String> errors { get; set; }
    public String SelectedTemplateId { get; set; }
    public Integer RecordCount { get; set; }
    public Boolean RecordsAreSelected { get; set; }
    public String deadline { get; set; }
    public List<XLR8ProcessWrapper> processes { get; set; }
    
    // Constructor
    public MassCreateProcessController(ApexPages.StandardSetController controller) {
        records = controller.getSelected();
        init();
    }
    
    /*** PRIVATE METHODS ***/
    
    /*
     * This method performs validations when the page is loaded, to ensure records are selected
     * @param -
     * @return -
     */
    private void init(){
    	processes = new List<XLR8ProcessWrapper>();
        errors = new List<String>();
        if (records.isEmpty()) {            
            errors.add('Please select at least one record');
            recordCount = 0;
            RecordsAreSelected = false;
        }else{
            recordCount = records.size();
            RecordsAreSelected = !records.isEmpty();
        }
        showErrors();
    }
    
    public List<SelectOption> TemplateSelectOptions {
        get {
            String sObjectLabel = getSObjectTypeLabel();
            List<Process_Template__c> templates = [SELECT Id, Name FROM Process_Template__c
                WHERE Type__c = :sObjectLabel ORDER BY Name];
            List<SelectOption> selectOptions = new List<SelectOption>();
            for (Process_Template__c template : templates) {
                selectOptions.add(new SelectOption(template.Id, template.Name));
            }
            return selectOptions;
        }
    }
    
    private Date convertStringToDate(String strDate){
    	Date myDate = null;
    	try{
    		String[] dts = strDate.split('/');
    		myDate = date.newinstance(Integer.valueOf(dts[2]), Integer.valueOf(dts[0]), Integer.valueOf(dts[1]));
    	}catch(Exception ex){}
		return myDate;
    }
    public void createProcesses() {
        List<Id> ids = new List<Id>();
        errors = new List<String>();
        
        // Ensure deadline is not blank
        if (deadline == null || deadline == ''){
            errors.add('Please enter the Deadline. '); 
        }

        if (deadline != null && deadline != '' ){
        	processDeadline= convertStringToDate(deadline);
			
			if (processDeadline == null){
				errors.add('Deadline must be in date format mm/dd/yyyy');
			}
			
        	if (processDeadline != null && processDeadline < system.today()){
            	errors.add('Deadline cannot be in the past. '); 
            	processDeadline = null;
        	}
        }
        
        if (errors.size() == 0){
            for (SObject sob : records) {
                ids.add(sob.Id);
            }
            
            // Must return a list of processes
            MassCreateProcesses massCreate = new MassCreateProcesses();
            List<Process__c> tmpProcesses = massCreate.createProcesses(Id.valueOf(SelectedTemplateId), ids, processDeadline);
            
            if (massCreate.errors != null && massCreate.errors.size() > 0){
                errors.addAll(massCreate.errors);                           
            }else{              
                processes = buildProcessWrapperList(tmpProcesses);
            }
        }
        
        showErrors();
    }
    
    public PageReference cancel() {
        PageReference result = null;
        String prefix = getObjectPrefix();
        if (prefix != null){
            result = new PageReference('/' + prefix +  '/o');
        }
        return result;
    }
    
    private String getSObjectTypeLabel() {
        if (records.isEmpty()) {
            return null;
        }
        Schema.SObjectType theType = records[0].getSObjectType();
        if (theType == Account.SObjectType) {
            return 'Entity';
        }
        if (theType == Lead.SObjectType) {
            return 'Lead';
        }
        if (theType == Case.SObjectType) {
            return 'Case';
        }
        if (theType == Opportunity.SObjectType) {
            return 'Opportunity';
        }
        if (theType == Contact.SObjectType) {
            return 'Contact';
        }
        return null;
    }
    
    private String getObjectPrefix(){
        String prefix = null;
        String objectType = getSObjectTypeLabel();
        Schema.DescribeSObjectResult dsr = null;
        if (objectType == 'Entity'){
            dsr = Account.SObjectType.getDescribe();
        }else if (objectType == 'Contact'){
            dsr = Contact.SObjectType.getDescribe();
        }else if (objectType == 'Lead'){
            dsr = Lead.SObjectType.getDescribe();
        }else if (objectType == 'Opportunity'){
            dsr = Opportunity.SObjectType.getDescribe();
        }else if (objectType == 'Case'){
            dsr = Case.SObjectType.getDescribe();
        }
        
        if (dsr != null){
            prefix = dsr.getKeyPrefix();
        }
        return prefix;
        
    }
    
    private void showErrors(){
        for (String error : errors){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, error)); 
        }       
    }
    private List<XLR8ProcessWrapper> buildProcessWrapperList(List<Process__c> processes){
    	List<XLR8ProcessWrapper> wrappers = new List<XLR8ProcessWrapper>();
    	
    	if (processes != null && processes.size() > 0){
    		for (Process__c pProcess : processes){
    			wrappers.add(new XLR8ProcessWrapper(pProcess));
    		}	
    	}
    	
    	return wrappers;
    }

}