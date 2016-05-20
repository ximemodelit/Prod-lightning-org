/*
 *Utils class for NFP
 *@author Ximena Lasserre
 *@since October 2015
 */
public with sharing class NFPUtils {
    
    public static final String CLIENT_HOUSEHOLD = 'Client Household'; 
    public static final String CLIENT_BUSINESS = 'Client Business'; 
    public static final String COMMERCIAL_INSURANCE = 'Commercial Insurance'; 
    public static final String GROUP_BENEFITS = 'Group Benefits'; 
    public static final String EXECUTIVE_BENEFITS = 'Executive Benefits'; 
    public static final String RETIREMENT_PLANS = 'Retirement Plans'; 
    public static final String INDIVIDUAL_LIFE_INSURANCE = 'Individual Life Insurance'; 
    public static final String INDIVIDUAL_OTHER_INSURANCE = 'Individual Other Insurance'; 
        
    /*
     * Gets the record type of the entity 
     * whose id is passed as a param 
     * @param Id entityId
     * @return String
     */
    public static String getEntityRecordTypeName(Id entityId){
        List<Account> relatedEntity = [SELECT RecordType.Name
                                         FROM Account
                                        WHERE Id = :entityId];
        if(relatedEntity.size() != 0){
            return relatedEntity[0].RecordType.Name;
        }                         
        return '';
    }
    
    
    /*
     * Gets the record type of the entity 
     * whose id is passed as a param 
     * @param Id entityId
     * @return String
     */
    public static Map<Id, String> getEntityRecordTypeNames(Set<Id> entityIds){
        Map<Id,String> result = new Map<Id,String>();
        
        for (Account account : [SELECT RecordType.Name
                                         FROM Account
                                        WHERE Id = :entityIds AND
                                              RecordTypeId != null]){
            result.put(account.Id, account.RecordType.Name);                                
        }     
                         
        return result;
    }
    
    
    public static Map<Id, String> getPotentialRevenueRecordTypes(Set<Id> recordTypeIds){
        Map<Id,String> result = new Map<Id,String>();
        List<RecordTypeInfo> recordTypes = Potential_Revenue__c.SObjectType.getDescribe().getRecordTypeInfos();
        
        if (recordTypes != null && recordTypes.size() > 0){
            for (RecordTypeInfo rt : recordTypes){
                if (rt.isAvailable() && !rt.isMaster()){
                    if (recordTypeIds == null || recordTypeIds.contains(rt.getRecordTypeId())){
                        result.put(rt.getRecordTypeId(), rt.getName());
                    }
                }            
            }
        }
                              
        return result;
    }
    
    
    
    /*
     *Checks if the potentialRevRecordType which is the potential revenue record type
     *is valid for the entity record type (entityRecordType)
     *@param String potentialRevRecordType
     *@param String entityRecordType
     *@return boolean
     */
    public static boolean checkIfPotentialRevenueRecordTypeValid(String potentialRevRecordType, String entityRecordType){
         
        if (potentialRevRecordType == null || potentialRevRecordType == '' || entityRecordType == null || entityRecordType == ''){
            return false;
        }
        
        if(entityRecordType.equalsIgnoreCase(CLIENT_HOUSEHOLD)){
            if(potentialRevRecordType.equalsIgnoreCase(COMMERCIAL_INSURANCE) || 
               potentialRevRecordType.equalsIgnoreCase(EXECUTIVE_BENEFITS) ||
               potentialRevRecordType.equalsIgnoreCase(GROUP_BENEFITS) || 
               potentialRevRecordType.equalsIgnoreCase(RETIREMENT_PLANS)){
                return false;
            }
        }else if(entityRecordType.equalsIgnoreCase(CLIENT_BUSINESS)){
            if(potentialRevRecordType.equalsIgnoreCase(INDIVIDUAL_LIFE_INSURANCE) ||
            potentialRevRecordType.equalsIgnoreCase(INDIVIDUAL_OTHER_INSURANCE)){
                return false;
            }
        }
        
        return true;
    }
    
    /*
     * Insert Potential_Revenue_Fields_Ids__c custom settings 
     * with the corresponding field ids
     */
    public static void insertPotentialRevenueFieldsId(){
        
        //create custom settings
        Potential_Revenue_Fields_Ids__c potentialRevenueCustomSetting = new Potential_Revenue_Fields_Ids__c();
        potentialRevenueCustomSetting.Name = 'Potential_Revenue__c';
        String entityFieldId = ToolingAPIUtils.getFieldId(true, 'Potential_Revenue', 'Entity');
		entityFieldId = entityFieldId != null && !entityFieldId.startsWithIgnoreCase('CF') ? 'CF' + entityFieldId.substring(0,15) : entityFieldId;
        
        potentialRevenueCustomSetting.Entity_c__c = entityFieldId;
                            
        //insert custom settings
        try{
            insert potentialRevenueCustomSetting;
        }catch(Exception ex){
            system.debug('EXCEPTION: Could not insert custom settings: ' + ex.getMessage());
        }   
    }
    
    public static List<RecordType> getRecordTypes(Set<Id> recordTypeIds){
        List<RecordType> result = new List<RecordType>();
        
        if (recordTypeIds != null && recordTypeIds.size() > 0){
            result = [Select Id, Name, Description from RecordType where ID IN : recordTypeIds ORDER BY Name ASC];
        }
        
        return result;
    }
    
    public static String getProfileName(){
        List<Profile> profiles = [Select Id, Name from Profile where Id =: UserInfo.getProfileId()];
        
        if (profiles.size() == 1){
            return profiles[0].Name;
        }
        
        return '';
    }
    
}