public without sharing class EventManager {
    
    public void beforeInsertUpdate(Map<Id, Event> oldEventMap, List<Event> newEvents) {
        for (Event newEvent : newEvents) {
            //newEvent.Activity_Date__c = newEvent.ActivityDate;
            Event oldEvent;
            if (oldEventMap != null) {
                oldEvent = oldEventMap.get(newEvent.Id);
            }
            if (oldEvent == null || 
                    oldEvent.Meaningful_Activity__c != newEvent.Meaningful_Activity__c) {
                setMeaningfulActivityFlat(newEvent);
            }
        }
    }
    
    private void setMeaningfulActivityFlat(Event e) {
        if (e.Meaningful_Activity__c == null) {
            e.Meaningful_Activity_Flat__c = null;
            return;
        }
        String flatValue = '';
        e.Meaningful_Activity_Flat__c = e.Meaningful_Activity__c;
    }
}