<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Reset_OK_to_Change_Birthdate_Checkbox</fullName>
        <description>Resets the checkbox to false.</description>
        <field>OK_to_Change_Birthdate__c</field>
        <literalValue>0</literalValue>
        <name>Reset OK to Change Birthdate Checkbox</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Deceased Client</fullName>
        <actions>
            <name>Deceased_Contact_Notify_Custodian</name>
            <type>Task</type>
        </actions>
        <actions>
            <name>Deceased_Contact_Send_Card_to_Family</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <description>When a Contact record is marked deceased, a series of tasks will be sent out.</description>
        <formula>AND(ISCHANGED(Deceased__c ),Deceased__c=true)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Reset OK to Change Birthdate Checkbox</fullName>
        <actions>
            <name>Reset_OK_to_Change_Birthdate_Checkbox</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Contact.OK_to_Change_Birthdate__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>This resets the OK to Change Birthdate back to un-checked after used to change a birthdate.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <tasks>
        <fullName>Deceased_Contact_Notify_Custodian</fullName>
        <assignedToType>accountOwner</assignedToType>
        <description>Contact the client&apos;s custodian and notify them of the death.</description>
        <dueDateOffset>30</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Deceased Contact: Notify Custodian</subject>
    </tasks>
    <tasks>
        <fullName>Deceased_Contact_Send_Card_to_Family</fullName>
        <assignedToType>accountOwner</assignedToType>
        <description>Have team sign card and then mail to family.</description>
        <dueDateOffset>1</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Deceased Contact:  Send Card to Family</subject>
    </tasks>
</Workflow>
