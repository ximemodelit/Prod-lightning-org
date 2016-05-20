/*
 * Utils class for RMD Calculations
 * @author Ang?lica Buffa, Ximena Lasserre
 * @since Mar 2015
 */
public without sharing class RmdCalcuatedAmountUtils {
    // Private constants
    private static final String UNIFORM_CALCULATION_METHOD = 'UNIFORM';
    private static final STring SINGLE_CALCULATION_METHOD = 'SINGLE';
    prIvate static final String JOINT_CALCULATION_METHOD = 'JOINT';  
      
    /* This methods calculates RMD for a subset of RMD Requirements
     * @param factors list of factors that can match the requirements
     * @param requirements list of requirements that need to be calculated
     * @param ExecutedTime datetime stamp that indicates when the rmd amount was calculated
     * @return collection of datbase save result. 
     */
    public Database.saveResult[] calculateRmdAmount(List<RMD_Factors__c> factors, List<RMD_Requirement__c> requirements, DateTime executedTime){
        Database.saveResult[] dbSaveResult;
        List<RMD_Requirement__c> requirementsToUpdate = new List<RMD_Requirement__c>();
        
        if (factors != null && requirements != null){
            // For each requirement we have to identify the factor that matches the Member Age, Spouse Age, and
            // Calculation Method
            for (RMD_Requirement__c requirement : requirements){
                Integer index = 0;
                Boolean factorFound = false;        
                while (!factorFound && index < factors.size() ){
                    RMD_Factors__c factor = factors.get(index);
                    // Check if the calculation method matches and
                    // ensure the factors is greater than cero to avoid Math.DivideByCero exception
                    if (requirement.RMD_Calculation_Method__c != null && 
                        requirement.RMD_Calculation_Method__c != '' &&
                        requirement.RMD_Calculation_Method__c == factor.Calculation_Type__c &&
                        factor.RMD_Factor__c != null && factor.RMD_Factor__c > 0){
                        // Member and spouse age must match if calculation type is joint. 
                        // member age must match if calculation type is single or uniform
                        if ((factor.Calculation_Type__c.toUpperCase() == JOINT_CALCULATION_METHOD  &&
                            requirement.RMD_Member_Age_EOY__c == factor.Age_EOY__c &&
                            requirement.RMD_Spouse_Age_EOY__c == factor.Age_EOY_2__c) ||
                            ((factor.Calculation_Type__c.toUpperCase() == SINGLE_CALCULATION_METHOD  ||
                            factor.Calculation_Type__c.toUpperCase() == UNIFORM_CALCULATION_METHOD ) &&
                            requirement.RMD_Member_Age_EOY__c == factor.Age_EOY__c)){
                            factorFound = true;   
                        }  
                    }
                    // Calculate RMD amount if there is a matching factor for current member
                    if (factorFound){
                        requirement.RMd_Factor__c = factor.RMD_Factor__c;
                        requirement.RMD_Calculated__c = requirement.Value_Previous_EOY__c / factor.RMD_Factor__c;
                        requirement.RMD_Last_Updated_Date__c = executedTime;
                        requirementsToUpdate.add(requirement);              
                    }
                    index++;
                }
            }
            
            if (requirementsToUpdate.size() > 0){ 
                try{
                    //update requirements
                    dbSaveResult = Database.update(requirementsToUpdate, false);
                    system.debug('save result 0 ' + dbSaveResult[0]);
                }catch(Exception ex){}
            }           
        }
        return dbSaveResult;
    }
}