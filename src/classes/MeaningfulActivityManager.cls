/*
 * Updates various Date fields on Account based on changes to Tasks and Events that are considered
 * "meaningful activities". If there is at least one value selected for the Meaningful Event field 
 * on a task/event, the activity is considered meaningful. The values selected are used to find
 * the Date fields on the Account. The Meaningful Activity value(s) must match an Account field
 * label *exactly*, or a runtime error will occur.
 *
 * @author Jeremy Ross
 */ 

public without sharing abstract class MeaningfulActivityManager {

    private Set<String> meaningfulValues = new Set<String>();
    private Map<String, AccountAndMeaningfulValue> accountsAndMeaningfulValues = 
        new Map<String, AccountAndMeaningfulValue>();
    private Map<String, String> fieldNameMap = new Map<String, String>();
    private Map<String, Account> accountMap = new Map<String, Account>();
    private Map<String, String> fieldNamesByLabel;

    protected abstract void parseActivities();
    protected abstract void setErrorOnSobjects(String message);


    private void start() {
        parseActivities();
        updateAccounts();
    }

    private String getTaskQuery() {
        String query = 'SELECT MAX(Completion_Date__c) theDate, WhatId' 
            + ', Meaningful_Activity_Flat__c MeaningfulActivity' 
            + ' FROM Task WHERE Status = \'Completed\' AND (';
        Boolean first = true;
        for (AccountAndMeaningfulValue pair : accountsAndMeaningfulValues.values()) {
            if (!first) {
                query += ' OR'; 
            }
            first = false;
            query += ' (WhatId = \'' + pair.getAccountId() + '\'' 
            + ' AND Meaningful_Activity__c includes(\'' 
            + String.escapeSingleQuotes(pair.getMeaningfulValue()) + '\'))';
        }
        query += ') GROUP BY WhatId, Meaningful_Activity_Flat__c';
        
        system.debug('>>>> Task Query >>>>> ' + query);
        return query;
    }

    private String getEventQuery() {        
        String dateTimeFormat = system.now().formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
        String dateFormat = dateTimeFormat.substring(0, dateTimeFormat.indexOf('T')) + 'T00:00:00Z';
        system.debug('>>>> dateFormat  >>>>> ' + dateFormat);
        
        String query = 'SELECT MAX(EndDateTime) theDateTime, WhatId' 
            + ', Meaningful_Activity_Flat__c MeaningfulActivity FROM Event'
            + ' WHERE EndDateTime <= ' + dateTimeFormat + ' AND (';
        Boolean first = true;
        for (AccountAndMeaningfulValue pair : accountsAndMeaningfulValues.values()) {
            if (!first) {
                query += ' OR'; 
            }
            first = false;
            query += ' (WhatId = \'' + pair.getAccountId() + '\'' 
            + ' AND Meaningful_Activity__c includes(\'' 
            + String.escapeSingleQuotes(pair.getMeaningfulValue()) + '\'))';
        }
        query += ') GROUP BY WhatId, Meaningful_Activity_Flat__c';
        
        system.debug('>>>> Events Query >>>>> ' + query);
        return query;
    }
    
    private List<AggregateResult> queryActivities(Schema.sObjectType objectType) {
        String query;
        if (objectType == Task.sObjectType) {
            query = getTaskQuery();
        }
        else {
            query = getEventQuery();
        }
        system.debug('>>>> query >>>> ' + query);
        return Database.query(query);
    }   

    private void processAggregateResults(List<AggregateResult> results, 
        Schema.SobjectType objectType) {
        for (AggregateResult ar : results) {
            try {
                applyAggregateResultToAccounts(ar, objectType);
            }
            catch (ApplicationException ex) {
                setErrorOnSobjects(ex.getMessage());
                system.debug(' >>>> En error occurred processAggregateResults>>>> ' + ex.getMessage());
                return;
            }
        }
    }
    
    private void updateAccounts() {
        if (accountsAndMeaningfulValues.isEmpty()) {
            return;
        }
        initFieldNameMap(meaningfulValues);
        List<AggregateResult> taskResults = queryActivities(Task.sObjectType);
        List<AggregateResult> eventResults = queryActivities(Event.sObjectType);
        processAggregateResults(taskResults, Task.sObjectType);
        processAggregateResults(eventResults, Event.sObjectType);
        try {
            setNullValuesForAccountsWithoutActivities();
            List<Database.SaveResult> saveResults = Database.update(accountMap.values(), false);
            for (Database.SaveResult result : saveResults) {
                if (!result.isSuccess()) {
                    System.debug(LoggingLevel.ERROR, result);
                }
            }
        }
        catch (ApplicationException ex) {
            system.debug(' >>>> En error occurred updateAccounts >>>> ' + ex.getMessage());
            setErrorOnSobjects(ex.getMessage());
        }
    }
    
    private void setNullValuesForAccountsWithoutActivities() {
        for (AccountAndMeaningfulValue amv : accountsAndMeaningfulValues.values()) {
            if (amv.getAccountId() == null) {
                throw new ApplicationException('amv.getAccountId() was null');
            }
            Account acc = accountMap.get(amv.getAccountId());
            if (acc == null) {
                acc = new Account(Id = amv.getAccountId());
                accountMap.put(acc.Id, acc);
            }
            if (amv.getMeaningfulValue() == null) {
                throw new ApplicationException('amv.getMeaningfulValue() was null');
            }
            String fieldName = fieldNamesByLabel.get(amv.getMeaningfulValue());
            if (fieldName == null) {
                throw new ApplicationException('A date field for the Meaningful Activity selected' 
                    + ' does not exist on the Entity record. Contact your System Administrator.');
            }
            acc.put(fieldName, null);
        }
    }
    
    private void applyAggregateResultToAccounts(AggregateResult ar, Schema.sObjectType objectType) {
        Account acc = accountMap.get((String) ar.get('WhatId'));
        if (acc == null) {
            acc = new Account(Id = (Id) ar.get('WhatId'));
            accountMap.put((Id) ar.get('WhatId'), acc);
        }
        Date theDate;
        if (objectType == Task.sObjectType) {
            theDate = (Date) ar.get('theDate');
        }
        else {
            try{
                DateTime utcTime = (DateTime) ar.get('theDateTime');
    
                //convert to string to format datetime to local parameter
                String localStringDatetime = utcTime.format('yyyy-MM-dd HH:mm:ss', UserInfo.getTimezone().getId());
                
                // Get the date component
                String[] localDateComponent = localStringDatetime.split(' ')[0].split('-');
                
                // Create a date in local timezone
                Date localDate = date.newinstance(Integer.valueOf(localDateComponent[0]), Integer.valueOf(localDateComponent[1]),Integer.valueOf( localDateComponent[2]));
                theDate = localDate;
            }catch(Exception ex){
                 system.debug(' >>>> En error occurred applyAggregateResultToAccounts >>>> ' + ex.getMessage());
            }
        }
        
        String flat = (String) ar.get('MeaningfulActivity');
        for (String meaningfulValue : flat.split(';')) {
            if (!meaningfulValues.contains(meaningfulValue)) {
                System.debug('Skipping meaningful value "' + meaningfulValue 
                    + '" because it was not involved in any task/event change.');
                continue;
            }
            accountsAndMeaningfulValues.remove(acc.Id + meaningfulValue);
            String fieldName = fieldNamesByLabel.get(meaningfulValue);
            if (fieldName == null) {
                throw new ApplicationException('A date field for the Meaningful Activity selected'
                    + ' does not exist on the Entity record. Contact your System Administrator.');
            }
            Date existingDate = (Date) acc.get(fieldName);
            if (existingDate != null && existingDate > theDate) {
                acc.put(fieldName, existingDate);
            }
            else {
                acc.put(fieldName, theDate);
            }
        }
    }
    
    private void queueAccountMeaningfulValue(Id accountId, String meaningfulValue) {
        List<String> splitValues = meaningfulValue.split(';');
        for (String meaningfulVal : splitValues) {
            accountsAndMeaningfulValues.put(accountId + meaningfulVal, 
                new AccountAndMeaningfulValue(String.valueOf(accountId), meaningfulVal));
            meaningfulValues.add(meaningfulVal);
        }
    }
        
    // returns a field label to field name map
    private void initFieldNameMap(Set<String> fieldLabels) {
        Map<String, String> theMap = new Map<String, String>();
        Schema.DescribeSObjectResult dsr = Account.sObjectType.getDescribe();
        Map<String, Schema.SObjectField> fieldTokens = Schema.SObjectType.Account.fields.getMap();
        for (String key : fieldTokens.keySet()) {
            Schema.SObjectField f = fieldTokens.get(key);
            Schema.DescribeFieldResult dfr = f.getDescribe();
            if (fieldLabels.contains(dfr.getLabel()) && dfr.getType() == Schema.DisplayType.Date) {
                theMap.put(dfr.getLabel(), key);
            }
        }       
        fieldNamesByLabel = theMap;
    }

    /*
     * Based on changes to Tasks, will update associated Accounts. Designed to be called from the
     * after insert/update/delete Triggers.
     */ 
    public class MeaningfulTaskManager extends MeaningfulActivityManager {

        private Map<Id, Task> oldTasks; 
        private Map<Id, Task> newTasks;
        
        public MeaningfulTaskManager(Map<Id, Task> oldTasks, Map<Id, Task> newTasks) {
            this.oldTasks = oldTasks;
            this.newTasks = newTasks;
            start();
        }
        
        protected override void parseActivities() {
            for (Task newTask : newTasks.values()) {
                Task oldTask = null; 
                if (oldTasks != null) {
                    oldTask = oldTasks.get(newTask.Id);
                }
                if (newTask.AccountId != null 
                    && newTask.Meaningful_Activity__c != null) {
                    queueAccountMeaningfulValue(newTask.AccountId, newTask.Meaningful_Activity__c);
                }
                if (oldTask != null) {
                    if (oldTask.Meaningful_Activity__c != null && oldTask.AccountId != null) {
                        queueAccountMeaningfulValue(oldTask.AccountId, oldTask.Meaningful_Activity__c);
                    }
                }
            }
        }
        
        
        protected override void setErrorOnSobjects(String message) {
            for (Task t : newTasks.values()) {
                t.addError(message);
            }
        }
    }
    
    /*
     * Based on changes to Events, will update associated Accounts. Designed to be called from the
     * after insert/update/delete Triggers.
     */
    public class MeaningfulEventManager extends MeaningfulActivityManager {
        
        private Map<Id, Event> oldEvents;
        private Map<Id, Event> newEvents;
        
        public MeaningfulEventManager(){}
        
        public MeaningfulEventManager(Map<Id, Event> oldEvents, Map<Id, Event> newEvents) {
            this.oldEvents = oldEvents;
            this.newEvents = newEvents;
            start();
        }
        
        protected override void parseActivities() {
            for (Event newEvent : newEvents.values()) {
                Event oldEvent = null; 
                if (oldEvents != null) {
                    oldEvent = oldEvents.get(newEvent.Id);
                }
                if (newEvent.AccountId != null 
                    && newEvent.Meaningful_Activity__c != null) {
                    queueAccountMeaningfulValue(newEvent.AccountId, newEvent.Meaningful_Activity__c);
                }
                if (oldEvent != null) {
                    if (oldEvent.Meaningful_Activity__c != null && oldEvent.AccountId != null) {
                        queueAccountMeaningfulValue(oldEvent.AccountId, oldEvent.Meaningful_Activity__c);
                    }
                }
            }
        }

        protected override void setErrorOnSobjects(String message) {
            for (Event e : newEvents.values()) {
                e.addError(message);
            }
        }   
        
        /* This method sets the value for the Is Closed Event field. 
        * The code behaves different for new events and for existing events
        */
        public void closeEvents(List<Event> newEvents, Map<Id,Event> oldEvents){
            system.debug(' >>>> newEvents >>>> ' + newEvents);
            system.debug(' >>>> oldEvents >>>> ' + oldEvents);
            // For existing events, we should check if the end date time or start datetime changed.
            if (newEvents != null && newEvents.size() > 0 && oldEvents != null && oldEvents.size() > 0){
                for (Event e : newEvents){
                    if (e.EndDateTime != oldEvents.get(e.Id).EndDateTime || e.StartDateTime != oldEvents.get(e.Id).StartDateTime){
                        system.debug(' >>>> e.EndDateTime >>>> ' + e.EndDateTime);
                        system.debug(' >>>> e.StartDateTime >>>> ' + e.StartDateTime);
                        system.debug(' >>>> oldEvents.get(e.Id).EndDateTime >>>> ' + oldEvents.get(e.Id).EndDateTime);
                        system.debug(' >>>> oldEvents.get(e.Id).StartDateTime >>>> ' +oldEvents.get(e.Id).StartDateTime);
                        if (e.EndDateTime > system.now() || e.StartDateTime > system.now()){
                            system.debug(' >>>> Gets into 1 >>>> ' + oldEvents);
                            e.Is_Event_Closed__c = false;
                        }else if (e.EndDateTime <= system.now()){
                            system.debug(' >>>> Gets into 2 >>>> ' + oldEvents);
                            e.Is_Event_Closed__c = true;
                        }                   
                    }                                       
                }
            // For new events we should directly compare the end datetime and start datetime
            }else if (newEvents != null && newEvents.size() > 0 && oldEvents == null){
                for (Event e : newEvents){
                     system.debug(' >>>> e.EndDateTime >>>> ' + e.EndDateTime);
                    system.debug(' >>>> e.StartDateTime >>>> ' + e.StartDateTime);
                    if (e.EndDateTime > system.now() || e.StartDateTime > system.now()){
                        system.debug(' >>>> Gets into 3 >>>> ' + oldEvents);
                        e.Is_Event_Closed__c = false;
                    }else if (e.EndDateTime <= system.now()){
                        system.debug(' >>>> Gets into 4 >>>> ' + oldEvents);
                        e.Is_Event_Closed__c = true;
                    }                    
                }
            }
            
            // This is an extra validation. In any cases we always have to ensure that the Is Event Closed field 
            // is updated correctly when switching its value (from true to false, or from false to true)
            for (Event e : newEvents){
                if (e.Is_Event_Closed__c){
                    if (e.EndDateTime > system.now()){
                        system.debug(' >>>> Gets into 5 >>>> ' + oldEvents);
                        e.Is_Event_Closed__c = false;
                    }
                    
                }else{
                    if (e.EndDateTime <= system.now()){
                    system.debug(' >>>> Gets into 6 >>>> ' + oldEvents);
                        e.Is_Event_Closed__c = true;
                    }
                    
                }
            }
        }   
    }

    private class AccountAndMeaningfulValue {
        private String accountId;
        private String meaningfulValue;
        
        public AccountAndMeaningfulValue(String accountId, String meaningfulValue) {
            this.accountId = accountId;
            this.meaningfulValue = meaningfulValue;
        }
        
        public String getAccountid() {
            return accountId;
        }
        
        public String getMeaningfulValue() {
            return meaningfulValue;
        }
    } 
}