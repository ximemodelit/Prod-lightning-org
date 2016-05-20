trigger Validate_Template_Step on Process_Template_Step__c (before insert, before update) 
{
    boolean runTrigger = (Trigger.isBefore && Trigger.isInsert) || (Trigger.isBefore && Trigger.isUpdate);
    boolean error = false;
    if (runTrigger)
    {
        //Create a set for Process Template IDs
        Set<ID> setPTIDs = new Set<ID>();
        
        for(Process_Template_Step__c PTS : Trigger.New)
            {
                setPTIDs.add(PTS.Process_Template__c);
            }
        
        //Fetch existing templates for this process template
        List<Process_Template_Step__c> existingTemplates = [SELECT Id, Name, Process_Template__c, Sequence__c FROM Process_Template_Step__c WHERE Process_Template__c in : setPTIDs limit : Limits.getLimitQueryRows()];
        
        for (Process_Template_Step__c templateStep: Trigger.new)
        {
            for (Process_Template_Step__c dbTemplateStep: existingTemplates)
            {
                 error =  (templateStep.Assign_To_Role__c != null) && (templateStep.Assign_to_User__c != null);
                 if (error)
                 {
                      // templateStep.Assign_To_Role__c.addError('You can provide value for either one of "Assign To Role" OR "Assign To User"');
                      // templateStep.Assign_to_User__c.addError('You can provide value for either one of "Assign To Role" OR "Assign To User"');
                 }
                    
                 //Validate Name
                 List<Process_Template_Step__c> lst = new List<Process_Template_Step__c>();
                 error = ValidateTemplateStepHelper.validateName(Trigger.isUpdate, dbTemplateStep, templateStep);
                 if (error)
                 {
                    templateStep.Name.addError('This name is already in use.');
                    break;
                 } 
                 
                 //Validate Sequence Number
                 error = ValidateTemplateStepHelper.validateSequence(Trigger.isUpdate, dbTemplateStep, templateStep);
                 if (error)
                 {
                    // templateStep.Sequence__c.addError('This sequence number is already in use. Please select another sequence number.');
                    break;
                 } 
            }
        }
    }
}