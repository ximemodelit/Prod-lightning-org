/*
 * Utility class to create the scheduled job and execute it 
 *
 * @author Ximena Lasserre
 * @since Feb 2015
 */
public with sharing class SchedulerUtility {
	
	private static String errorMsg = '';
        
    public static String getErrorMsg() {
        return errorMsg;
    }
    
	/*
     * Generates a cron trigger expression that is used to schedule a new job
     * @return String: The cron expression 
     *///change to private
    public static String getCronTriggerExpression(String frequency, String preferredTime, List<String> weeklyFrequency, 
                                        String monthlyFrequency, String day, String week){
        //Initialize default values for a cron expression
        String cronExpression = '0 0';
        String hours = preferredTime; 
        String dayOfMonth = '?';
        String month = '*';
        String dayOfWeek = '?';     
        
        //If job frequency is Weekly, we must set dayOfWeek 
        if (frequency == 'Weekly'){
            dayOfWeek = String.join(weeklyFrequency,',');
        }else{
            //If job frequency is Monthly, we set dayOfMonth or dayOfWeek depending on the monthly frequency selected  
            if (monthlyFrequency != null && monthlyFrequency != ''){
                dayOfMonth = monthlyFrequency ; 
            }else{
                if (day != null && day != '' && week != null && week != ''){
                	if(week.equals('L')){
                		dayOfWeek = day + week;	
                	}else{
                		dayOfWeek = day+'#'+week;
                	}
                       
                }
            }
        }
  
        //Create the string appending values as follow: seconds minutes hours dayOfMonth month dayOfWeek
        cronExpression += ' ' + hours + ' ' + dayOfMonth + ' ' + month + ' ' + dayOfWeek;
        system.debug('>>>>String cron exp - ' + cronExpression);
        
        return cronExpression;
    }   
    
    
    
    /*
     * This method uses System.schedule to schedule a new job 
     */
    public static Id schedule(String jobName, String frequency, String preferredTime, List<String> weeklyFrequency, String monthlyFrequency, 
                        String day, String week) {
        
        Id jobId = null;
        String jobNameTrimmed = jobName.trim();
        String cronExpression = getCronTriggerExpression(frequency, preferredTime, weeklyFrequency, monthlyFrequency, day, week);
                                                   
        if (jobName != null && cronExpression != null){
            try {
                jobId = system.schedule(jobNameTrimmed, cronExpression, new DataMoverDataMappingScheduledBatch());
            }catch (Exception e) {
            	errorMsg = e.getMessage();
                System.debug('### SchedulerUtility:schedule - An error has ocurred while attempting to schedule a job: ' + e.getMessage());
            }     
        }
        return jobId;
    } 
    
    
}