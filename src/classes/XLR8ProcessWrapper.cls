public with sharing class XLR8ProcessWrapper {
	
	public Process__c processRecord { get; set; }
    public boolean unassignedSteps { get; set; }
    public String parentRecordName { get; set; }
    public Id parentRecordId { get; set; }
    public String templateType { get; set; }
    
    public XLR8ProcessWrapper(Process__c pProcess){
        processRecord = pProcess;
        initData();
    }
    
    public void initData(){
    	// Init default values
    	templateType = '';
    	parentRecordName = '';
    	parentRecordId = null;
    	unassignedSteps = false;
    	
    	// Initialize template Type
    	if (processRecord != null ){
    		templateType = processRecord.Template_Type__c;
    	}
    	
    	// Initialize the information of the parent record (Name and Id)
    	if (templateType != null && templateType != ''){
    		if (templateType == 'Entity'){
    			parentRecordName = processRecord.Entity__r.Name;
    			parentRecordId = processRecord.Entity__c;
    		}else if (templateType == 'Contact'){
    			parentRecordName = processRecord.Contact__r.Name;
    			parentRecordId = processRecord.Contact__c;
    		}else if (templateType == 'Case'){
    			parentRecordName = processRecord.Case__r.CaseNumber;
    			parentRecordId = processRecord.Case__c;
    		}else if (templateType == 'Lead'){
    			parentRecordName = processRecord.Lead__r.Name;
    			parentRecordId = processRecord.Lead__c;
    		}else if (templateType == 'Opportunity'){
    			parentRecordName = processRecord.Opportunity__r.Name;
    			parentRecordId = processRecord.Opportunity__c;
    		}else{
    			parentRecordName = '';
    		}
    	}
    	
    	// Check if the process has unassigned steps when the auto create tasks is on
    	if (processRecord != null && processRecord.Process_Template__c != null && 
            processRecord.Process_Template__r.Auto_Create_Tasks_Default__c && !processRecord.Auto_Create_Tasks__c){
            unassignedSteps = true;
        } 
    }
}