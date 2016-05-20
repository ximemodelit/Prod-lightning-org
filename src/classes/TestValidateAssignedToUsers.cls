//Test Class for VerifyAssignedToUsers Trigger
@isTest
private class TestValidateAssignedToUsers
    {
        //Prepare and insert data
        static testmethod void insertProcesses()
            {
				Account entity = new Account(
					Name = 'testacc'
				);
				insert entity;
				system.assertNotEquals(entity.Id, null);
				
                //Step 1:
                //Create Process Template
                Process_Template__c objProcessTemplate = new Process_Template__c();
                objProcessTemplate.Name = 'Created by Test Method';
                objProcessTemplate.Category__c = 'Sales';
                objProcessTemplate.Type__c = 'Entity';
                upsert objProcessTemplate;                
                
                //Step 2:
                //Create Process Template Steps with Assigned To User Field Filled
                Process_Template_Step__c step1 = new Process_Template_Step__c();
                step1.Name = 'Step 1';
                step1.Assign_to_User__c = UserInfo.getUserID();
                step1.Process_Template__c = objProcessTemplate.id;
                step1.sequence__c = 1;                
                
                Process_Template_Step__c step2 = new Process_Template_Step__c();
                step2.Name = 'Step 2';
                step2.Assign_to_User__c = UserInfo.getUserID();
                step2.Process_Template__c = objProcessTemplate.id;
                step2.sequence__c = 2;
                
                List<Process_Template_Step__c> lstSteps = new List<Process_Template_Step__c>();
                lstSteps.add(step1);
                lstSteps.add(step2);  
                
                upsert lstSteps;               
                
                //Step 3:
                //Insert Process using the Process Template ID created in Step 1
                Process__c objProcess = new Process__c();
                objProcess.Entity__c = entity.Id;
                objProcess.Auto_Create_Tasks__c = true;
                objProcess.Process_Template__c = objProcessTemplate.id;
                objProcess.Deadline__c = Date.Today();
                
                insert objProcess;
                system.assertNotEquals(objProcess.Id, null);
                
                objProcess.Name = 'Process from Test Method';
                update objProcess;
                
                 Test.StartTest();
                
                //Step 4:
                //Insert Process Step
                Process_Step__c objProcessStep = new Process_Step__c();
                objProcessStep.Name = 'Step from Test Method';
                objProcessStep.Process__c = objProcess.id;
                objProcessStep.Sequence__c = 1;
                insert objProcessStep;
                
                Process_Step__c objProcessStep2 = new Process_Step__c();
                objProcessStep2.Name = 'Step 2 from Test Method';
                objProcessStep2.Process__c = objProcess.id;
                objProcessStep2.Sequence__c = 2;
                insert objProcessStep2;
                system.assertNotEquals(objProcessStep2.Id, null);
                               
                //Update Process Step                
                List<Process_Step__c> lstProcessSteps = new List<Process_Step__c>([Select ID, Name from Process_Step__c WHERE Process__c =: objProcess.ID]);
                update lstProcessSteps;                
                
                Test.StopTest();
            }
    }