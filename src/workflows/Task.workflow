<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Set_Completed_Date_to_Today</fullName>
        <field>Completion_Date__c</field>
        <formula>TODAY()</formula>
        <name>Set Completed Date to Today</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Set Completed Date on Task</fullName>
        <actions>
            <name>Set_Completed_Date_to_Today</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.Status</field>
            <operation>equals</operation>
            <value>Completed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Task.Completion_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>This workflow rule will automatically set the Completed Date to &quot;today&quot; when the Status of a Task is set to Completed.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
