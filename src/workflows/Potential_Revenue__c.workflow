<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Notify_Case_Next_Step_Owner_of_assignment</fullName>
        <description>Notify Case Next Step Owner of assignment</description>
        <protected>false</protected>
        <recipients>
            <field>Next_Step_Owner__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>XLR8/Case_Next_Step_Owner_Assigned</template>
    </alerts>
    <alerts>
        <fullName>Notify_Potential_Revenue_Next_Step_Owner_of_assignment</fullName>
        <description>Notify Potential Revenue Next Step Owner of assignment</description>
        <protected>false</protected>
        <recipients>
            <field>Next_Step_Owner__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>XLR8/Potential_Revenue_Next_Step_Owner_Assigned</template>
    </alerts>
    <rules>
        <fullName>Create Task When Potential Revenue Next Step Changes</fullName>
        <active>false</active>
        <description>Fires a Task off to the Next Step Owner whenever Potential Revenue Next Step Field is changed.</description>
        <formula>AND( ISCHANGED(  Next_Step__c  ), NOT(ISBLANK( Next_Step_Owner__c )))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Notify Case Next Step Owner</fullName>
        <actions>
            <name>Notify_Case_Next_Step_Owner_of_assignment</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Fires email to Next Step Owner whenever Next Step Owner or Next Step field is changed.</description>
        <formula>OR( AND( ISCHANGED( Next_Step_Owner__c ), NOT(ISBLANK( Next_Step_Owner__c )) ), AND( ISCHANGED(  Next_Step__c  ), NOT(ISBLANK( Next_Step_Owner__c )) ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Notify Case Next Step Owner On Creation</fullName>
        <actions>
            <name>Notify_Case_Next_Step_Owner_of_assignment</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Potential_Revenue__c.Next_Step_Owner__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Fires email off to Next Step Owner whenever Case Next Step Owner is assigned on record creation.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Notify Potential Revenue Next Step Owner</fullName>
        <active>false</active>
        <description>Fires whenever Potential Revenue Next Step Owner or Next Step field is changed.</description>
        <formula>OR( AND( ISCHANGED( Next_Step_Owner__c ), NOT(ISBLANK( Next_Step_Owner__c )) ), AND( ISCHANGED(  Next_Step__c  ), NOT(ISBLANK( Next_Step_Owner__c )) ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Notify Potential Revenue Next Step Owner On Creation</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Potential_Revenue__c.Next_Step_Owner__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Fires whenever Potential Revenue Next Step Owner is assigned on record creation.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
