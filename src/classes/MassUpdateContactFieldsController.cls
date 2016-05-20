/*
    Concenter Services, LLC
 ************************************************************************************************************************
 * Revision History
 * Change #     Developer       Date        Description
 ************************************************************************************************************************
 * Initial     Jason Landry    03/07/15     PlanIO 711 - Controller to update Contact Addresses from Entity Addresses
 */
public with sharing class MassUpdateContactFieldsController {
    
    //private ApexPages.StandardSetController controller;
    private ApexPages.StandardController controller;
    
    private String trgtType;
    private String trgtCO;
    private String trgtStreet;
    private String trgtStreet2;
    private String trgtCity;
    private String trgtState;
    private String trgtZip;
    private String trgtCntr;
    private String trgtMNotes;
    
    public boolean updateDisabled { get; private set; }
    //public boolean copyAllAddresses { get; set; }
    public boolean prmry { get; private set; }
    public boolean thrd { get; private set; }
    public boolean frth { get; private set; }
    public boolean scndry { get; private set; }
    
    public String accaddtocpy = 'first';
    public String targetcontactaddress { get; set; }
    public Account cntctAccount { get; private set; }
    
    public List<Account> cntctAccountLst { get; private set; }
    public List<wrpContact> wrapperContacts  { get; private set; }
    

    public MassUpdateContactFieldsController(ApexPages.StandardController controller) {
    
                this.controller = controller;
                loadAccountAndContacts();
    }
    
    private void loadAccountAndContacts() {
        
                        List <Contact> acctContacts = null;
                        wrapperContacts = new List<wrpContact> ();
        
                        cntctAccountLst = [SELECT Id, Name, Primary_Address_Formatted__c, Secondary_Address_Formatted__c, Third_Address_Formatted__c, Fourth_Address_Formatted__c,
                                       Primary_Type__c, Primary_C_O__c, Primary_Street__c, Primary_Street_2__c, Primary_City__c, Primary_State__c, Primary_Zip__c, Primary_Country__c, Primary_Mailing_Notes__c,
                                       Secondary_Type__c, Secondary_C_O__c, Secondary_Street__c, Secondary_Street_2__c, Secondary_City__c, Secondary_State__c, Secondary_Zip__c, Secondary_Country__c, Secondary_Mailing_Notes__c,
                                       Third_Type__c, Third_C_O__c, Third_Street__c, Third_Street_2__c, Third_City__c, Third_State__c, Third_Zip__c, Third_Country__c, Third_Mailing_Notes__c,
                                       Fourth_Type__c, Fourth_C_O__c, Fourth_Street__c, Fourth_Street_2__c, Fourth_City__c, Fourth_State__c, Fourth_Zip__c, Fourth_Country__c, Fourth_Mailing_Notes__c
                                  FROM Account
                                 WHERE Id = :ApexPages.currentPage().getParameters().get('Id')];
                                 
                cntctAccount = cntctAccountLst.size()>0 ? cntctAccountLst[0] : null;
                if (cntctAccount == null) {
                        updateDisabled = true;
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                                'Account has been deleted.'));
                }
                else {
                        acctContacts = [Select c.id, c.name, c.Primary_Type__c, c.Primary_C_O__c, c.Primary_Street__c, c.Primary_Street_2__c, c.Primary_City__c, c.Primary_State__c, c.Primary_Zip__c, c.Primary_Country__c, c.Primary_Mailing_Notes__c,
                                           c.Secondary_Type__c, c.Secondary_C_O__c, c.Secondary_Street__c, c.Secondary_Street_2__c, c.Secondary_City__c, c.Secondary_State__c, c.Secondary_Zip__c, c.Secondary_Country__c, c.Secondary_Mailing_Notes__c,
                                           c.Third_Type__c, c.Third_C_O__c, c.Third_Street__c, c.Third_Street_2__c, c.Third_City__c, c.Third_State__c, c.Third_Zip__c, c.Third_Country__c, c.Third_Mailing_Notes__c,
                                           c.Fourth_Type__c, c.Fourth_C_O__c, c.Fourth_Street__c, c.Fourth_Street_2__c, c.Fourth_City__c, c.Fourth_State__c, c.Fourth_Zip__c, c.Fourth_Country__c, c.Fourth_Mailing_Notes__c
                                      From Contact c
                                     Where c.AccountId =: cntctAccount.id
                                  Order By c.name];
                                  
                    
                                 
                        if (acctContacts == null || acctContacts.size()<1) {
                        updateDisabled = true;
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                                'Updates can only be performed on an Entity with at least one Contact.'));
                        }
                        else {
                        updateDisabled = false;
                        prmry = true;
                        
                        for(Contact c : acctContacts) {
                            wrapperContacts.add(new wrpContact(c));
                        }
                        }
                }
                
                
        
    }
        
    public void setAccountaddress2copy(String s) {
        this.accaddtocpy = s;
    }
    
    public String getAccountaddress2copy() {
        return this.accaddtocpy;
    }
    
    
    
    public void whchCntctAddress () {
        
        prmry=targetcontactaddress.equals('first') ? true : false;
        scndry=targetcontactaddress.equals('second') ? true : false;
        thrd=targetcontactaddress.equals('third') ? true : false;
        frth=targetcontactaddress.equals('fourth') ? true : false;
       
    }
    
    public void updateFields () {
        //system.debug('targetcontactaddress selected = ' + targetcontactaddress);
        
        integer selectedCnt = 0;
        List<Contact> updtContacts = new List<Contact>();
        
        for(wrpContact wc : wrapperContacts) {
            if(wc.selected==true){
                system.debug('wc.con.name is selected ' + wc.con.name);
                wc.selected=false;
                selectedCnt++;
                
                if(accaddtocpy.equals('first')) {
                    trgtType = cntctAccount.Primary_Type__c;
                    trgtCO = cntctAccount.Primary_C_O__c;
                    trgtStreet = cntctAccount.Primary_Street__c;
                    trgtStreet2 = cntctAccount.Primary_Street_2__c;
                    trgtCity = cntctAccount.Primary_City__c;
                    trgtState = cntctAccount.Primary_State__c;
                    trgtZip = cntctAccount.Primary_Zip__c;
                    trgtCntr = cntctAccount.Primary_Country__c;
                    trgtMNotes = cntctAccount.Primary_Mailing_Notes__c;   
                }
                else if(accaddtocpy.equals('second')) {
                    trgtType = cntctAccount.Secondary_Type__c;
                    trgtCO = cntctAccount.Secondary_C_O__c;
                    trgtStreet = cntctAccount.Secondary_Street__c;
                    trgtStreet2 = cntctAccount.Secondary_Street_2__c;
                    trgtCity = cntctAccount.Secondary_City__c;
                    trgtState = cntctAccount.Secondary_State__c;
                    trgtZip = cntctAccount.Secondary_Zip__c;
                    trgtCntr = cntctAccount.Secondary_Country__c;
                    trgtMNotes = cntctAccount.Secondary_Mailing_Notes__c;   
                }
                else if(accaddtocpy.equals('third')) {
                    trgtType = cntctAccount.Third_Type__c;
                    trgtCO = cntctAccount.Third_C_O__c;
                    trgtStreet = cntctAccount.Third_Street__c;
                    trgtStreet2 = cntctAccount.Third_Street_2__c;
                    trgtCity = cntctAccount.Third_City__c;
                    trgtState = cntctAccount.Third_State__c;
                    trgtZip = cntctAccount.Third_Zip__c;
                    trgtCntr = cntctAccount.Third_Country__c;
                    trgtMNotes = cntctAccount.Third_Mailing_Notes__c;   
                }
                else if(accaddtocpy.equals('fourth')) {
                    trgtType = cntctAccount.Fourth_Type__c;
                    trgtCO = cntctAccount.Fourth_C_O__c;
                    trgtStreet = cntctAccount.Fourth_Street__c;
                    trgtStreet2 = cntctAccount.Fourth_Street_2__c;
                    trgtCity = cntctAccount.Fourth_City__c;
                    trgtState = cntctAccount.Fourth_State__c;
                    trgtZip = cntctAccount.Fourth_Zip__c;
                    trgtCntr = cntctAccount.Fourth_Country__c;
                    trgtMNotes = cntctAccount.Fourth_Mailing_Notes__c;   
                }
                
                
                if(prmry){
                    wc.con.Primary_Type__c = trgtType;
                    wc.con.Primary_C_O__c = trgtCO; 
                    wc.con.Primary_Street__c = trgtStreet;
                    wc.con.Primary_Street_2__c = trgtStreet2;
                    wc.con.Primary_City__c = trgtCity;
                    wc.con.Primary_State__c = trgtState;
                    wc.con.Primary_Zip__c = trgtZip;
                    wc.con.Primary_Country__c = trgtCntr;
                    wc.con.Primary_Mailing_Notes__c = trgtMNotes;
                }
                else if(scndry){
                    wc.con.Secondary_Type__c = trgtType;
                    wc.con.Secondary_C_O__c = trgtCO; 
                    wc.con.Secondary_Street__c = trgtStreet;
                    wc.con.Secondary_Street_2__c = trgtStreet2;
                    wc.con.Secondary_City__c = trgtCity;
                    wc.con.Secondary_State__c = trgtState;
                    wc.con.Secondary_Zip__c = trgtZip;
                    wc.con.Secondary_Country__c = trgtCntr;
                    wc.con.Secondary_Mailing_Notes__c = trgtMNotes;
                }
                else if(thrd){
                    wc.con.Third_Type__c = trgtType;
                    wc.con.Third_C_O__c = trgtCO; 
                    wc.con.Third_Street__c = trgtStreet;
                    wc.con.Third_Street_2__c = trgtStreet2;
                    wc.con.Third_City__c = trgtCity;
                    wc.con.Third_State__c = trgtState;
                    wc.con.Third_Zip__c = trgtZip;
                    wc.con.Third_Country__c = trgtCntr;
                    wc.con.Third_Mailing_Notes__c = trgtMNotes;
                }
                else if(frth){
                    wc.con.Fourth_Type__c = trgtType;
                    wc.con.Fourth_C_O__c = trgtCO; 
                    wc.con.Fourth_Street__c = trgtStreet;
                    wc.con.Fourth_Street_2__c = trgtStreet2;
                    wc.con.Fourth_City__c = trgtCity;
                    wc.con.Fourth_State__c = trgtState;
                    wc.con.Fourth_Zip__c = trgtZip;
                    wc.con.Fourth_Country__c = trgtCntr;
                    wc.con.Fourth_Mailing_Notes__c = trgtMNotes;
                }
                updtContacts.add(wc.con);
            }//if selected
        }//end for
        if(selectedCnt<1){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                                'Please select at least one Contact to update.'));
        }
        
        try{
                update updtContacts;
        }
        catch (DMLException e) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
                        loadAccountAndContacts();
                }
        
    }
    
    public with sharing class wrpContact {
        public Contact con {get; set;}
        public Boolean selected {get; set;}
        
        public wrpContact(Contact c) {
            con = c;
            selected = false;
        }
    } 
}