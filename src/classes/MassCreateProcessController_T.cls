/**
 * This class contains unit tests for validating the behavior of MassCreateProcessController.cls
 */
@isTest
private class MassCreateProcessController_T {

    private static void initData(){
        //Insert accounts
        List<Account> accounts = new List<Account>();
        accounts.add(TestUtility.createAccount('Edhasa'));
        accounts.add(TestUtility.createAccount('Century'));
        accounts.add(TestUtility.createAccount('Ediciones Peninsula'));
        insert accounts;
        
        //Verify accounts were inserted
        System.assertNotEquals(accounts.get(0).Id, null);
        System.assertNotEquals(accounts.get(1).Id, null);
        System.assertNotEquals(accounts.get(2).Id, null);
        
        //Insert contacts
        List<Contact> contacts = new List<Contact>();
        contacts.add(TestUtility.createContact('Edward', 'Rutherfurd'));
        contacts.add(TestUtility.createContact('Patrick', 'Ackroyd'));
        contacts.add(TestUtility.createContact('Eric', 'Gonzalez'));
        insert contacts;
        
        //Verify contacts were inserted
        System.assertNotEquals(contacts.get(0).Id, null);
        System.assertNotEquals(contacts.get(1).Id, null);
        System.assertNotEquals(contacts.get(2).Id, null);
        
        //Insert cases
        List<Case> cases = new List<Case>();
        cases.add(TestUtility.createCase('Open', 'Web'));
        cases.add(TestUtility.createCase('Open', 'Web'));
        cases.add(TestUtility.createCase('Open', 'Web'));
        insert cases;
        
        //Verify cases were inserted
        System.assertNotEquals(cases.get(0).Id, null);
        System.assertNotEquals(cases.get(1).Id, null);
        System.assertNotEquals(cases.get(2).Id, null);
        
       //Insert Leads
       List<Lead> leads = new List<Lead>();
       leads.add(TestUtility.createLead('Angelica', 'Buffa', 'Test Co', 'Open'));
       leads.add(TestUtility.createLead('Clarisa', 'Zin', 'Another Test Co', 'Open'));
       leads.add(TestUtility.createLead('Ana', 'Buffa', 'My Test Co', 'Open'));
       insert leads;
        
        //Verify leads were inserted
        System.assertNotEquals(leads.get(0).Id, null);
        System.assertNotEquals(leads.get(1).Id, null);
        System.assertNotEquals(leads.get(2).Id, null);
        
        //Insert Opportunities
        List<Opportunity> opportunities = new List<Opportunity>();
        opportunities.add(TestUtility.createOpportunity('Oppt1', System.today(), '1'));
        opportunities.add(TestUtility.createOpportunity('Oppt2', System.today(), '1'));
        opportunities.add(TestUtility.createOpportunity('Oppt3', System.today(), '1'));
        insert opportunities;
        
        //Verify oppties were inserted
        System.assertNotEquals(opportunities.get(0).Id, null);
        System.assertNotEquals(opportunities.get(1).Id, null);
        System.assertNotEquals(opportunities.get(2).Id, null);
        
        //Insert process Templates
        List<Process_Template__c> templates = new List<Process_Template__c>();
        templates.add(TestUtility.createProcessTemplate('Account template sample 1', 'Entity'));
        templates.add(TestUtility.createProcessTemplate('Account template sample 2', 'Entity'));
        templates.add(TestUtility.createProcessTemplate('Lead template sample 1', 'Lead'));
        templates.add(TestUtility.createProcessTemplate('Lead template sample 2', 'Lead'));
        templates.add(TestUtility.createProcessTemplate('Contact template sample 1', 'Contact'));
        templates.add(TestUtility.createProcessTemplate('Contact template sample 2', 'Contact'));
        templates.add(TestUtility.createProcessTemplate('Opportunity template sample 1', 'Opportunity'));
        templates.add(TestUtility.createProcessTemplate('Opportunity template sample 2', 'Opportunity'));
        templates.add(TestUtility.createProcessTemplate('Case template sample 1', 'Case'));
        templates.add(TestUtility.createProcessTemplate('Case template sample 2', 'Case'));
        insert templates;
        
        //Verify templates were inserted
        System.assertNotEquals(templates.get(0).Id, null);
        System.assertNotEquals(templates.get(1).Id, null);
        System.assertNotEquals(templates.get(2).Id, null);
        System.assertNotEquals(templates.get(3).Id, null);
        System.assertNotEquals(templates.get(4).Id, null);
        System.assertNotEquals(templates.get(5).Id, null);
        System.assertNotEquals(templates.get(6).Id, null);
        System.assertNotEquals(templates.get(7).Id, null);
        System.assertNotEquals(templates.get(8).Id, null);
        System.assertNotEquals(templates.get(9).Id, null);
        
        //insert 1000 steps for each template
        List<Process_Template_Step__c> steps = new List<Process_Template_Step__c>();
        for (Integer i = 0; i < 50; i++){
            steps.add(new Process_Template_Step__c(Name = 'Account Step' + i, Assign_To_User__c = null, Assign_To_Role__c = 'Primary Advisor', Process_Template__c = templates.get(0).Id, Sequence__c = 1 ));
            steps.add(new Process_Template_Step__c(Name = 'Lead Step ' + i, Assign_To_User__c = null, Assign_To_Lead_Role__c = 'Lead Role', Process_Template__c = templates.get(2).Id, Sequence__c = 1 ));
            steps.add(new Process_Template_Step__c(Name = 'Cotact Step ' + i, Assign_To_User__c = UserInfo.getUserId(), Assign_To_Contact_Role__c = '', Process_Template__c = templates.get(4).Id, Sequence__c = 1 ));
            steps.add(new Process_Template_Step__c(Name = 'Opportunity Step ' + i, Assign_To_User__c = null, Assign_To_Opportunity_Role__c = 'Opportunity Role', Process_Template__c = templates.get(6).Id, Sequence__c = 1 ));
            steps.add(new Process_Template_Step__c(Name = 'Case Step ' + i, Assign_To_User__c = null, Assign_To_Case_Role__c = 'Case Role', Process_Template__c = templates.get(8).Id, Sequence__c = 1 ));          
        }
        
        insert steps;
        
        //Verify steps were inserted
        System.assertEquals([Select Id from Process_Template_Step__c].size(), 250);
    }
    
