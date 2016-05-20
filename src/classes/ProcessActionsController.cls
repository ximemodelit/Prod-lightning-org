public without sharing class ProcessActionsController {
    private static Boolean cancelProcessStarted = false;
    
    private static final String ACTION_STOP_PROCESS = 'stop';
    private String processId;
    private String requestedAction;

    public ProcessActionsController() {
        processId = ApexPages.currentPage().getParameters().get('id');
        requestedAction = ApexPages.currentPage().getParameters().get('action');
    }
    
    public PageReference doAction() {
        if (requestedAction == ACTION_STOP_PROCESS) {
            cancelProcessStarted = true;
            stopProcess();
        }
        PageReference pageRef = new PageReference('/' + processId);
        return pageRef;
    }
    
    private void stopProcess() {
        ProcessManager mgr = new ProcessManager();
        mgr.stopProcess(processId);
    }
    
    public static Boolean getCancelProcessStarted(){
        return cancelProcessStarted;
    }
    
    @testVisible
    private static void setCancelProcessStartedForTest(){
        cancelProcessStarted = true;
    }
}