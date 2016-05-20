public with sharing class ReportIDController {

    public ID XLR8NetWorthID {get; private set;}
    public ID XLR8NetWorthHistoryID {get; private set;}
    public ID XLR8NetWorthHistoryReportVFID {get; private set;}
    public ID XLR8NetWorthReportVFID {get; private set;}
    
    public String fldNmEntityID18 {get; private set;}
    //public String objNmXLR8AssetsLiabilities {get; private set;}
    //public String fldNmIncludeInNetWorth {get; private set;}
    //public String objNmNetWorthHistory {get; private set;}
    //public String fldNmAsofDate {get; private set;}
    
    public String colAccountEntityID18 {get; private set;}
    public String colAssAndLblIncldnNW {get; private set;}
    public String colFKAccountEntityID18 {get; private set;}
    public String colNtWrthHstAsOfDt {get; private set;}

    public ReportIDController (ApexPages.StandardController controller) {
        
        XLR8NetWorthID = ReportID__c.getValues('NetWorth').ReportID__c;
        XLR8NetWorthHistoryID = ReportID__c.getValues('NetWorthHistory').ReportID__c;
        XLR8NetWorthHistoryReportVFID = ReportID__c.getValues('NetWorthHistoryVF').ReportID__c;
        XLR8NetWorthReportVFID = ReportID__c.getValues('NetWorthVF').ReportID__c;
        
		//Net Worth Report column names
		fldNmEntityID18 = Schema.sObjectType.Account.fields.Entity_ID_18__c.name;
		colAccountEntityID18 = 'Account.'+fldNmEntityID18;
		colAssAndLblIncldnNW = Schema.sObjectType.XLR8_Assets_Liabilities__c.name+'.'+Schema.sObjectType.XLR8_Assets_Liabilities__c.fields.Include_In_Net_Worth__c.name;
		
		//Net Worth History Report column names
		colFKAccountEntityID18 = 'FK_Account.'+fldNmEntityID18;
		colNtWrthHstAsOfDt = Schema.sObjectType.Net_Worth_History__c.name+'.'+Schema.sObjectType.Net_Worth_History__c.fields.As_of_Date__c.name;
		
		
        
        
        /*List <Report> NWReports = [Select  r.Id, r.DeveloperName 
                                     From Report r 
                                    Where r.DeveloperName LIKE '%Net_Worth%'];
        integer i = 0;
                                
        for (Report r : NWReports) {
            if(r.DeveloperName == 'XLR8_Net_Worth')
                XLR8NetWorthID = r.id;
            else if (r.DeveloperName == 'XLR8_Net_Worth_History')
                XLR8NetWorthHistoryID = r.id;
            else if (r.DeveloperName == 'XLR8_Net_Worth_History_Report_VF')
                XLR8NetWorthHistoryReportVFID = r.id;
            else if (r.DeveloperName == 'XLR8_Net_Worth_Report_VF')
                XLR8NetWorthReportVFID= r.id;
        }*/
                                
     }
}