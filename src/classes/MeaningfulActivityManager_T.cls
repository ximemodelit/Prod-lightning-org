@isTest
private class MeaningfulActivityManager_T {

    @isTest 
    private static void usesMostRecentTask() {
        Date theDate2 = Date.today().addDays(-3);
        Date theDate = Date.today().addDays(-2);
        Account account1 = new Account(
            Name = 'test'
        );
        insert account1;
        
        Task task1 = new Task(
            WhatId = account1.Id,
            Subject = 'test',
            ActivityDate = theDate,
            Status = 'Completed',
            Meaningful_Activity__c = 'Last Estate Plan Review'
        );
        
        Task task2 = new Task(
            WhatId = account1.Id,
            Subject = 'test2',
            ActivityDate = theDate2, 
            Status = 'Completed',           
            Meaningful_Activity__c = 'Last Estate Plan Review'
        );
        insert task1;
        insert task2; 
        
        task1.Completion_Date__c = theDate;
        task2.Completion_Date__c = theDate2;
        
        update task1;
        update task2;

        account1 = [SELECT Last_Estate_Plan_Review__c FROM Account WHERE Id = :account1.Id];
        System.assertEquals(theDate, account1.Last_Estate_Plan_Review__c);
    }

    @isTest 
    private static void usesMostRecentTaskOrEvent() {
        DateTime theTime = DateTime.now().addDays(-4);
        Date theDate = Date.today().addDays(-2);
        Account account1 = new Account(
            Name = 'test'
        );
        insert account1;
        
        Task task1 = new Task(
            WhatId = account1.Id,
            Subject = 'test',
            ActivityDate = theDate,
            Status = 'Completed',
            Meaningful_Activity__c = 'Last Estate Plan Review'
        );
        insert task1;
        task1.Completion_Date__c = theDate;
        update task1;

        Event event1 = new Event(
            WhatId = account1.Id,
            Subject = 'test2',
            StartDateTime = theTime,
            DurationInMinutes = 60, 
            Meaningful_Activity__c = 'Last Estate Plan Review'
        );
        insert event1; 

        account1 = [SELECT Last_Estate_Plan_Review__c FROM Account WHERE Id = :account1.Id];
        System.assertEquals(theDate, account1.Last_Estate_Plan_Review__c);
    }

    @isTest 
    private static void invalidMeaningfulActivityGeneratesError() {
        Date theDate = Date.today().addDays(-3);
        Account account1 = new Account(
            Name = 'test'
        );
        insert account1;
        
        Task task1 = new Task(
            WhatId = account1.Id,
            Subject = 'test',
            ActivityDate = theDate,
            Status = 'Completed',
            Meaningful_Activity__c = 'Invalid value!'
        );
        
        String errorMessage;
        try {
            insert task1;
        }
        catch (DmlException ex) {
            errorMessage = ex.getMessage();
        }
        
        System.assert(errorMessage != null);
        System.assert(errorMessage.contains('does not exist'));     
    }

    @isTest 
    private static void handlesMultipleMeaningfulActivityValues() {
        Date theDate = Date.today().addDays(-3);
        Account account1 = new Account(
            Name = 'test'
        );
        insert account1;
        
        Task task1 = new Task(
            WhatId = account1.Id,
            Subject = 'test',
            ActivityDate = theDate,
            Status = 'Completed',
            Meaningful_Activity__c = 'Last Estate Plan Review;Last Insurance Plan Review'
        );
        insert task1;
        task1.Completion_Date__c = theDate;
        update task1;

        account1 = [SELECT Last_Estate_Plan_Review__c, Last_Insurance_Plan_Review__c 
            FROM Account WHERE Id = :account1.Id];
        System.assertEquals(theDate, account1.Last_Estate_Plan_Review__c);
        System.assertEquals(theDate, account1.Last_Insurance_Plan_Review__c);
    }

