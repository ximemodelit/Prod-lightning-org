<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Notify_Admin_That_a_Suggestion_was_Created</fullName>
        <description>Notify Admin That a Suggestion was Created</description>
        <protected>true</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>XLR8/New_Suggestion_Created</template>
    </alerts>
    <alerts>
        <fullName>Notify_Creator_that_the_Suggestion_has_been_edited</fullName>
        <description>Notify Creator that the Suggestion has been edited</description>
        <protected>true</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>XLR8/Suggestion_Updated</template>
    </alerts>
    <alerts>
        <fullName>Send_Suggestion_Owner_an_Email_when_it_is_updated_by_user</fullName>
        <description>Send Suggestion Owner an Email when it is updated by user</description>
        <protected>true</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>XLR8/Suggestion_Updated</template>
    </alerts>
    <fieldUpdates>
        <fullName>Set_Completed_Date</fullName>
        <field>Completion_Date__c</field>
        <formula>TODAY()</formula>
        <name>Set Completed Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Owner_to_Admin</fullName>
        <field>OwnerId</field>
        <lookupValue>cmescall@xlr8prod.org</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Set Owner to Admin</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Suggestion - Close Record</fullName>
        <actions>
            <name>Set_Completed_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>XLR8_Suggestions__c.Status__c</field>
            <operation>equals</operation>
            <value>Implemented (Features),Denied,Resolved (Questions)</value>
        </criteriaItems>
        <description>When a suggestion is closed, set the completion date to the day it is closed.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Suggestion - Notify Admin on Update</fullName>
        <actions>
            <name>Send_Suggestion_Owner_an_Email_when_it_is_updated_by_user</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>When a suggestion is modified, send an email to the Admin.</description>
        <formula>AND(NOT(ISNEW()), ISCHANGED( Detail__c ), OwnerId &lt;&gt; $User.Id )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Suggestion - Notify Creator On Update</fullName>
        <actions>
            <name>Notify_Creator_that_the_Suggestion_has_been_edited</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>When a suggestion is modified, send an email to the Creator of the suggestion.</description>
        <formula>AND(NOT(ISNEW()),  OR(ISCHANGED(Admin_Comments__c ),  ISCHANGED( Detail__c),  ISCHANGED( Status__c ),  ISCHANGED( Subject__c ),  ISCHANGED( Suggestion_Type__c )))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Suggestion Created - Notify Admin</fullName>
        <actions>
            <name>Notify_Admin_That_a_Suggestion_was_Created</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Set_Owner_to_Admin</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>XLR8_Suggestions__c.CreatedDate</field>
            <operation>equals</operation>
            <value>TODAY</value>
        </criteriaItems>
        <description>When a suggestion is created, send an email to the Admin.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