    private static void initData2(){
        //Insert accounts
        List<Account> accounts = new List<Account>();
        accounts.add(TestUtility.createAccount('Edhasa'));
        accounts.add(TestUtility.createAccount('Century'));
        accounts.add(TestUtility.createAccount('Ediciones Peninsula'));
        insert accounts;
        
        //Verify accounts were inserted
        System.assertNotEquals(accounts.get(0).Id, null);
        System.assertNotEquals(accounts.get(1).Id, null);
        System.assertNotEquals(accounts.get(2).Id, null);
        
        //Insert contacts
        List<Contact> contacts = new List<Contact>();
        contacts.add(TestUtility.createContact('Edward', 'Rutherfurd'));
        contacts.add(TestUtility.createContact('Patrick', 'Ackroyd'));
        contacts.add(TestUtility.createContact('Eric', 'Gonzalez'));
        insert contacts;
        
        //Verify contacts were inserted
        System.assertNotEquals(contacts.get(0).Id, null);
        System.assertNotEquals(contacts.get(1).Id, null);
        System.assertNotEquals(contacts.get(2).Id, null);
        
        //Insert cases
        List<Case> cases = new List<Case>();
        cases.add(TestUtility.createCase('Open', 'Web'));
        cases.add(TestUtility.createCase('Open', 'Web'));
        cases.add(TestUtility.createCase('Open', 'Web'));
        insert cases;
        
        //Verify cases were inserted
        System.assertNotEquals(cases.get(0).Id, null);
        System.assertNotEquals(cases.get(1).Id, null);
        System.assertNotEquals(cases.get(2).Id, null);
        
       //Insert Leads
       List<Lead> leads = new List<Lead>();
       leads.add(TestUtility.createLead('Angelica', 'Buffa', 'Test Co', 'Open'));
       leads.add(TestUtility.createLead('Clarisa', 'Zin', 'Another Test Co', 'Open'));
       leads.add(TestUtility.createLead('Ana', 'Buffa', 'My Test Co', 'Open'));
       insert leads;
        
        //Verify leads were inserted
        System.assertNotEquals(leads.get(0).Id, null);
        System.assertNotEquals(leads.get(1).Id, null);
        System.assertNotEquals(leads.get(2).Id, null);
        
        //Insert Opportunities
        List<Opportunity> opportunities = new List<Opportunity>();
        opportunities.add(TestUtility.createOpportunity('Oppt1', System.today(), '1'));
        opportunities.add(TestUtility.createOpportunity('Oppt2', System.today(), '1'));
        opportunities.add(TestUtility.createOpportunity('Oppt3', System.today(), '1'));
        insert opportunities;
        
        //Verify oppties were inserted
        System.assertNotEquals(opportunities.get(0).Id, null);
        System.assertNotEquals(opportunities.get(1).Id, null);
        System.assertNotEquals(opportunities.get(2).Id, null);
        
        //Insert process Templates
        List<Process_Template__c> templates = new List<Process_Template__c>();
        templates.add(TestUtility.createProcessTemplate('Account template sample 1', 'Entity'));
        templates.add(TestUtility.createProcessTemplate('Account template sample 2', 'Entity'));
        templates.add(TestUtility.createProcessTemplate('Lead template sample 1', 'Lead'));
        templates.add(TestUtility.createProcessTemplate('Lead template sample 2', 'Lead'));
        templates.add(TestUtility.createProcessTemplate('Contact template sample 1', 'Contact'));
        templates.add(TestUtility.createProcessTemplate('Contact template sample 2', 'Contact'));
        templates.add(TestUtility.createProcessTemplate('Opportunity template sample 1', 'Opportunity'));
        templates.add(TestUtility.createProcessTemplate('Opportunity template sample 2', 'Opportunity'));
        templates.add(TestUtility.createProcessTemplate('Case template sample 1', 'Case'));
        templates.add(TestUtility.createProcessTemplate('Case template sample 2', 'Case'));
        insert templates;
        
        //Verify templates were inserted
        System.assertNotEquals(templates.get(0).Id, null);
        System.assertNotEquals(templates.get(1).Id, null);
        System.assertNotEquals(templates.get(2).Id, null);
        System.assertNotEquals(templates.get(3).Id, null);
        System.assertNotEquals(templates.get(4).Id, null);
        System.assertNotEquals(templates.get(5).Id, null);
        System.assertNotEquals(templates.get(6).Id, null);
        System.assertNotEquals(templates.get(7).Id, null);
        System.assertNotEquals(templates.get(8).Id, null);
        System.assertNotEquals(templates.get(9).Id, null);
        
        //insert 1000 steps for each template
        List<Process_Template_Step__c> steps = new List<Process_Template_Step__c>();
        for (Integer i = 0; i < 50; i++){
            steps.add(new Process_Template_Step__c(Name = 'Account Step' + i, Assign_To_User__c = null, Assign_To_Role__c = 'Primary Advisor', Process_Template__c = templates.get(0).Id, Sequence__c = 1 ));
            steps.add(new Process_Template_Step__c(Name = 'Lead Step ' + i, Assign_To_User__c = null, Assign_To_Lead_Role__c = 'Lead Role', Process_Template__c = templates.get(2).Id, Sequence__c = 1 ));
            steps.add(new Process_Template_Step__c(Name = 'Cotact Step ' + i, Assign_To_User__c = UserInfo.getUserId(), Assign_To_Contact_Role__c = '', Process_Template__c = templates.get(4).Id, Sequence__c = 1 ));
            steps.add(new Process_Template_Step__c(Name = 'Opportunity Step ' + i, Assign_To_User__c = null, Assign_To_Opportunity_Role__c = 'Opportunity Role', Process_Template__c = templates.get(6).Id, Sequence__c = 1 ));
            steps.add(new Process_Template_Step__c(Name = 'Case Step ' + i, Assign_To_User__c = null, Assign_To_Case_Role__c = 'Case Role', Process_Template__c = templates.get(8).Id, Sequence__c = 1 ));          
        }
        
        insert steps;
        
        //Verify steps were inserted
        System.assertEquals([Select Id from Process_Template_Step__c].size(), 250);
    }
    
