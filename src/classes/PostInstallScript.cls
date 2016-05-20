/**
 * Post Install Script to run batch in order to update null values
 * of Hierarchy_Id_As_Text__c with Hierarchy_Group_ID__c values
 *
 * @author Ximena Lasserre
 * @since 2014-12
 *
 * revision 1.1 - Jason Landry - Support population of Custom Setting for ReportIDs
 */
public class PostInstallScript implements InstallHandler{
    /*
     * Runs the batch after the installation was completed 
     * @Param InstallContext context
     */
    public void onInstall(InstallContext context){
        
        
        //insert data mover custom settings
        insertSecurityToDMXLR8Objects();
        
        // Initialize Use task History Settings
        /*Settings__c xlr8Settings = new Settings__c();
        xlr8Settings.Name = 'XLR8 Settings';
        xlr8Settings.UseTaskHistory__c = true;
        
        try{
            insert xlr8Settings;
        }catch (Exception ex){}
        
        //1.1++
        List <Report> NWReports = [Select r.Id, r.DeveloperName 
                             From Report r 
                            Where r.DeveloperName LIKE '%Net_Worth%'];
                            
        
        for (Report r : NWReports) {
            
            ReportID__c reportID = new ReportID__c();
            
            if(r.DeveloperName == 'XLR8_Net_Worth'){
                reportID.Name = 'NetWorth';
                reportID.ReportID__c = r.id;
            }
            else if (r.DeveloperName == 'Net_Worth_History'){
                reportID.Name = 'NetWorthHistory';
                reportID.ReportID__c = r.id;
            }
            else if (r.DeveloperName == 'Net_Worth_History_Report_VF'){
                reportID.Name = 'NetWorthHistoryVF';
                reportID.ReportID__c = r.id;
            }
            else if (r.DeveloperName == 'Net_Worth_Report_VF'){
                reportID.Name = 'NetWorthVF';
                reportID.ReportID__c = r.id;
            }
            
            if(reportID.Name!=null)
                insert reportID;
        }*/
    }
    
    
    /*
     *Insert Security information to the Data_Mover_XLR8_Objects__c
     *custom settings
     */
    public void insertSecurityToDMXLR8Objects(){
        
        Boolean insertSecurities = true;
        List<Data_Mover_XLR8_Objects__c> dataMoverObjs = Data_Mover_XLR8_Objects__c.getAll().values();
        
        for(Data_Mover_XLR8_Objects__c dmObj : dataMoverObjs){
        //check if there are 'Securities' or 'Security'
            if(dmObj.Name.contains('Security') || dmObj.Name.contains('Securities')){           
                insertSecurities = false;
            }
        }
        if(insertSecurities) {
            Data_Mover_XLR8_Objects__c dmSecurity = new Data_Mover_XLR8_Objects__c();
            dmSecurity.Name = 'Securities';
            dmSecurity.API_Name__c = 'XLR8CS__XLR8_Securities__c';
            
            try{
                insert dmSecurity;
            }catch(Exception ex){
                system.debug('EXCEPTION: Could not insert Data_Mover_XLR8_Objects__c custom settings: ' + ex.getMessage());
            }
        }
    }
}