//Helper Class for Validate Template Step Trigger
//Sankalp Shastri    04192011    Created Class

public with sharing class ValidateTemplateStepHelper
    {
    	//Validates the Template Step Name
        public static boolean validateName(boolean isUpdate, Process_Template_Step__c dbTemplateStep, Process_Template_Step__c newTemplateStep)
    		{
		         boolean result = false;
		         if (isUpdate && (newTemplateStep.Process_Template__c != null ))
		         {
		            if (newTemplateStep.Id != dbTemplateStep.Id)
		            {
		                if (newTemplateStep.name == dbTemplateStep.name && newTemplateStep.Process_Template__c == dbTemplateStep.Process_Template__c)
		                {
		                    result = true;
		                }
		            }
		         }
		         else if (newTemplateStep.Process_Template__c != null )
		         {
		            if (newTemplateStep.name == dbTemplateStep.name && newTemplateStep.Process_Template__c == dbTemplateStep.Process_Template__c)
		            {
		                result = true;
		            }
		         }
		         else
		         {
		            if (newTemplateStep.name == dbTemplateStep.name)
		            {
		                result = true;
		            }
		         }
		         return result;
    		}
    	
    	 //Validates the sequence		
    	 public static boolean validateSequence(boolean isUpdate, Process_Template_Step__c dbTemplateStep, Process_Template_Step__c newTemplateStep)
    		{
		         boolean result = false;
		         if (isUpdate && (newTemplateStep.Process_Template__c != null ))
		         {
		            if (newTemplateStep.Id != dbTemplateStep.Id)
		            {
		                if (newTemplateStep.Sequence__c == dbTemplateStep.Sequence__c && newTemplateStep.Process_Template__c == dbTemplateStep.Process_Template__c)
		                {
		                    result = true;
		                }
		            }
		         }
		         else if (newTemplateStep.Process_Template__c != null )
		         {
		            if (newTemplateStep.Sequence__c == dbTemplateStep.Sequence__c && newTemplateStep.Process_Template__c == dbTemplateStep.Process_Template__c)
		            {
		                result = true;
		            }
		         }
		         else
		         {
		            if (newTemplateStep.Sequence__c == dbTemplateStep.Sequence__c)
		            {
		                result = true;
		            }
		         }
		         return result;
    		}	
    }