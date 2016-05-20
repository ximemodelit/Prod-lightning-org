global class NFPSettingsValidator{

    webservice static String validateCustomSettings(){
        String error = '';
        List<Potential_Revenue_Fields_Ids__c> settings = Potential_Revenue_Fields_Ids__c.getAll().values();
        
        if(settings == null || settings.size() == 0){
            try{
                NFPUtils.insertPotentialRevenueFieldsId();
            }catch(Exception ex){
                if(ex.getMessage().toLowercase().contains('unauthorized endpoint')){
                    error = 'There is no set remote site for this endpoint. Please contact your system administrator to set it.';
                    error += ' Endpoint: ' + ex.getMessage().split('endpoint = ').get(1);
                }else if(ex.getMessage().toLowercase().contains('invalid_type')) {
                    error = 'The record types for Case Management have not been set up correctly. Please contact your System Administrator.';
                }
            }
        }
        return error;
    }
}