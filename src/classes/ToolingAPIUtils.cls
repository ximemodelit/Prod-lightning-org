/*
 *Utils class for the Tooling API
 *@author Ximena Lasserre
 *@since October 2015
 */
global class ToolingAPIUtils {
    
    global static String getFieldId(Boolean isCustomObject, String objectName, String fieldName) {
        String fieldId = null;
        
        if (objectName != null && objectName != '' && fieldName != null && fieldName != '') {
        
            ToolingAPI toolingAPI = new ToolingAPI();
                    
            String tableEnumOrId = null;
            
            // if objectName is a custom object then we need to get objectName's ID
            if (isCustomObject) {
                
                // Get CustomObject Id
                ToolingAPIWSDL.QueryResult result = toolingAPI.query('Select Id From CustomObject Where DeveloperName = \'' + objectName + '\'');
                system.debug('>>>>> result query custom obj ' + result);
                if (result != null) {
                    List<ToolingAPIWSDL.sObject_x> customObjects = result.records;
                
                    if (customObjects != null && customObjects.size() == 1) {
                        tableEnumOrId = customObjects.get(0).Id;
                        system.debug('>>>>> custom object id ' + tableEnumOrId);
                    }               
                }               
            } else {
                tableEnumOrId = objectName; // object is a standard object, thus we use its enum value
            }
            
            if (tableEnumOrId != null) {
                
                // Get custom field Id
                ToolingAPIWSDL.QueryResult result = toolingAPI.query('Select Id, DeveloperName, TableEnumOrId From CustomField Where DeveloperName = \'' + fieldName + '\' and TableEnumOrId = \'' + tableEnumOrId + '\''); 
                
                if (result != null) {
                    List<ToolingAPIWSDL.sObject_x> customFields = result.records;
                
                    if (customFields != null && customFields.size() == 1) {
                        fieldId = customFields.get(0).Id;   
                    }
                }
            }
        }
         
        return fieldId;   
    }       
}