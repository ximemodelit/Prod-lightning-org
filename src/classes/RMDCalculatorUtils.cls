/* This class contains methods to calculate the RMD amount for a single Asset & Liability and year, 
 * or for a specific year. Look Planio ticket #768 for requirements specification.
 * @author Angelica Buffa
 * @since March 2015
 */
public with sharing class RMDCalculatorUtils {
	
	// Constants
	private static final String EMAIL_TEMPLATE_NAME = 'RMD_Calculator_Notification';
	
	/* This method returns the RMD Factors needed to calculate the RMD Amount for a subset of Requirements
	 * To get the factors: Look for the row in the RMD Factors table where these fields are equal
	 * RMD Requirement Table	RMD Factor Table
	 * RMD Calculation Method	Calculation Type
	 * RMD Member Age EOY	    Age EOY
	 * RMD Spouse Age EOY	    Age EOY 2 
	 * @param requirements
	 * return list of RMD_Factors__c
	 */
	public static List<RMD_Factors__c> getRMDFactors(List<RMD_Requirement__c> requirements){
		List<RMD_Factors__c> factors = new List<RMD_Factors__c>();
		Set<Decimal> memberAges = new Set<Decimal>();
		Set<Decimal> spouseAges = new Set<Decimal>();
		Set<String> calculationTypes = new Set<String>();
		
		if (requirements != null){
				
			for (RMD_Requirement__c requirement : requirements){
				calculationTypes.add(requirement.RMD_Calculation_Method__c);
				memberAges.add(requirement.RMD_Member_Age_EOY__c);
				spouseAges.add(requirement.RMD_Spouse_Age_EOY__c);
			}
			// Fetch the factors for the member ages, spouse ages, and calculation types 
			// This query may return rows that do not match the exact same combination of member age,
			// spouse age, and calculation method present in the requirements list. But the code will address that
			// when calculating the RMD Amount
		
			factors = [SELECT Age_EOY__c,
							  Age_EOY_2__c, 
							  Calculation_Type__c, 
							  RMD_Factor__c
						FROM RMD_Factors__c 
					   WHERE Age_EOY__c IN : memberAges AND
							 Age_EOY_2__c IN : spouseAges AND
							 Calculation_Type__c IN : calculationTypes];
		}
		system.debug('factors ' + factors.size());
		return factors;
	}
	
	/* This method returns the list of requirements related to a financial account for a given year
	 * @param assetId Id of the Financial Account
	 * @year
	 * @return list of RMD Requirement objects
	 */
	public static List<RMD_Requirement__c> getFinacialAccountsRMDRequirements(Id assetId, String year){
		List<RMD_Requirement__c> requirements = new List<RMD_Requirement__c>();
		
		if (assetId != null && year != null ){
				
				requirements = [Select Id, Name,
									   Financial_Account__c, 
									   RMD_Calculated__c, 
									   Value_Previous_EOY__c, 
 									   RMD_Year__c, 
									   RMD_Factor__c, 
									   RMD_Calculation_Method__c, 
									   RMD_Spouse_Age_EOY__c,
									   RMD_Member_Age_EOY__c
							From RMD_Requirement__c 
							Where Financial_Account__c =: assetId AND
								   RMD_Year__c =: year AND
								   Value_Previous_EOY__c != NULL];
		}
		
		return requirements;
	}
	
	/* This method calculates the RMD Amount for a subset of RMD Requirement records
	 * @param factors list of factors where the RMD factor will be extracted from
	 * @param requirements list of requirements that must be updated
	 */
	public static Database.saveResult[] calculateRMDAmount(List<RMD_Factors__c> factors, List<RMD_Requirement__c> requirements, Datetime executedDate){
		
		RmdCalcuatedAmountUtils utils = new RmdCalcuatedAmountUtils();
		return utils.calculateRmdAmount(factors, requirements, executedDate);
		
	}
	
	
	/*
     * This method sends email
     * @param emailAddress recipient's email address
     * @return -
    */
    public static void sendNotification(String adminUserId, Integer nrErrors, Integer nrSuccess, String selectedYear, Datetime executedDate){
    	if (adminUserId != null){
    		
    		//create the date parameter 
			String dateParam = executedDate.format('MM/dd/yyyy hh:mm a');
			String environmentURL = URL.getSalesforceBaseUrl().toExternalForm() + '/';
    		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    		mail.setTargetObjectId(adminUserId);
    		mail.setSubject('RMD Batch Calculation Completed for ' + selectedYear);
		    mail.saveAsActivity = false;
		    String htmlBody = '<h3>Information about batch executed on ' + dateParam +
		        	' for RMD Year ' + selectedYear + ':</h3>';
		    		
    		if(nrErrors > 0 || nrSuccess > 0){
    			
    			//get reports ids	    		
				String successReportId = getReport('RMD Batch Calculation Success Report'); 
				String failReportId = getReport('RMD Batch Calculation Error Report'); 
						        
		        htmlBody += '<h3>Total RMD records: '+ (nrSuccess + nrErrors) + '</h3>' +
		        	'<h3><u>Successful records</u></h3>' +
	    			'<p>There were ' + nrSuccess + ' successfuly updated record(s).</p>';
	    		if(nrSuccess > 0){
	    			htmlBody += '<p>Please click <a href=\'' + environmentURL + successReportId +'?pv0=' +
	    			selectedYear + '&pv1=' + dateParam +'\'>here</a>' +
	    			' for the RMD Batch Calculation Success Report.</p></div></div>';
	    		}	
	    		htmlBody +=	'<h3><u>Failed records</u></h3>' +
	    			'<p>There were ' + nrErrors + ' failed record(s).</p>';
	    		if(nrErrors > 0){	
	    			htmlBody += '<p>Please click <a href=\'' + environmentURL + failReportId +'?pv0=' +
	    			selectedYear + '&pv1=' + dateParam +'\'>here</a>' +
	    			' for the RMD Batch Calculation Error Report.</p></div></div>';
	    		}	
    		}else{
    			htmlBody += '<p>There were no records for the selected year.</p></div></div>';
    		}
			mail.setHtmlBody(htmlBody);
			
			try{
	            Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{mail});
	        }catch (Exception ex){ 
	        	system.debug('>>>>>>>>>>>>> ex ' + ex.getMessage());	
	        }	
    	}
    }
    
    public static boolean scheduleBatch(String year){
    	Boolean result = true;
    	String batchName = 'RMD Calculator ' + system.now();
    	try{
    		System.scheduleBatch(new RMDAmountBatchCalculator(year), batchName, 1);
    	}catch(Exception ex){
    		result = false;
    	}
    	return result;
    }
    
    /*
     * Returns the Id of the report whose name is passed
     * as an argument
     * @param String nameOfReport: name of the report whose id I want
     * @return String: Id as string
     */
    private static String getReport(String nameOfReport){
    	List<Report> listOfReport = [SELECT Id
    								   FROM Report
    								  WHERE Name = :nameOfReport LIMIT 1];
    	if(listOfReport.size() > 0){
    		return listOfReport[0].Id;
    	}
    	else{
    		return null;
    	}
    }
    
    public static boolean validateYear(String strYear){
    	Integer numericYear = 0;
    	
    	try{
    		numericYear = Integer.valueOf(strYear);
    	}catch(Exception ex){
    		
    	}
    	
    	return numericYear > 2000 && numericYear <= system.today().year();
    }
    
}