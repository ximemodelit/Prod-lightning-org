<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Close_Event</fullName>
        <description>The workflow will update the Event record&apos;s &quot;Is Event Closed&quot; to checked.</description>
        <field>Is_Event_Closed__c</field>
        <literalValue>1</literalValue>
        <name>Close Event</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Meaningful Activity Event Trigger</fullName>
        <active>true</active>
        <description>This workflow rule is required by XLR8 for the Meaningful Activity functionality to work on Event records.  NOTE:  It cannot be packaged in XLR8 so we manually created in each existing client&apos;s org and configured it in Trialforce org for free trials.</description>
        <formula>AND(NOT(ISBLANK( Meaningful_Activity__c )), Is_Event_Closed__c != TRUE )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Close_Event</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Event.EndDateTime</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