    static testMethod void testMassCreateAccountProcess() {
        initData();
        List<Account> accounts = [Select id from Account];          
        System.assertEquals(accounts.size(), 3);
        
        //Reinstantiate the controller
        ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(accounts);
        ssc.setSelected(accounts);
        
        MassCreateProcessController controller = new MassCreateProcessController(ssc);
        
        //Verify there isn't an error
        System.assertEquals(controller.errors.size(), 0);
        
        //Verify records were selected
        System.assertEquals(controller.RecordsAreSelected, true);
        System.assertEquals(controller.RecordCount, 3);
        
        //Get the process templates
        List<SelectOption> templates = controller.TemplateSelectOptions;
        
        //There should be 2 templates
        System.assertEquals(templates.size(),2);
        System.assertEquals(templates.get(0).getLabel(), 'Account template sample 1');
        System.assertEquals(templates.get(1).getLabel(), 'Account template sample 2');
        
        controller.SelectedTemplateId = templates.get(0).getValue();
        controller.deadline = system.today().addDays(5).month() + '/' + system.today().addDays(5).day() + '/' + system.today().addDays(5).year();
        controller.createProcesses();
        
        // Verify that there weren't any errors
        System.assertEquals(controller.errors.size(), 0);
        
        //Verify process were inserted
        List<Process__c> processes = [Select Id from Process__c];
        System.assertEquals(processes.size(), 3);
        controller.cancel();
        
    }
    
