<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>NotifyClientServiceAdminofAddressChange</fullName>
        <description>Notify Client Service Admin of Address Change</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>XLR8/ClientAddressChangeNotification</template>
    </alerts>
    <alerts>
        <fullName>Terminated_Client_Notification_to_Team</fullName>
        <description>Terminated Client Notification to Team</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>XLR8/Terminated_Client</template>
    </alerts>
    <fieldUpdates>
        <fullName>Update_Hierarchy_Group_ID_As_Text</fullName>
        <description>Update the Hierarchy Group ID as Text field with the value from the Hierarchy Group ID.</description>
        <field>Hierarchy_Id_As_Text__c</field>
        <formula>Hierarchy_Group_ID__c</formula>
        <name>Update Hierarchy Group ID As Text</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Client Address Change %28Sample%29</fullName>
        <actions>
            <name>NotifyClientServiceAdminofAddressChange</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>XLR8 workflow rule sample which evaluates address fields on the Entity and notifyies the Client Service Admin of any changes.  Note: Configuration is required on client account to make this rule work.</description>
        <formula>OR( AND(ISPICKVAL( Active_Status__c, &quot;Active&quot; ), ISPICKVAL(Address_for_Mail_Merge__c, &quot;Primary&quot;),ISCHANGED(  Primary_Address_Formatted__c)), AND(ISPICKVAL( Active_Status__c, &quot;Active&quot; ), ISPICKVAL(Address_for_Mail_Merge__c, &quot;Secondary&quot;),ISCHANGED(  Secondary_Address_Formatted__c)), AND(ISPICKVAL( Active_Status__c, &quot;Active&quot; ), ISPICKVAL(Address_for_Mail_Merge__c, &quot;Third&quot;),ISCHANGED(  Third_Address_Formatted__c)), AND(ISPICKVAL( Active_Status__c, &quot;Active&quot; ), ISPICKVAL(Address_for_Mail_Merge__c, &quot;Fourth&quot;),ISCHANGED(  Fourth_Address_Formatted__c)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Terminated Client</fullName>
        <actions>
            <name>Terminated_Client_Notification_to_Team</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Terminated_Client_Mail_Terminated_Letter</name>
            <type>Task</type>
        </actions>
        <actions>
            <name>Terminated_Client_Notify_Custodian</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <description>When a client entity record&apos;s Active Status is changed to Terminated, a series of tasks will be assigned and an email alert sent to the team.  Note: Record Type ID will be different for each org therefore could not be incoroporated.</description>
        <formula>AND(ISCHANGED(Active_Status__c ), ISPICKVAL(Active_Status__c, &quot;Terminated&quot;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Hierarchy Group ID As Text</fullName>
        <actions>
            <name>Update_Hierarchy_Group_ID_As_Text</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Name</field>
            <operation>notContain</operation>
            <value>TestX</value>
        </criteriaItems>
        <description>This workflow rule updates the Hierarchy Group ID as Text field with the value from the Hierarchy Group ID and runs every time an Entity is created or edited.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <tasks>
        <fullName>Terminated_Client_Mail_Terminated_Letter</fullName>
        <assignedToType>owner</assignedToType>
        <description>Mail the client termination letter.</description>
        <dueDateOffset>15</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Terminated Client:  Mail Terminated Letter</subject>
    </tasks>
    <tasks>
        <fullName>Terminated_Client_Notify_Custodian</fullName>
        <assignedToType>owner</assignedToType>
        <description>Notify the client&apos;s custodian that you have terminated your relationship with the client.</description>
        <dueDateOffset>15</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Terminated Client: Notify Custodian</subject>
    </tasks>
</Workflow>
