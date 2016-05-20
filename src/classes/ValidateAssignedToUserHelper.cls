//Helper class for Validate Assinged To User Trigger
//Changed By        Date        Comments
//Sankalp           04202011    Created the class
public  with sharing class ValidateAssignedToUserHelper
    {
    	//Validate assigned to users
    	public static boolean validate(Set<ID> processIDs, boolean updateProcesses)
    		{
    			// Create List for Process Steps
    			List <Process_Step__c> listProcessStep;
    
    			
    			 // Get the Process Steps    
			    listProcessStep = new List <Process_Step__c>(
			        [SELECT Assigned_To__c, Process__c
			            FROM Process_Step__c
			            WHERE Process__c
			            IN: processIDs AND Process__r.Auto_Create_Tasks__c = true AND Status__c != 'Completed' limit : Limits.getLimitQueryRows()
			        ]
			    );
			    
			    if(listProcessStep.size() > 0)
			    	{
				    // Create Map
				    Map <ID, list<Process_Step__c>> mapProcessStep = new Map <ID, list<Process_Step__c>>();
				    
				    // Loop through and add to Map
				    for(Process_Step__c processStep: listProcessStep)
				        {
				            if(mapProcessStep.containsKey(processStep.Process__c))
				                {
				                    // Add process object in list
				                    List<Process_Step__c> listTemp = mapProcessStep.get(processStep.Process__c);
				                    listTemp.add(processStep);
				                }
				                
				            else
				                {
				                     // Add key with empty list to Map
				                     List<Process_Step__c> listTemp = new List<Process_Step__c>();
				                     listTemp.add(processStep);
				                     mapProcessStep.put(processStep.Process__c,listTemp);
				                }
				         }
				     
				     //Set of proccess IDs to update
				     SET<ID> setProcesses = new SET<ID>();
				     
				     //Check for assigned users
				     for(ID p : processIDs)
				            {              
				            if(mapProcessStep.containsKey(p))
				                {                
					                //Get list from Map                     
					                List<Process_Step__c> listTempProcessStep = mapProcessStep.get(p);
					                for(Process_Step__c processStepValidate : listTempProcessStep)
					                    {
					                        if(processStepValidate.Assigned_To__c == null)
					                            {	
					                                setProcesses.add(p);
					                                break;
					                            } 
					                    }                
				                }
				            }
				   
				   	if(setProcesses.size() > 0)
				   		{				    
					    //Fetch all the processes to be updated
					    List<Process__c> lstUpdateProcesses = new List<Process__c>([Select Auto_Create_Tasks__c from Process__c where ID in : setProcesses LIMIT : Limits.getLimitQueryRows()]);
					                  
					    for(Process__c objPro : lstUpdateProcesses)
					    	{
					    		objPro.Auto_Create_Tasks__c = false;
					    	}              
					            
					    if(updateProcesses)
					    	{              
					    		if (isProcessUpdateable()){
									update lstUpdateProcesses;
								}
					    	}
					    
					    	return false;
					    	
				   		}
				   	else
						{
							return true;						   	
						}		
			    }
			 else
			 	{
			 		return true;
			 	}   
    		}
    		
    		private static Boolean isProcessUpdateable(){
		    	return (Schema.sObjectType.Process__c.isUpdateable() && Process__c.Auto_Create_Tasks__c.getDescribe().isUpdateable());
		    }
    }