    static testMethod void testMassCreateAccountProcessWithSteps() {
        initData2();
        List<Account> accounts = [Select id, Primary_Advisor__c from Account];          
        System.assertEquals(accounts.size(), 3);
        
        //Update accounts set account administrator
        for (Account a : accounts){
            a.Primary_Advisor__c = UserInfo.getUserId();
        }
        
        update accounts;
        
        //Reinstantiate the controller
        ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(accounts);
        ssc.setSelected(accounts);
        
        MassCreateProcessController controller = new MassCreateProcessController(ssc);
        
        //Verify there isn't an error
        System.assertEquals(ApexPages.getMessages().size(), 0);
        
        //Verify records were selected
        System.assertEquals(controller.RecordsAreSelected, true);
        System.assertEquals(controller.RecordCount, 3);
        
        //Get the process templates
        List<SelectOption> templates = controller.TemplateSelectOptions;
        
        //There should be 2 templates
        System.assertEquals(templates.size(),2);
        System.assertEquals(templates.get(0).getLabel(), 'Account template sample 1');
        System.assertEquals(templates.get(1).getLabel(), 'Account template sample 2');
        
        controller.SelectedTemplateId = templates.get(0).getValue();
        controller.deadline = system.today().addDays(5).month() + '/' + system.today().addDays(5).day() + '/' + system.today().addDays(5).year();
        controller.createProcesses();

        //Verify process were inserted
        List<Process_Step__c> processSteps = [Select Id from Process_Step__c];
        System.assertEquals(processSteps.size(), 150);
        List<Process__c> processes = [Select Id, (Select Id from Process_Steps__r where Assigned_To__c =: UserInfo.getUserId()) from Process__c];
        System.assertEquals(processes.size(), 3);
        
        //Verify steps were inserted
        System.assertEquals(processes.get(0).Process_Steps__r.size(), 50);
        System.assertEquals(processes.get(1).Process_Steps__r.size(), 50);
        System.assertEquals(processes.get(2).Process_Steps__r.size(), 50);
        
        controller.cancel();
    
    }
    
    static testMethod void testMassCreateAccountProcessErrors() {
        initData();
        List<Account> accounts = [Select id, Primary_Advisor__c from Account];          
        System.assertEquals(accounts.size(), 3);
        
        //Reinstantiate the controller
        ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(new List<Account>());
        ssc.setSelected(new List<Account>());

        MassCreateProcessController controller = new MassCreateProcessController(ssc);
        
        //Verify there's an error because no accounts were selected
        System.assertEquals(controller.errors.size(), 1);
        System.assertEquals(ApexPages.getMessages().size(), 1);
        System.assertEquals(ApexPages.getMessages().get(0).getDetail(), 'Please select at least one record');
        
        //Verify records were not selected
        System.assertEquals(controller.RecordsAreSelected, false);
        System.assertEquals(controller.RecordCount, 0);
        
        ssc = new ApexPages.StandardSetController(new List<Account>());
        ssc.setSelected(accounts);
        
        controller = new MassCreateProcessController(ssc);
        
        //Get the process templates
        List<SelectOption> templates = controller.TemplateSelectOptions;
        
        //There should be 2 templates
        System.assertEquals(templates.size(),2);
        System.assertEquals(templates.get(0).getLabel(), 'Account template sample 1');
        System.assertEquals(templates.get(1).getLabel(), 'Account template sample 2');
        
        
        controller.SelectedTemplateId = templates.get(0).getValue();
        controller.deadline = null;
        controller.createProcesses();
        
        // Verify that there were errors
        System.assertEquals(controller.errors.size(), 1);
        System.assertEquals(controller.errors.get(0), 'Please enter the Deadline. ');
        
    }
    
