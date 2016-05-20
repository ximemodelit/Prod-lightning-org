/**
 * Wrapper for class DataMoverDataMappingBatch
 *@author Ximena Lasserre
 *@since 2014-12
 */
public class DataMoverDataMappingWrapper {
	
	public SObject sourceObject {get; set;}
	public SObject targetObject {get; set;}
	
	
	public DataMoverDataMappingWrapper(SObject srcObj, SObject trgObj){
		sourceObject = srcObj;
		targetObject = trgObj;
	}
	
	/*
	 * Populates the lookup field referencing the target obj on the source obj
	 * with the id from the target object
	 */
	public void updateSourceLookupWithTargetId(){
		
		Map<String,Schema.SObjectField> sFields = sourceObject.getSObjectType().getDescribe().fields.getMap();
		String trgtObjApiName = String.valueOf(targetObject.getSObjectType());
		
		for(String s : sFields.keySet()){			
			for(Schema.sObjectType sType : sFields.get(s).getDescribe().getReferenceTo()){
				if(String.valueOf(sType) == trgtObjApiName){
					sourceObject.put(s, targetObject.get('Id'));
				}
			}			
		}		
	}
}