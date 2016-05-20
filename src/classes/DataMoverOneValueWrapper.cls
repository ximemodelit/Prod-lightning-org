/*
 * Initial wrapper for the values of the fields whose type
 * is picklist or boolean
 * @author Ximena Lasserre
 * @since Feb, 2015
 */
public class DataMoverOneValueWrapper {
	
	public String oneValue {get;set;}
	public String fieldApi {get;set;}
	
	/*
	 * Constructor
	 */
	public DataMoverOneValueWrapper(String val){
		this.oneValue = val;
	}
}