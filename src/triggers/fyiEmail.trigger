/*
    Concenter Services, LLC
 ************************************************************************************************************************
 * Revision History
 * Change #		Developer		Date		Description
 ************************************************************************************************************************
 * 1.1         Jason Landry    02/27/15     PlanIO 709 - Block sending of multiple FYI's at time of creating recurring task
 */

trigger fyiEmail on Task (after insert, after update) {
    
    Id[] taskIds = new Id[]{};
    
    // Collect the Ids of all the Tasks where Send FYI is true
    for (Task task : Trigger.new) {
    	//1.1 start
        if ( task.Send_FYI__c == true && Trigger.isInsert && task.RecurrenceActivityId==task.Id ) {
             task.Send_FYI__c.addError('FYI is not allowed on creation of recurring task series.');
             break;
        }
        //1.1 end 
        
    	if (task.Send_FYI__c == true)
    		taskIds.add(task.Id);
    }

    // Continue only if there is at least one Task where Send FYI is true
    if (taskIds.size() > 0) {
        // Get updatable Task objects for each Task where Send FYI is true 
        Task[] tasks = [SELECT FYI_List__c, Description FROM Task WHERE Id IN :taskIds];
        // Get the Id of the Task FYI Email Visualforce  Email Template
        Id templateId = [SELECT Id FROM EmailTemplate WHERE DeveloperName = 'Task_FYI_Email'].Id;
        Set<String> aliases = new Set<String>();
        User[] users;
        Map<String, Id> aliasUserId = new Map<String, Id>();
        Messaging.Email[] emails = new Messaging.Email[]{};
        // Today's date & time with time zone
        String now = Datetime.now().formatLong();
        
        // Collect all Aliases
        for (Task task : tasks)
            aliases.addAll(task.FYI_List__c.split(';'));
        
        // Get Active Users by Alias
        users = [SELECT Alias FROM USER WHERE IsActive = true AND Alias IN :aliases];
        
        // Store User Id by Alias
        for (User user : users)
            aliasUserId.put(user.Alias, user.Id);
            
        // Iterate thru all tasks where Send FYI is true
        for (Task task : tasks) {
            // Iterate thru the FYI List of Aliases
            for (String alias : task.FYI_List__c.split(';')) {
                // If the Alias does not match an Active User throw error
                if (!aliasUserId.containsKey(alias)) {
                    Trigger.newMap.get(task.Id).FYI_List__c.addError(Label.FYI_List_Invalid_Alias.replace('{0}', alias));
                    break;
                }
                
                // Setup email and add it to email list
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                
                email.setSaveAsActivity(false);
                email.setTemplateId(templateId);
                email.setTargetObjectId(aliasUserId.get(alias));
                email.setWhatId(task.Id);
                
                emails.add(email);
            }
            
            // Set Send FYI to false and update Description with FYI Sent Comment
            task.Send_FYI__c = false;
//            task.Description = Label.FYI_Sent_Comment.replace('{0}', task.FYI_List__c.replace(';', ', ')).replace('{1}', now)
  //              + (task.Description != null ? '\n\n' + task.Description : '');
        }
        
        // Update tasks and send emails
        update tasks;
        Messaging.sendEmail(emails);
    }
}