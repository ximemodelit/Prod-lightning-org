/*
 * Initial wrapper for the objects
 * @author Ximena Lasserre
 * @since Feb, 2015
 */
public class DataMoverOneObjectWrapper {
	
	public String objApiName{get;set;}
	public String objLabel {get;set;}
	//key: field api name
	public Map<String, DataMoverOneFieldWrapper> objectFields{get;set;} 
	
	/*
	 * Constructor
	 */
	public DataMoverOneObjectWrapper(){
		objectFields = new Map<String, DataMoverOneFieldWrapper>();
	}
	
}