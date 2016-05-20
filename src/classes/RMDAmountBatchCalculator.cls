/* This class Implements Batchable and is used to calculate the RMD Amount for a subset of 
 * RMD requirements that match a given year 
 * @author Angelica Buffa
 * @since March 2015
 */
public with sharing class RMDAmountBatchCalculator implements
		Database.Batchable<sObject>, Database.Stateful{
	
	// Private instance variables	
	private String  year { get; set; }
	private Database.saveResult[] databaseResults {get;set;}
	private Integer numberOfSuccess {get;set;}
	private Integer numberOfErrors {get;set;}
	private Integer totRequirements {get;set;}	
	
	//datetime the batch was executed
	public Datetime executedDate {get;set;}
	
	// Constructor
	public RMDAmountBatchCalculator(String year){
		this.year = year;
		numberOfSuccess = 0;
		numberOfErrors = 0;
		totRequirements = 0;
	}
	
  	public Database.QueryLocator start(Database.BatchableContext BC){
  		
        DateTime executedDateGMT = datetime.now();
        Date d = executedDateGMT.date();
        Time t = executedDateGMT.time();
        executedDate = Datetime.newInstance(d,t);
    
      	return Database.getQueryLocator([SELECT RMD_Calculated__c, 
      											Value_Previous_EOY__c, 
      											RMD_Year__c, 
      											RMD_Factor__c, 
												RMD_Calculation_Method__c,
									   			RMD_Spouse_Age_EOY__c,
									   			RMD_Member_Age_EOY__c
										FROM RMD_Requirement__c 
										WHERE RMD_Year__c = :year]);
   	}

   	public void execute(Database.BatchableContext BC, List<RMD_Requirement__c> rmdRequirements){
   		if(rmdRequirements != null){ 
	     	List<RMD_Factors__c> rmdFactors = RMDCalculatorUtils.getRMDFactors(rmdRequirements);
			databaseResults = RMDCalculatorUtils.calculateRMDAmount(rmdFactors, rmdRequirements, executedDate);
			//add the total amount of requirements to the previous quantity
			totRequirements += rmdRequirements.size();
			//add the successes to numberOfSuccess
	   		if(databaseResults != null && databaseResults.size() > 0){
	   			for(Database.saveResult result : databaseResults){
		   			if(result.isSuccess()){
		   				numberOfSuccess++;
		   			}
		   		}
   			}	
   		}
    }

   	public void finish(Database.BatchableContext BC){
   		
   		if(totRequirements > numberOfSuccess){
   			numberOfErrors = totRequirements - numberOfSuccess;
   		}
   		RMDCalculatorUtils.sendNotification(UserInfo.getUserId(), numberOfErrors, numberOfSuccess, year, executedDate);	
   	}
}