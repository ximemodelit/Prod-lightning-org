public with sharing class MassCreateProcesses {
	
	private static final String TEMPLATE_TYPE_ENTITY = 'Entity';
	private static final String TEMPLATE_TYPE_CASE = 'Case';
	private static final String TEMPLATE_TYPE_LEAD = 'Lead';
	private static final String TEMPLATE_TYPE_CONTACT = 'Contact';
	private static final String TEMPLATE_TYPE_OPPORTUNITY = 'Opportunity';
	private static final Integer NAME_FIELD_MAX_LENGTH = 80;
	
	private static final Map<String, String> sobjectNameByLabel = new Map<String, String> { 
		'Entity' => 'Account',
		'Case' => 'Case',
		'Lead' => 'Lead',
		'Contact' => 'Contact',
		'Opportunity' => 'Opportunity'
	};
	
	private ProcessUtils processUtils = new ProcessUtils();
	
	public Set<String> errors {get;set;}
	
	public List<Process__c> createProcesses(Id processTemplateId, List<Id> recordIds, Date deadline) {
		errors = new Set<String>();
		Set<Id> processIds = new Set<Id>();
		ProcessManager mgr = new ProcessManager();
		
		// TO DO: Move query into Uils class, add more error handling, before inserting steps, check if process
		// was inserted. Add rollbacks
		Process_Template__c template = [SELECT Name, Type__c 
										  FROM Process_Template__c 
										 WHERE Id = :processTemplateId];
										 
		List<Process__c> processes = insertProcesses(processTemplateId, recordIds, template, deadline);
		
		if (processes != null && processes.size() > 0){			
			mgr.insertProcessSteps(processTemplateId, processes);
			
			for (Process__c process1 : processes) {
				process1.Exclude_From_Auto_Create_Tasks__c = false;
				processIds.add(process1.Id);
			} 			
			
			if (isProcessUpdateable()){
				update processes;
			}else{			
				errors.add('You do not have perms to update processes.');
			}
			
			// Reload processes to fetch the information needed to be displayed on the confirmation page
			processes = XLR8ProcessUtils.getProcessesById(processIds);
		}
				
		return processes;
	}
	
	private List<Process__c> insertProcesses(Id processTemplateId, List<Id> recordIds, Process_Template__c template, Date deadline) {
		List<Process__c> result = new List<Process__c>();
		String templateType = template.Type__c;
		String nameField = 'Name';
		if (templateType == 'Case') {
			nameField = 'Subject';
		}
		Map<Id, sObject> sobjects = new Map<Id, sObject>(Database.query('SELECT Id, ' + nameField 
			+ ' FROM ' + sobjectNameByLabel.get(templateType) + ' WHERE Id IN :recordIds'));
		List<Process__c> processes = new List<Process__c>();
		for (Id recordId : recordIds) {
			String name = template.Name + ' - ' + sobjects.get(recordId).get(nameField);
			if (name.length() > NAME_FIELD_MAX_LENGTH) {
				name = name.substring(0, NAME_FIELD_MAX_LENGTH);
			}
			Process__c process1 = new Process__c(
				Process_Template__c = processTemplateId,
				Name = name,
				Exclude_From_Auto_Create_Tasks__c = true,
				Deadline__c = deadline
			);
			if (templateType == TEMPLATE_TYPE_ENTITY) {
				process1.Entity__c = recordId;
			}
			else if (templateType == TEMPLATE_TYPE_CASE) {
				process1.Case__c = recordId;
			}
			else if (templateType == TEMPLATE_TYPE_LEAD) {
				process1.Lead__c = recordId;
			}
			else if (templateType == TEMPLATE_TYPE_CONTACT) {
				process1.Contact__c = recordId;
			}
			else if (templateType == TEMPLATE_TYPE_OPPORTUNITY) {
				process1.Opportunity__c = recordId;
			}		
			else {
				throw new ApplicationException('Object type not supported: ' + templateType);
			}
			processes.add(process1);
		}
		if (isProcessCreateable()){
			Database.Saveresult[] results = Database.insert(processes,false);			
			Integer i = 0;
			for (Database.SaveResult sr : results) {
				Process__c p = processes.get(i);
			    if (sr.isSuccess()){ 
			    	result.add(p);
			    }else{
			        // Operation failed, so get all errors                
			        for(Database.Error err : sr.getErrors()) {	
			        	errors.add('An error occurred and the process: ' + p.Name + ' was not inserted: ' + err.getMessage() );
			        }
			    }
			    i++;
			}
		}else{			
	    	ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'You do not have perms to insert processes.');
			ApexPages.addMessage(myMsg); 
		}
		return result;
	}

	public static Boolean isProcessCreateable(){
		return (Schema.sObjectType.Process__c.isCreateable() && Process__c.Process_Template__c.getDescribe().isCreateable() &&
				Process__c.Name.getDescribe().isCreateable() && Process__c.Exclude_From_Auto_Create_Tasks__c.getDescribe().isCreateable() &&
				Process__c.Entity__c.getDescribe().isCreateable() && Process__c.Contact__c.getDescribe().isCreateable());
	}
	
	private static Boolean isProcessUpdateable(){
		return (Schema.sObjectType.Process__c.isUpdateable());
	}
}