/*
 * Initial wrapper for the fields of the objects
 * @author Ximena Lasserre
 * @since Feb, 2015
 */
public class DataMoverOneFieldWrapper {
	
	public String fieldApiName{get;set;}
	public String fieldLabel {get;set;} 
	public String fieldType {get;set;}
	public String objectApiName {get;set;}
	public boolean isFieldRequired {get;set;}
	public boolean isNameField {get;set;}
	public List<DataMoverOneValueWrapper> listOfValues {get;set;}
	
	/*
	 * Constructor
	 */
	public DataMoverOneFieldWrapper(){
		this.listOfValues = new List<DataMoverOneValueWrapper>();
		this.isNameField = false;
		this.isFieldRequired = false;
	}
	
	
}