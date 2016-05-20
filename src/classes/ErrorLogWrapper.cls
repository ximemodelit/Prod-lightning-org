/*
 * Wrapper to store the error log info from the batch ran by the job 
 * @author Ximena Lasserre
 * @since Apr 2015
 */
public with sharing class ErrorLogWrapper {
	
	public DateTime createdDate {get;set;}
	public String errorDescription {get;set;}
	public String status {get;set;}
	public String sourceObj {get;set;}
	public String targetObj {get;set;}
	public String valueOfObjectExtId {get;set;}

	public ErrorLogWrapper(){
		this.createdDate = Datetime.newInstance(Datetime.now().Date(), Datetime.now().Time());
	}
	
	public ErrorLogWrapper(String message, String errStatus, String src, String trg, String valueOfExtId){
		this.createdDate = Datetime.newInstance(Datetime.now().Date(), Datetime.now().Time());
		this.errorDescription = message;
		this.status = errStatus;
		this.sourceObj = src;
		this.targetObj = trg;
		this.valueOfObjectExtId = valueOfExtId;
	}
		
}