    @isTest 
    private static void changingTasksMeaningfulActivityUpdatesAccount() {
        Date theDate = Date.today().addDays(-3);
        Account account1 = new Account(
            Name = 'test'
        );
        insert account1;
        
        Task task1 = new Task(
            WhatId = account1.Id,
            Subject = 'test',
            ActivityDate = theDate,
            Status = 'Completed',
            Meaningful_Activity__c = 'Last Estate Plan Review'
        );
        
        insert task1;
        
        task1.Meaningful_Activity__c = 'Last Insurance Plan Review';
        update task1;

        account1 = [SELECT Last_Estate_Plan_Review__c, Last_Insurance_Plan_Review__c 
            FROM Account WHERE Id = :account1.Id];
        System.assertEquals(Date.today(), account1.Last_Insurance_Plan_Review__c);
        System.assert(account1.Last_Estate_Plan_Review__c == null);
    }

    @isTest 
    private static void changingEventsMeaningfulActivityUpdatesAccount() {
        DateTime theTime = DateTime.now().addDays(-4);
        Account account1 = new Account(
            Name = 'test'
        );
        insert account1;
        
        Event event1 = new Event(
            WhatId = account1.Id,
            Subject = 'test2',
            StartDateTime = theTime,
            DurationInMinutes = 60, 
            EndDateTime = theTime.addMinutes(60),
            Meaningful_Activity__c = 'Last Estate Plan Review'
        );
        insert event1; 
        
        event1.Meaningful_Activity__c = 'Last Insurance Plan Review';
        update event1;

        account1 = [SELECT Last_Estate_Plan_Review__c, Last_Insurance_Plan_Review__c 
            FROM Account WHERE Id = :account1.Id];
        // System.assertEquals(Date.today(), account1.Last_Insurance_Plan_Review__c);
        System.assert(account1.Last_Estate_Plan_Review__c == null);
    }

    @isTest 
    private static void updatesMultipleDatesOnSameAccountFromSeparateTasks() {
        Date theDate = Date.today().addDays(-3);
        Account account1 = new Account( 
            Name = 'test'
        );
        insert account1;
        
        Task task1 = new Task(
            WhatId = account1.Id,
            Subject = 'test',
            ActivityDate = theDate,
            Status = 'Completed',
            Meaningful_Activity__c = 'Last Estate Plan Review'
        );
        
        Task task2 = new Task(
            WhatId = account1.Id,
            Subject = 'test2',
            ActivityDate = theDate,
            Status = 'Completed',
            Meaningful_Activity__c = 'Last IPS Review'
        );
        insert new List<Task> { task1, task2 };
        task1.Completion_Date__c = theDate;
        task2.Completion_Date__c = theDate;
        update new List<Task> { task1, task2 };

        account1 = [SELECT Last_Estate_Plan_Review__c, Last_IPS_Review__c FROM Account 
            WHERE Id = :account1.Id];
        System.assertEquals(theDate, account1.Last_Estate_Plan_Review__c);
        System.assertEquals(theDate, account1.Last_IPS_Review__c);
    }

    @isTest 
    private static void deletingATaskCausesRecalcOfLastActivityDate() {
        Date theDate = Date.today().addDays(-3);
        Date theDate2 = Date.today().addDays(-2);
        Account account1 = new Account( 
            Name = 'test'
        );
        insert account1;
        
        Task task1 = new Task(
            WhatId = account1.Id,
            Subject = 'test',
            ActivityDate = theDate,
            Status = 'Completed',
            Meaningful_Activity__c = 'Last Estate Plan Review'
        );
        
        Task task2 = new Task(
            WhatId = account1.Id,
            Subject = 'test2',
            ActivityDate = theDate2,
            Status = 'Completed',
            Meaningful_Activity__c = 'Last Estate Plan Review'
        );
        insert new List<Task> { task1, task2 };
        
        // trigger runs
        
        delete task2;

        account1 = [SELECT Last_Estate_Plan_Review__c FROM Account 
            WHERE Id = :account1.Id];
        System.assertEquals(Date.today(), account1.Last_Estate_Plan_Review__c);
    }

