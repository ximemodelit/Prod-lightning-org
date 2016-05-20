trigger Unique_Process_Template_Name on Process_Template__c (before insert, before update) 
{
    if (Trigger.isBefore)
    {
        if (Trigger.isInsert)
        {
        	Set<String> templateNames = new Set<String>();
            for (Process_Template__c newTemplate : Trigger.new)
            {
            	templateNames.add(newTemplate.Name);
            }
            
            List<Process_Template__c> templates = [select id, name from Process_Template__c where Name IN :templateNames];
            templateNames = new Set<String>();
            
            for (Process_Template__c template : templates)
            {
            	templateNames.add(template.Name);
            }
            
            for (Process_Template__c newTemplate : Trigger.new)
            {
            	if (templateNames.contains(newTemplate.Name))
                {
                    newTemplate.Name.addError('Process template name is already in use');
                }
            }
        }
        else if (Trigger.isUpdate)
        {
            Set<String> templateNames = new Set<String>();
            Set<Id> templateIds = new Set<Id>();
            
            for (Process_Template__c newTemplate : Trigger.new)
            {
            	templateNames.add(newTemplate.Name);
            	templateIds.add(newTemplate.Id);
            }
            
            List<Process_Template__c> templates = [select id, name from Process_Template__c where Name IN : templateNames and Id NOT IN : templateIds];
            templateNames = new Set<String>();
            
            for (Process_Template__c template : templates)
            {
            	templateNames.add(template.Name);
            }
            
            for (Process_Template__c newTemplate : Trigger.new)
            {
            	if (templateNames.contains(newTemplate.Name))
                {
                    newTemplate.Name.addError('Process template name is already in use');
                }
            }
        }    
    }

}