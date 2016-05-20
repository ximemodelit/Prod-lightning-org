/* This class contains methods execute the batch job from the page
 * @author Angelica Buffa
 * @since March 2015
 */
public with sharing class RMDBatchCalculatorController {
    
    
    // Public instance variables
    public List<String> errors { get; set; }
    public String year { get; set; }
    public String confirmationMsg { get; set; }
    
    // Constructor
    public RMDBatchCalculatorController(){
        errors = new List<String>();
        confirmationMsg = '';
    }
    
    /* This method adds a Batch Apex job to the queue, to mass update the RMD Requirements for a given year
     * @param -
     * @return -
     */
    public void calculateRMDAmount(){
        errors = new List<String>();
        
        if (year == null || year == ''){
            errors.add('Year cannot be blank.');
        }
        
        if (!RMDCalculatorUtils.validateYear(year)){
            errors.add('Year must be a four digitis number between 2000 and current year.');
        }
            
        if (errors.size() == 0){        
            Boolean result = RMDCalculatorUtils.scheduleBatch(year);
            if (!result){
                errors.add('The process cannot be started. Please contact your System Administrator');
            }else{
                confirmationMsg = 'The batch job has been queued. A notification email will be sent as soon as the batch completes.';
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,confirmationMsg));
            }
            system.debug('>>>>>>>>>>>>> result ' + result); 
                            
        }
        
        showErrors();
    }
    
    private void showErrors(){
        for (String error : errors){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,error));
        }
    }

    
    
}