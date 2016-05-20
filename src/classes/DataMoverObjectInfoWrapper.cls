/*
 * Wrapper to collect the information about the objects
 *
 * @author Ximena Lasserre
 * @since Feb 2015 
 */
public class DataMoverObjectInfoWrapper {
	
	public String sourceApiName {get;set;}
	public String sourceLabel {get;set;}
	public String sourceExtIdField {get;set;}
	public String sourceExtIdFieldType {get;set;} 
	public String sourceExtIdFieldAPI {get;set;}
	public boolean sourceExtIdFieldIsNameField {get;set;} 
	public String targetApiName {get;set;}
	public String targetLabel {get;set;}
	public Mapping_Object__c mappingObjectCreated {get;set;}
	public String targetExtIdField {get;set;}
	public String targetExtIdFieldType {get;set;} 
	public String targetExtIdFieldAPI {get;set;}
	public boolean targetExtIdFieldIsNameField {get;set;}
	public Id mapppingObjectId {get;set;}
	public String jobId {get;set;}
	//the key is target ApiName, they are required when the target field is required
	public Map<String, DataMoverFieldInfoWrapper> allMatchingFieldsRequired {get;set;}
	public Map<String, DataMoverFieldInfoWrapper> allMatchingFieldsNotRequired{get;set;}
	public DataMoverFieldInfoWrapper externalIdFieldMapping {get;set;}
	
	/*
	 * Constructor
	 */
	public DataMoverObjectInfoWrapper(String srcApi, String srcLbl){
		this.sourceApiName = srcApi;
		this.sourceLabel = srcLbl;
		allMatchingFieldsRequired = new Map<String, DataMoverFieldInfoWrapper>();
		allMatchingFieldsNotRequired = new Map<String, DataMoverFieldInfoWrapper>();
		externalIdFieldMapping = new DataMoverFieldInfoWrapper();
	}
	
	/*
	 * Constructor
	 */
	public DataMoverObjectInfoWrapper(){
		allMatchingFieldsRequired = new Map<String,DataMoverFieldInfoWrapper>();
		allMatchingFieldsNotRequired = new Map<String, DataMoverFieldInfoWrapper>();
		externalIdFieldMapping = new DataMoverFieldInfoWrapper();
	}
	
	
}