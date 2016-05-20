public with sharing class ProcessUtils {

	 private String getRoleName(String objectType, Process_Template_Step__c templateStep){
    	String roleFieldName = null;
    	
    	if (objectType == 'Account') {
          	roleFieldName = templateStep.Assign_To_Role__c;
        }else if (objectType == 'Lead') {
 			roleFieldName = templateStep.Assign_To_Lead_Role__c;
 		}else if (objectType == 'Contact') {
 			roleFieldName = templateStep.Assign_To_Contact_Role__c;
 		}else if (objectType == 'Opportunity') {
 			roleFieldName = templateStep.Assign_To_Opportunity_Role__c;
 		}else if (objectType == 'Case') {
 			roleFieldName = templateStep.Assign_To_Case_Role__c;
 		}		
 			
 		if (roleFieldName != null && roleFieldName.length() > 0){
	        roleFieldName = roleFieldName.trim() + '__c';
	        roleFieldName = roleFieldName.replaceAll('\\p{Blank}', '_');
 		}
    	
    	
    	return roleFieldName;
    }
    
     public Map<String, Id> getAssignedToUser(List<Process_Template_Step__c> templateSteps, List<Process__c> processes) {
        Set<String> roleFieldNames = new Set<String>();
        String roleFieldName = null;
        String objectType = null;
        Map<String,Id> result = new Map<String,Id>();
        Map<Id,Id>parentIdsMap = new Map<Id,Id>();
        Map<Id,String>stepToRoleField = new Map<Id,String>();
        if (templateSteps != null && templateSteps.size() > 0 && processes != null && processes.size() > 0){
	        objectType = templateSteps.get(0).Process_Template__r.Type__c;
	        
	        if (objectType != 'Entity' && objectType != 'Lead' && objectType != 'Contact' && objectType != 'Case' && objectType != 'Opportunity' ){
	        	throw new ApplicationException('Unsupported object type: ' + objectType);
	        }
	        for (Process__c process1 : processes){
	        	Id parentId = null;
	        	if (objectType == 'Entity'){
	        		parentId = process1.Entity__c;
	        	}else if (objectType == 'Lead') {
	        		parentId = process1.Lead__c;
	        	}else if (objectType == 'Contact') {
	        		parentId = process1.Contact__c;
	        	}else if (objectType == 'Opportunity') {
	        		parentId = process1.Opportunity__c;
	        	}else if (objectType == 'Case') {
	        		parentId = process1.Case__c;
	        	}
	        	parentIdsMap.put(process1.Id, parentId);
	        }
			
			if (objectType == 'Entity'){
	        	objectType = 'Account';
			}
	        
	        
	        for (Process_Template_Step__c step : templateSteps){           
	        	rolefieldName = getRoleName(objectType, step);
	        	if (roleFieldName != null && roleFieldName.length() > 0){
		            roleFieldNames.add(roleFieldName);
		            stepToRoleField.put(step.id,roleFieldName);
	        	}        	
	        }
	        
	        if (roleFieldNames.size() > 0){
	        	roleFieldName = String.join(new List<String>(roleFieldNames), ' , ');
	        	try {
		        	List<String>parentIds = parentIdsMap.values();
		        	String query = 'SELECT ' + roleFieldName + ' FROM ' + objectType + ' WHERE Id IN :parentIds';
		        	Map<Id,SObject> sobjectsMap = new Map<Id,SObject>(Database.query(query));
		            if (!sobjectsMap.isEmpty()) {
		            	for (Id processId : parentIdsMap.keySet()){
		            		Id parentId = parentIdsMap.get(processId);
		            		for (Process_Template_Step__c step : templateSteps){   
								rolefieldName = stepToRoleField.get(step.Id);
								if (sobjectsMap.containsKey(parentId) && roleFieldName  != null && roleFieldName.length() > 0){
									Id userId = (Id)sobjectsMap.get(parentId).get(roleFieldName);
									String key = String.valueOf(processId) + String.valueOf(step.Id);
									result.put(key, userId);
								}
			            	}
		            	}
		            }            
		        }catch (Exception ex) { 
		                throw ex;
		                // assignedToUser = '';
		        }
	        }
        }
	    return result;
    }
    
    public Map<Id,Sobject> getParentOwnerIds(List<Process__c> processes, String templateType){
    	Map<Id,sObject> records = new Map<Id, sObject>();
    	Set<ID> recordIds = new Set<ID>();
    	for (Process__c pProcess : processes){    		
    		Id parentId = getProcessParentOwner(pProcess, templateType);
        	recordIds.add(parentId);
        }
		
		if (templateType == 'Entity'){
        	templateType = 'Account';
		}
		
		if (recordIds.size() > 0){
			String queryString = 'Select Id, OwnerId from ' + templateType + ' Where Id IN :recordIds';
			List<sObject> tmpRecords = Database.query(queryString);
			
			for (sObject o : tmpRecords){
				records.put(o.Id, o);
			}
		}  
		return records;
    }
    
    public Id getProcessParentOwner(Process__c pProcess, String templateType){
    	Id parentId = null;
    	
    	if (pProcess != null && templateType != null){
    		if (templateType == 'Entity'){
        		parentId = pProcess.Entity__c;
        	}else if (templateType == 'Lead') {
        		parentId = pProcess.Lead__c;
        	}else if (templateType == 'Contact') {
        		parentId = pProcess.Contact__c;
        	}else if (templateType == 'Opportunity') {
        		parentId = pProcess.Opportunity__c;
        	}else if (templateType == 'Case') {
        		parentId = pProcess.Case__c;
        	}
    	}
    	
    	return parentId;
    }
    
}