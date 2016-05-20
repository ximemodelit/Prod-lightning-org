/*
 * Wrapper to store the log info from the batch ran by the job 
 * @author Ximena Lasserre
 * @since Apr 2015
 */
public with sharing class JobLogWrapper {
	
	public Integer nrOfRecords {get;set;}
	public Datetime startDateTime {get;set;}
	public Data_Mover_Scheduled_Job__c scheduledJob {get;set;}
	public List<ErrorLogWrapper> errorLogs {get;set;}
	
	/*
	 * Constructor
	 */
	public JobLogWrapper(){
		nrOfRecords = 0;
		DateTime executedDateGMT = datetime.now();
        Date d = executedDateGMT.date();
        Time t = executedDateGMT.time();
        startDateTime = Datetime.newInstance(d,t);
		errorLogs = new List<ErrorLogWrapper>();
	}
}