    static testMethod void testMassCreateContactProcess() {
        initData();
        List<Contact> contacts = [Select id from Contact];          
        System.assertEquals(contacts.size(), 3);
        
        //Reinstantiate the controller
        ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(contacts);
        ssc.setSelected(contacts);
        
        MassCreateProcessController controller = new MassCreateProcessController(ssc);
        
        //Verify there isn't an error
        System.assertEquals(controller.errors.size(), 0);
        
        //Verify records were selected
        System.assertEquals(controller.RecordsAreSelected, true);
        System.assertEquals(controller.RecordCount, 3);
        
        //Get the process templates
        List<SelectOption> templates = controller.TemplateSelectOptions;
        
        //There should be 2 templates
        System.assertEquals(templates.size(),2);
        System.assertEquals(templates.get(0).getLabel(), 'Contact template sample 1');
        System.assertEquals(templates.get(1).getLabel(), 'Contact template sample 2');
        
        controller.SelectedTemplateId = templates.get(0).getValue();
        controller.deadline = system.today().addDays(5).month() + '/' + system.today().addDays(5).day() + '/' + system.today().addDays(5).year();
        controller.createProcesses();

        // Verify that there weren't any errors
        System.assertEquals(controller.errors.size(), 0);
        
        //Verify process were inserted
        List<Process__c> processes = [Select Id from Process__c];
        System.assertEquals(processes.size(), 3);
        controller.cancel();
        
    }
    
    static testMethod void testMassCreateContactProcessWithSteps() {
        initData2();
        List<Contact> contacts = [Select id from Contact];          
        System.assertEquals(contacts.size(), 3);
        
        
        //Reinstantiate the controller
        ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(contacts);
        ssc.setSelected(contacts);
        
        MassCreateProcessController controller = new MassCreateProcessController(ssc);
        
        //Verify there isn't an error
        System.assertEquals(ApexPages.getMessages().size(), 0);
        
        //Verify records were selected
        System.assertEquals(controller.RecordsAreSelected, true);
        System.assertEquals(controller.RecordCount, 3);
        
        //Get the process templates
        List<SelectOption> templates = controller.TemplateSelectOptions;
        
        //There should be 2 templates
        System.assertEquals(templates.size(),2);
        System.assertEquals(templates.get(0).getLabel(), 'Contact template sample 1');
        System.assertEquals(templates.get(1).getLabel(), 'Contact template sample 2');
        
        controller.SelectedTemplateId = templates.get(0).getValue();
        controller.deadline = system.today().addDays(5).month() + '/' + system.today().addDays(5).day() + '/' + system.today().addDays(5).year();
        controller.createProcesses();

        //Verify process were inserted
        List<Process_Step__c> processSteps = [Select Id from Process_Step__c];
        System.assertEquals(processSteps.size(), 150);
        List<Process__c> processes = [Select Id, (Select Id from Process_Steps__r where Assigned_To__c =: UserInfo.getUserId()) from Process__c];
        System.assertEquals(processes.size(), 3);
        
        //Verify steps were inserted
        System.assertEquals(processes.get(0).Process_Steps__r.size(), 50);
        System.assertEquals(processes.get(1).Process_Steps__r.size(), 50);
        System.assertEquals(processes.get(2).Process_Steps__r.size(), 50);
        
        controller.cancel();
        
    }
    
    static testMethod void testMassCreateContactProcessErrors() {
        initData();
        List<Contact> contacts = [Select id from Contact];          
        System.assertEquals(contacts.size(), 3);
        
        //Reinstantiate the controller
        ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(new List<Contact>());
        ssc.setSelected(new List<Contact>());
        
        MassCreateProcessController controller = new MassCreateProcessController(ssc);
        
        //Verify there's an error because no accounts were selected
        System.assertEquals(controller.errors.size(), 1);
        System.assertEquals(ApexPages.getMessages().size(), 1);
        System.assertEquals(ApexPages.getMessages().get(0).getDetail(), 'Please select at least one record');
        
        //Verify records were not selected
        System.assertEquals(controller.RecordsAreSelected, false);
        System.assertEquals(controller.RecordCount, 0);
        
        ssc = new ApexPages.StandardSetController(contacts);
        ssc.setSelected(contacts);
        
        controller = new MassCreateProcessController(ssc);
        
        //Get the process templates
        List<SelectOption> templates = controller.TemplateSelectOptions;
        
        //There should be 2 templates
        System.assertEquals(templates.size(),2);
        System.assertEquals(templates.get(0).getLabel(), 'Contact template sample 1');
        System.assertEquals(templates.get(1).getLabel(), 'Contact template sample 2');
        
        
        controller.SelectedTemplateId = templates.get(0).getValue();
        controller.deadline = null;
        controller.createProcesses();
        
        // Verify that there were errors
        System.assertEquals(controller.errors.size(), 1);
        System.assertEquals(controller.errors.get(0), 'Please enter the Deadline. ');
        
    }
}