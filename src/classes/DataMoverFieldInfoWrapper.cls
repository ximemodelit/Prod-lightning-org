/* 
 * Wrapper for the matching fields
 * @author Ximena Lasserre
 * @since Feb, 2015
 */
public class DataMoverFieldInfoWrapper {
	
	public String srcFieldLbl {get;set;}
	public String srcFieldApiName {get;set;}
	public String srcFieldType {get;set;}
	public boolean srcFieldRequired {get;set;}
	public boolean srcIsNameField {get;set;}
	public String srcObjApi {get;set;}
	public String trgFieldLbl {get;set;}
	public String trgFieldApiName {get;set;}
	public String trgFieldType {get;set;}
	public boolean trgFieldRequired {get;set;}
	public boolean trgIsNameField {get;set;}
	public String trgObjApi {get;set;}
	public Id fieldMappingId {get;set;}
	public Field_Mapping__c fieldMappingCreated {get;set;}
	public List<DataMoverValueInfoWrapper> matchingValues {get;set;}
	public String hasMoreThanOneCheckboxPicklist {get;set;}
	
	/*
	 * Constructor
	 */
	public DataMoverFieldInfoWrapper(){
		this.matchingValues = new List<DataMoverValueInfoWrapper>();
		this.srcFieldRequired = false;
		this.srcIsNameField = false;
		this.trgFieldRequired = false;
		this.trgIsNameField = false;
	}
	
	/*
	 * Checks if the field has any DataMoverValueInfoWrapper object
	 */
	public void checkIfThereAreMoreThanOneCheckboxPicklist(){
		if(srcFieldType != null && trgFieldType != null){
			if((srcFieldType.equals('BOOLEAN') && trgFieldType.equals('BOOLEAN')) ||
			(srcFieldType.equals('PICKLIST') && trgFieldType.equals('BOOLEAN')) ||
			(srcFieldType.equals('PICKLIST') && trgFieldType.equals('PICKLIST')) ||
			(srcFieldType.equals('BOOLEAN') && trgFieldType.equals('PICKLIST'))){
				if(matchingValues != null && matchingValues.size() > 0){
					hasMoreThanOneCheckboxPicklist = 'YES';
				}else{
					hasMoreThanOneCheckboxPicklist = 'NO';
				}
			}
		} 
	}
}