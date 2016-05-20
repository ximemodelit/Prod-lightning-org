/* This class contains methods to mass delete process steps
 * @author Angelica Buffa
 * @since March 2015
 */
public with sharing class MassDeleteProcessStepsController {
	// Constants
	private static final String ERROR_NO_STEP_SELECTED = 'Please select at least one step to delete.';
	
	// Private instance variables
	private String processId {get;set;}
	
	// Public instance variables
	public List<String> errors {get;set;}
	public List<Process_Step__c> selectedSteps {get;set;}
	public String processName {get;set;}
	
	// Constructor
	public MassDeleteProcessStepsController(ApexPages.StandardSetController controller) {
		selectedSteps = controller.getSelected();
		init();
	}
	
	/* This method initializes the information that must be displayed when the page is opened
	 * @param -
	 * @return -
	 */
	private void init(){
		processname = '';
		errors = new List<String>();
		processId = Apexpages.currentPage().getParameters().get('id');
		processName = XLR8ProcessUtils.getProcessName(processId);
		
		// At least one step must be selected to proceed
		if (selectedSteps == null || selectedSteps.size() == 0){
			errors.add(ERROR_NO_STEP_SELECTED);
		}
		
		// Display errors (if any)
		showErrors();
	}
	
	/* This method adds errors to the Visualforce Page
	 * @param -
	 * @return -
	 */
	private void showErrors(){
		if (errors != null){
			for (String error : errors){
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, error));
			}	
		}
	}
	
	/* This method deletes the selected process steps and returns the user back to the process page
	 * @param -
	 * @return PageReference Process Detail Page
	 */
	public PageReference deleteProcessSteps(){
		PageReference page = null;
		errors = new List<String>();
		
		// Check if process steps where selected
		if (selectedSteps != null && selectedSteps.size() >= 0 ){
			// Allow partial success
			Database.Deleteresult[] results = Database.delete(selectedSteps, false);
			
			// If there are errors, they will be displayed in the page
			for (Database.Deleteresult dr : results ){
				if (!dr.isSuccess()){
					for(Database.Error err : dr.getErrors()) {
			            errors.add(err.getMessage());
			        }					
				}
			}
			
			// If there are no errors, take the user back to the process detail page. Otherwise, display
			// the errors in the page
			if (errors.size() == 0){
				page = new PageReference('/' + processId);
			}else{
				showErrors();
			}	
		}
		
		return page;	
	}
	
	/* This methods return the user to the process detail page. 
	 * @param -
	 * @return PageReference 
	 */
	public PageReference goBack(){
		return new PageReference('/' + processId);
	}
	
	/*This method queries and returns information for the selected steps. The information will be displayed
	 * in the confirmation screen
	 * @param -
	 * @return List of process steps that will be deleted
	 */
	public List<Process_Step__c> getSteps(){
		List<Process_Step__c> steps = null;
		
		if (selectedSteps != null && selectedSteps.size() > 0){
			steps = XLR8ProcessUtils.getSteps(selectedSteps);			
		}
		
		return steps;
	}
}