    @isTest 
    private static void usesMostRecentEvent() {
        DateTime startTime = DateTime.now().addDays(-3);
        DateTime startTime2 = DateTime.now().addDays(-2);
        Account account1 = new Account(
            Name = 'test'
        );
        insert account1;
        
        Event event1 = new Event(
            WhatId = account1.Id,
            Subject = 'test',
            StartDateTime = startTime,
            EndDateTime = startTime.addMinutes(60),
            Meaningful_Activity__c = 'Last Estate Plan Review'
        );
        
        Event event2 = new Event(
            WhatId = account1.Id,
            Subject = 'test2',
            StartDateTime = startTime2,
            EndDateTime = startTime2.addMinutes(60),        
            Meaningful_Activity__c = 'Last Estate Plan Review'
        );
        insert new List<Event> { event1, event2 };

        account1 = [SELECT Last_Estate_Plan_Review__c FROM Account WHERE Id = :account1.Id];
        System.assertEquals(startTime2.addMinutes(60).date(), account1.Last_Estate_Plan_Review__c);
        
    }
    
    
    @isTest 
    private static void nonAllDayEventWithStartAndEndDateOnDifferentDays() {
        DateTime startTime = DateTime.now().addDays(-3);
        DateTime EndTime = DateTime.now();
        Account account1 = new Account(
            Name = 'test'
        );
        insert account1;
        
        Event event1 = new Event(
            WhatId = account1.Id,
            Subject = 'test',
            StartDateTime = startTime,
            EndDateTime = endTime,
            isAllDayEvent = false,
            Meaningful_Activity__c = 'Last Estate Plan Review'
        );
    
        insert new List<Event> { event1 };
        account1 = [SELECT Last_Estate_Plan_Review__c FROM Account WHERE Id = :account1.Id];
        System.assertEquals(endTime.date(), account1.Last_Estate_Plan_Review__c);
        
    }
    
    @isTest 
    private static void allDayEvents() {
        DateTime startTime = DateTime.now().addDays(-3);
        Account account1 = new Account(
            Name = 'test'
        );
        insert account1;
        
        Event event1 = new Event(
            WhatId = account1.Id,
            Subject = 'test',
            StartDateTime = startTime,
            IsAllDayEvent = true,
            Meaningful_Activity__c = 'Last Estate Plan Review'
        );
    
        insert new List<Event> { event1 };

        account1 = [SELECT Last_Estate_Plan_Review__c FROM Account WHERE Id = :account1.Id];
        System.assertEquals(startTime.dateGMT(), account1.Last_Estate_Plan_Review__c);
        
    }
    
    @isTest 
    private static void nonallDayEvents() {
        DateTime startTime = DateTime.now().addDays(-3);
        Account account1 = new Account(
            Name = 'test'
        );
        insert account1;
        
        Event event1 = new Event(
            WhatId = account1.Id,
            Subject = 'test',
            StartDateTime = startTime,
            EndDateTime = startTime,
            IsAllDayEvent = false,
            Meaningful_Activity__c = 'Last Estate Plan Review'
        );
    
        insert new List<Event> { event1 };

        account1 = [SELECT Last_Estate_Plan_Review__c FROM Account WHERE Id = :account1.Id];
        System.assertEquals(startTime.date(), account1.Last_Estate_Plan_Review__c);
        
    }
    
