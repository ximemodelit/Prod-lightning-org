/*
 *Controller class for NFPPotentialRevenueRecordTypes
 *
 *@author Ximena Lasserre
 *@since September 2015
 */
public with sharing class NFPPotentialRevenueRecordTypesController {
    
    public String entityRecordType {get;set;}
    public String entityName {get;set;}
    public Id entityId {get;set;}
    public String selectedPotentialRevenueRecordType {get;set;}
    public List<Potential_Revenue_Fields_Ids__c> potentialRevenueIds{get;set;}
    public Map<Id,String> availableRecordTypes {get;set;}
    public String retURL {get;set;}
    public String errors {get;set;}
    public List<RecordType> recordTypes {get;set;}
    
    
    public NFPPotentialRevenueRecordTypesController(){
        init();
    }
 
    private void init(){
        availableRecordTypes = new Map<Id,String>();
        recordTypes = new List<RecordType>();
        errors = '';
        retURL = ApexPages.currentPage().getParameters().get('retURL');
        entityRecordType = ApexPages.currentPage().getParameters().get('entityRecType');
        entityName = ApexPages.currentPage().getParameters().get('entityName');
        entityId = Id.valueOf(ApexPages.currentPage().getParameters().get('entityId'));
        
    }
    
    /*
     *Queries the available record types
     *according to the Entity record type
     */
    public PageReference loadRecordTypes(){
        
        PageReference page = null;
        Set<String> recordTypesToExclude = new Set<String>();
        availableRecordTypes  = NFPUtils.getPotentialRevenueRecordTypes(null);
        Set<Id> recordTypeIds = availableRecordTypes.keySet();
        potentialRevenueIds= Potential_Revenue_Fields_Ids__c.getAll().values();
        
        if (availableRecordTypes.size() > 0){
            if(entityRecordType.contains('Client Household')){
                //make list of record types that should not be for Client Household
                recordTypesToExclude = new Set<String>{'Commercial Insurance', 'Executive Benefits', 'Group Benefits', 'Retirement Plans'};
            }else if(entityRecordType.contains('Client Business')){
                //make list of record types that should not be for Client Business
                recordTypesToExclude  = new Set<String>{'Individual Other Insurance'};
            }
            
            for (Id recordTypeId : recordTypeIds ){
                String recordTypeName = availableRecordTypes.get(recordTypeId);
                if (recordTypesToExclude.contains(recordTypeName)){
                    availableRecordTypes.remove(recordTypeId);
                }
            }
            
            if (availableRecordTypes.size() == 0){
                errors = 'You have not enabled any Case Management record types for a ' + entityRecordType + 
                         ' Entity, for the ' + NFPUtils.getProfileName() + ' User Profile.';
            }else{
                recordTypes = NFPUtils.getRecordTypes(availableRecordTypes.keySet());
            }
        }else{
            page = openNewPotentialRevenueRecord();
        }
        
        return page;
    }
    
    /*
     *Display the correct options according to the 
     *record type of the entity
     *@return List<SelectOption> 
     */
    public List<SelectOption> getCorrectSelectList(){
        List<SelectOption> options = new List<SelectOption>();
        
         for(Id recordId : availableRecordTypes.keySet()){
            options.add(new SelectOption(recordId, availableRecordTypes.get(recordId)));    
         }
        return options;
    }   
    
    
    /*
     *Send user to new potential revenue with selected record type
     *@return PageReference
     */
    public PageReference openNewPotentialRevenueRecord(){
        //add CF to entity field id
        String entityFieldId = potentialRevenueIds[0].Entity_c__c;        
        
        //get potential revenue prefix code 
        String potentialRevenueKeyPref = Schema.SObjectType.Potential_Revenue__c.getKeyPrefix();
        
        //get record type id
        String recordTypeId = selectedPotentialRevenueRecordType != null ? selectedPotentialRevenueRecordType : '';
        
        String url = '/' + potentialRevenueKeyPref + '/e?RecordType=' + recordTypeId + '&' + entityFieldId + '=' + entityName;
        url += '&' + entityFieldId + '_lkid=' + entityId + '&retURL=' + retURL;
        
        PageReference redirectPage = new PageReference(url);
        redirectPage.setRedirect(true);
        return redirectPage;
        
    }
    
    /*
     *Gets the retURL and goes to the previous page
     *@return PageReference
     */
    public PageReference goBackToEntity(){    
        system.debug('>>>>> ' +retURL);    
        PageReference redirectPage = new PageReference(retURL);
        redirectPage.setRedirect(true);
        return redirectPage;
    }
    
    
    
}