    @isTest
    private static void testIsClosedEventForPastEvents(){
      List<Event> events = new List<Event>();
      DateTime startTime = DateTime.now().addDays(-3);
      DateTime endTime = DateTime.now().addDays(-1);
        Account account1 = new Account(
            Name = 'test'
        );
        insert account1;
        
        //Insert a closed event
        Event event1 = new Event(
            WhatId = account1.Id,
            Subject = 'test',
            StartDateTime = startTime,
            EndDateTime = endTime,
            IsAllDayEvent = false,
            Meaningful_Activity__c = 'Last Estate Plan Review'
        );
      
      events.add(event1);
      
      //Insert a closed event
        Event event2 = new Event(
            WhatId = account1.Id,
            Subject = 'test',
            StartDateTime = startTime,
            EndDateTime = endTime,
            IsAllDayEvent = false,
            Meaningful_Activity__c = 'Last Estate Plan Review'
        );
      
      events.add(event2);
      
       //Insert an all day closed event
        Event event3 = new Event(
            WhatId = account1.Id,
            Subject = 'test',
            StartDateTime = startTime,
            EndDateTime = startTime,
            IsAllDayEvent = true,
            Meaningful_Activity__c = 'Last Estate Plan Review'
        );
        
        events.add(event3);
        
         //Insert an all day closed event
        Event event4 = new Event(
            WhatId = account1.Id,
            Subject = 'test',
            StartDateTime = startTime,
            EndDateTime = startTime,
            IsAllDayEvent = true,
            Meaningful_Activity__c = 'Last Estate Plan Review'
        );
      
      events.add(event4);
      
      // Insert events
      insert events;
      
      // Verify event 1 was inserted
        system.assertNotEquals(event1.Id, null);
        
        // Is Event Closed should be true because we created a past event
        system.assertEquals([Select Is_Event_Closed__c from Event where Id =: event1.Id].Is_Event_Closed__c, true);
        
        // Verify event 2 was inserted
        system.assertNotEquals(event2.Id, null);
        
        // Is Event Closed should be true because we created a past event
        system.assertEquals([Select Is_Event_Closed__c from Event where Id =: event2.Id].Is_Event_Closed__c, true);
        
       
      // Verify event 3 was inserted
        system.assertNotEquals(event3.Id, null);
        
        // Is Event Closed should be true because we created a past event
        system.assertEquals([Select Is_Event_Closed__c from Event where Id =: event3.Id].Is_Event_Closed__c, true);
        
         // Verify event 4 was inserted
        system.assertNotEquals(event4.Id, null);
        
        // Is Event Closed should be true because we created a past event
        system.assertEquals([Select Is_Event_Closed__c from Event where Id =: event4.Id].Is_Event_Closed__c, true);
        
       
       //Reopen event 1: extend end date time
       event1.EndDateTime = system.now().addDays(1);
       update event1;
       
       // Is Event Closed should be false because we changed the end time for the event to be in the future
       system.assertEquals([Select Is_Event_Closed__c from Event where Id =: event1.Id].Is_Event_Closed__c, false);
   
       //Reopen event 2: change start date to be greater than now
       event2.StartDateTime = system.now().addDays(1);
       event2.EndDateTime = system.now().addDays(2);
       update event2;
       
       // Is Event Closed should be false because we changed the end time for the event to be in the future
       system.assertEquals([Select Is_Event_Closed__c from Event where Id =: event2.Id].Is_Event_Closed__c, false);
   
       //Reopen event 3: extend end date time
       event3.EndDateTime = system.now().addDays(1);
       update event3;
       
       // Is Event Closed should be false because we changed the end time for the event to be in the future
       system.assertEquals([Select Is_Event_Closed__c from Event where Id =: event3.Id].Is_Event_Closed__c, false);
   
       //Reopen event 4: change start date to be greater than now
       event4.StartDateTime = system.now().addDays(1);
       event4.EndDateTime = system.now().addDays(2);
       update event4;
       
       // Is Event Closed should be false because we changed the end time for the event to be in the future
       system.assertEquals([Select Is_Event_Closed__c from Event where Id =: event4.Id].Is_Event_Closed__c, false);
   
       
    }
    
   
    @isTest
    private static void testIsClosedEventForFutureEvents(){
      List<Event> events = new List<Event>();
      DateTime startTime = DateTime.now().addDays(3);
      DateTime endTime = DateTime.now().addDays(4);
        Account account1 = new Account(
            Name = 'test'
        );
        insert account1;
        
        //Insert a future event
        Event event1 = new Event(
            WhatId = account1.Id,
            Subject = 'test',
            StartDateTime = startTime,
            EndDateTime = endTime,
            IsAllDayEvent = false,
            Meaningful_Activity__c = 'Last Estate Plan Review'
        );
      
      events.add(event1);
      
      //Insert a future event
        Event event2 = new Event(
            WhatId = account1.Id,
            Subject = 'test',
            StartDateTime = startTime,
            EndDateTime = endTime,
            IsAllDayEvent = false,
            Meaningful_Activity__c = 'Last Estate Plan Review'
        );
      
      events.add(event2);
      
       //Insert an all day future event
        Event event3 = new Event(
            WhatId = account1.Id,
            Subject = 'test',
            StartDateTime = startTime,
            EndDateTime = startTime,
            IsAllDayEvent = true,
            Meaningful_Activity__c = 'Last Estate Plan Review'
        );
        
        events.add(event3);
        
         //Insert an all day future event
        Event event4 = new Event(
            WhatId = account1.Id,
            Subject = 'test',
            StartDateTime = startTime,
            EndDateTime = startTime,
            IsAllDayEvent = true,
            Meaningful_Activity__c = 'Last Estate Plan Review'
        );
      
      events.add(event4);
      
      // Insert events
      insert events;
      
      // Verify event 1 was inserted
        system.assertNotEquals(event1.Id, null);
        
        // Is Event Closed should be false because we created an event in the future
        system.assertEquals([Select Is_Event_Closed__c from Event where Id =: event1.Id].Is_Event_Closed__c, false);
        
        // Verify event 2 was inserted
        system.assertNotEquals(event2.Id, null);
        
        // Is Event Closed should be false because we created an event in the future
        system.assertEquals([Select Is_Event_Closed__c from Event where Id =: event2.Id].Is_Event_Closed__c, false);
        
       
      // Verify event 3 was inserted
        system.assertNotEquals(event3.Id, null);
        
        // Is Event Closed should be false because we created an event in the future
        system.assertEquals([Select Is_Event_Closed__c from Event where Id =: event3.Id].Is_Event_Closed__c, false);
        
         // Verify event 4 was inserted
        system.assertNotEquals(event4.Id, null);
        
        // Is Event Closed should be false because we created an event in the future
        system.assertEquals([Select Is_Event_Closed__c from Event where Id =: event4.Id].Is_Event_Closed__c, false);
        
        //Update the Is Event Closed field to be true. 
       event4.Is_Event_Closed__c = true;
       update event4;
       
       //Ensure that the field wasn't updated because it is closed event
       system.assertEquals([Select Is_Event_Closed__c from Event where Id =: event4.Id].Is_Event_Closed__c, false);
       
       
       //Reopen event 1: end date tiem should be equals to now
       event1.StartDateTime = system.now().addHours(-1);
       event1.EndDateTime = system.now();
       update event1;
       
       // Is Event Closed should be true because we changed the end time for the event to be in the past
       system.assertEquals([Select Is_Event_Closed__c from Event where Id =: event1.Id].Is_Event_Closed__c, true);
   
       //Reopen event 2: end date tiem should be <= than now
       event2.StartDateTime = system.now().addDays(-2);
       event2.EndDateTime = system.now().addDays(-1);
       update event2;
       
       // Is Event Closed should be true because we changed the end time for the event to be in the past
       system.assertEquals([Select Is_Event_Closed__c from Event where Id =: event2.Id].Is_Event_Closed__c, true);
   
       //Reopen event 1: end date tiem should be equals to now
       event3.StartDateTime = system.now().addDays(-1);
       event3.EndDateTime = system.now();
       update event3;
       
       // Is Event Closed should be true because we changed the end time for the event to be today
       system.assertEquals([Select Is_Event_Closed__c from Event where Id =: event3.Id].Is_Event_Closed__c, true);
   
       //Reopen event 4: end date tiem should be <= than now
       event4.StartDateTime = system.now().addDays(-2);
       event4.EndDateTime = system.now().addDays(-1);
       update event4;
       
       // Is Event Closed should be true because we changed the end time for the event to be in the past
       system.assertEquals([Select Is_Event_Closed__c from Event where Id =: event4.Id].Is_Event_Closed__c, true);
       
       //Update the Is Event Closed field to be false. 
       event4.Is_Event_Closed__c = false;
       update event4;
       
       //Ensure that the field wasn't updated because it is an open event
       system.assertEquals([Select Is_Event_Closed__c from Event where Id =: event4.Id].Is_Event_Closed__c, true);
       
       
    }
}