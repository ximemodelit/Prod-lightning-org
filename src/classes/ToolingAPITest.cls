/*
 *Test class for ToolingAPI classes
 *@author Ximena Lasserre
 *@since October 2015
 */
 @isTest
public with sharing class ToolingAPITest {

	static testmethod void ToolingAPITest(){
		ToolingAPIWSDLMetadata metadata = new ToolingAPIWSDLMetadata();
		new ToolingAPIWSDLMetadata.ProfileRecordTypeVisibility();
		new ToolingAPIWSDLMetadata.WorkflowFlowActionParameter();
		new ToolingAPIWSDLMetadata.Attachment();
		new ToolingAPIWSDLMetadata.Picklist();
		new ToolingAPIWSDLMetadata.WorkflowEmailRecipient();
		new ToolingAPIWSDLMetadata.ProfileApexPageAccess();
		new ToolingAPIWSDLMetadata.RecordTypePicklistValue();
		new ToolingAPIWSDLMetadata.Container();
		new ToolingAPIWSDLMetadata.FeedLayout();
		new ToolingAPIWSDLMetadata.RelatedContentItem();
		new ToolingAPIWSDLMetadata.ProfileExternalDataSourceAccess();
		new ToolingAPIWSDLMetadata.ComponentInstance();
		new ToolingAPIWSDLMetadata.MiniLayout();
		new ToolingAPIWSDLMetadata.WorkflowTimeTrigger();
		new ToolingAPIWSDLMetadata.SummaryLayoutItem();
		new ToolingAPIWSDLMetadata.QuickActionList();
		new ToolingAPIWSDLMetadata.FlexiPageRegion();
		new ToolingAPIWSDLMetadata.PrimaryTabComponents();
		new ToolingAPIWSDLMetadata.QuickActionListItem();
		new ToolingAPIWSDLMetadata.LayoutSection();
		new ToolingAPIWSDLMetadata.EscalationAction();
		new ToolingAPIWSDLMetadata.ProfileObjectPermissions();
		new ToolingAPIWSDLMetadata.ProfileApexClassAccess();
		new ToolingAPIWSDLMetadata.ProfileLoginIpRange();
		new ToolingAPIWSDLMetadata.SubtabComponents();
		new ToolingAPIWSDLMetadata.FeedLayoutFilter();
		new ToolingAPIWSDLMetadata.ComponentInstanceProperty();
		new ToolingAPIWSDLMetadata.ProfileFieldLevelSecurity();
		new ToolingAPIWSDLMetadata.ProfileCustomPermissions();
		new ToolingAPIWSDLMetadata.FeedLayoutComponent();
		new ToolingAPIWSDLMetadata.ProfileApplicationVisibility();
		new ToolingAPIWSDLMetadata.RelatedListItem();
		new ToolingAPIWSDLMetadata.FTestGeneratedEntityComplexValueSuperType();
		new ToolingAPIWSDLMetadata.SummaryLayout();
		new ToolingAPIWSDLMetadata.Metadata();
		new ToolingAPIWSDLMetadata.PackageVersion();
		new ToolingAPIWSDLMetadata.LayoutItem();
		new ToolingAPIWSDLMetadata.ProfileTabVisibility();
		new ToolingAPIWSDLMetadata.LookupFilter();
		new ToolingAPIWSDLMetadata.ProfileLoginHours();
		new ToolingAPIWSDLMetadata.SidebarComponent();
		new ToolingAPIWSDLMetadata.CustomConsoleComponents();
		new ToolingAPIWSDLMetadata.LayoutColumn();
		new ToolingAPIWSDLMetadata.ProfileUserPermission();
		new ToolingAPIWSDLMetadata.RelatedContent();
		new ToolingAPIWSDLMetadata.WorkflowActionReference();
		new ToolingAPIWSDLMetadata.FilterItem();
		new ToolingAPIWSDLMetadata.ReportChartComponentLayoutItem();
		new ToolingAPIWSDLMetadata.RelatedList();
		new ToolingAPIWSDLMetadata.RuleEntry();
		new ToolingAPIWSDLMetadata.FTestGeneratedEntityComplexValueType();
		new ToolingAPIWSDLMetadata.FTestGeneratedEntityComplexValueType2();
		new ToolingAPIWSDLMetadata.AutoResponseRules();
		new ToolingAPIWSDLMetadata.FlexiPage();
		new ToolingAPIWSDLMetadata.CustomObject();
		new ToolingAPIWSDLMetadata.WorkflowFieldUpdate();
		new ToolingAPIWSDLMetadata.PicklistValue();
		new ToolingAPIWSDLMetadata.Workflow();
		new ToolingAPIWSDLMetadata.ValidationRule();
		new ToolingAPIWSDLMetadata.ApexClass();
		new ToolingAPIWSDLMetadata.RecordType();
		new ToolingAPIWSDLMetadata.CompactLayout();
		new ToolingAPIWSDLMetadata.Layout();
		new ToolingAPIWSDLMetadata.CustomField();
		new ToolingAPIWSDLMetadata.ApexComponent();
		new ToolingAPIWSDLMetadata.AutoResponseRule();
		
		ToolingAPIWSDL apiWsdl = new ToolingAPIWSDL();
		new ToolingAPIWSDL.InvalidateSessionsResult();
		new ToolingAPIWSDL.sObject_x();
		new ToolingAPIWSDL.queryResponse_element();
		new ToolingAPIWSDL.CallOptions_element();
		new ToolingAPIWSDL.SaveResult();		
		new ToolingAPIWSDL.upsert_element();
		new ToolingAPIWSDL.updateResponse_element();
		new ToolingAPIWSDL.executeAnonymous_element();
		new ToolingAPIWSDL.RecordTypeInfo();		
		new ToolingAPIWSDL.ValueTypeField();
		new ToolingAPIWSDL.describeSObjectsResponse_element();
		new ToolingAPIWSDL.UpsertResult();
		new ToolingAPIWSDL.create_element();
		new ToolingAPIWSDL.ExecuteAnonymousResult();
		new ToolingAPIWSDL.SetPasswordResult();
		new ToolingAPIWSDL.retrieve_element();
		new ToolingAPIWSDL.DeleteResult();
		new ToolingAPIWSDL.query_element();
		new ToolingAPIWSDL.DebuggingHeader_element();
		new ToolingAPIWSDL.QueryResultColumnMetadata();
		new ToolingAPIWSDL.PackageVersion();
		new ToolingAPIWSDL.AllowedWorkitemAction();
		new ToolingAPIWSDL.SearchRecord();
		new ToolingAPIWSDL.ApiFault();
		new ToolingAPIWSDL.describeWorkitemActions_element();
		new ToolingAPIWSDL.RunTestSuccess();
		new ToolingAPIWSDL.LogInfo();
		new ToolingAPIWSDL.DeletedRecord();
		new ToolingAPIWSDL.SearchResult();
		new ToolingAPIWSDL.QueryResultMetadata();
		new ToolingAPIWSDL.login_element();
		new ToolingAPIWSDL.GetUserInfoResult();
		new ToolingAPIWSDL.Parameter();
		new ToolingAPIWSDL.getServerTimestamp_element();
		new ToolingAPIWSDL.executeAnonymousResponse_element();
		new ToolingAPIWSDL.loginResponse_element();
		new ToolingAPIWSDL.describeGlobalResponse_element();
		new ToolingAPIWSDL.CodeCoverageResult();
		new ToolingAPIWSDL.getServerTimestampResponse_element();
		new ToolingAPIWSDL.describeSObjects_element();
		new ToolingAPIWSDL.queryMoreResponse_element();
		new ToolingAPIWSDL.DescribeValueTypeResult();
		new ToolingAPIWSDL.describeGlobal_element();
		new ToolingAPIWSDL.describeValueTypeResponse_element();
		new ToolingAPIWSDL.setPasswordResponse_element();
		new ToolingAPIWSDL.ActionOverride();
		new ToolingAPIWSDL.describeWorkitemActionsResponse_element();
		new ToolingAPIWSDL.runTestsResponse_element();
		new ToolingAPIWSDL.DescribeGlobalResult();
		new ToolingAPIWSDL.searchResponse_element();
		new ToolingAPIWSDL.HeapAddress();
		new ToolingAPIWSDL.FilteredLookupInfo();
		new ToolingAPIWSDL.Field();
		new ToolingAPIWSDL.invalidateSessionsResponse_element();
		new ToolingAPIWSDL.PicklistEntry();
		new ToolingAPIWSDL.AllowFieldTruncationHeader_element();
		new ToolingAPIWSDL.CodeCoverageWarning();
		new ToolingAPIWSDL.DebuggingInfo_element();
		new ToolingAPIWSDL.DescribeSObjectResult();
		new ToolingAPIWSDL.deleteResponse_element();
		new ToolingAPIWSDL.Coverage();
		new ToolingAPIWSDL.update_element();
		new ToolingAPIWSDL.ChildRelationship();
		new ToolingAPIWSDL.runTestsAsynchronous_element();
		new ToolingAPIWSDL.SearchSnippet();
		new ToolingAPIWSDL.ExternalReference();
		new ToolingAPIWSDL.RunTestsResult();
		new ToolingAPIWSDL.RunTestsRequest();
		new ToolingAPIWSDL.describeSObject_element();
		new ToolingAPIWSDL.getDeleted_element();
		new ToolingAPIWSDL.DeployDetails();
		new ToolingAPIWSDL.Position();
		new ToolingAPIWSDL.invalidateSessions_element();
		new ToolingAPIWSDL.DeployMessage();
		new ToolingAPIWSDL.SessionHeader_element();
		new ToolingAPIWSDL.StateValue();
		new ToolingAPIWSDL.setPassword_element();
		new ToolingAPIWSDL.GetUpdatedResult();
		new ToolingAPIWSDL.search_element();
		new ToolingAPIWSDL.MetadataWarningsHeader_element();
		new ToolingAPIWSDL.createResponse_element();
		new ToolingAPIWSDL.SOQLResult();
		new ToolingAPIWSDL.logout_element();
		new ToolingAPIWSDL.GetServerTimestampResult();
		new ToolingAPIWSDL.QueryResult();
		new ToolingAPIWSDL.delete_element();
		new ToolingAPIWSDL.GetDeletedResult();
		new ToolingAPIWSDL.queryMore_element();
		new ToolingAPIWSDL.CodeLocation();
		new ToolingAPIWSDL.getUserInfo_element();
		new ToolingAPIWSDL.TypeExtent();
		new ToolingAPIWSDL.MapEntry();
		new ToolingAPIWSDL.runTestsAsynchronousResponse_element();
		new ToolingAPIWSDL.LoginResult();
		new ToolingAPIWSDL.upsertResponse_element();
		new ToolingAPIWSDL.retrieveResponse_element();
		new ToolingAPIWSDL.ExternalSymbol();
		new ToolingAPIWSDL.getDeletedResponse_element();
		new ToolingAPIWSDL.getUserInfoResponse_element();
		new ToolingAPIWSDL.RunTestFailure();
		new ToolingAPIWSDL.DescribeWorkitemActionResult();
		new ToolingAPIWSDL.NamedLayoutInfo();
		new ToolingAPIWSDL.queryAll_element();
		new ToolingAPIWSDL.PackageVersionHeader_element();
		new ToolingAPIWSDL.getUpdated_element();
		new ToolingAPIWSDL.DisableFeedTrackingHeader_element();
		new ToolingAPIWSDL.runTests_element();
		new ToolingAPIWSDL.DescribeGlobalSObjectResult();
		new ToolingAPIWSDL.Symbol();
		new ToolingAPIWSDL.AttributeDefinition();
		new ToolingAPIWSDL.describeValueType_element();
		new ToolingAPIWSDL.HeapDump();
		new ToolingAPIWSDL.NameValuePair();
		new ToolingAPIWSDL.Error();
		new ToolingAPIWSDL.SymbolTable();
		new ToolingAPIWSDL.logoutResponse_element();
		new ToolingAPIWSDL.ApexResult();
		new ToolingAPIWSDL.getUpdatedResponse_element();
		new ToolingAPIWSDL.describeSObjectResponse_element();
		new ToolingAPIWSDL.queryAllResponse_element();
		new ToolingAPIWSDL.ApexTestResult();
		new ToolingAPIWSDL.InvalidSObjectFault();
		new ToolingAPIWSDL.CompactLayoutInfo();
		new ToolingAPIWSDL.WorkflowFieldUpdate();
		new ToolingAPIWSDL.AssignmentRule();
		new ToolingAPIWSDL.ExternalConstructor();
		new ToolingAPIWSDL.Method();
		new ToolingAPIWSDL.ApexClass();
		new ToolingAPIWSDL.ApexExecutionOverlayAction();
		new ToolingAPIWSDL.UnexpectedErrorFault();
		new ToolingAPIWSDL.ApexCodeCoverageAggregate();
		new ToolingAPIWSDL.ApexOrgWideCoverage();
		new ToolingAPIWSDL.QuickActionDefinition();
		new ToolingAPIWSDL.PrimitiveQueryResultColumnMetadata();
		new ToolingAPIWSDL.MapValue();
		new ToolingAPIWSDL.EntityDefinition();
		new ToolingAPIWSDL.MalformedSearchFault();
		new ToolingAPIWSDL.CompactLayoutItemInfo();
		new ToolingAPIWSDL.Layout();
		new ToolingAPIWSDL.ApexCodeCoverage();
		new ToolingAPIWSDL.ApexComponent();
		new ToolingAPIWSDL.AutoResponseRule();
		new ToolingAPIWSDL.Name();
		new ToolingAPIWSDL.IDEWorkspace();
		new ToolingAPIWSDL.QuickActionList();
		new ToolingAPIWSDL.QuickActionListItem();
		new ToolingAPIWSDL.TraceFlag();
		new ToolingAPIWSDL.ListValue();
		new ToolingAPIWSDL.AggregateQueryResultColumnMetadata();
		new ToolingAPIWSDL.ApexTriggerMember();
		new ToolingAPIWSDL.RecentlyViewed();
		new ToolingAPIWSDL.ValidationRule();
		new ToolingAPIWSDL.WorkflowAlert();
		new ToolingAPIWSDL.EmailTemplate();
		new ToolingAPIWSDL.WorkflowTask();
		new ToolingAPIWSDL.ApexComponentMember();
		new ToolingAPIWSDL.ApexTrigger();
		new ToolingAPIWSDL.StaticResource();
		new ToolingAPIWSDL.MenuItem();
		new ToolingAPIWSDL.IDEPerspective();
		new ToolingAPIWSDL.ApexPage();
		new ToolingAPIWSDL.BusinessProcess();
		new ToolingAPIWSDL.ExternalMethod();
		new ToolingAPIWSDL.BooleanValue();
		new ToolingAPIWSDL.UserPreference();
		new ToolingAPIWSDL.ContainerAsyncRequest();
		new ToolingAPIWSDL.StringValue();
		new ToolingAPIWSDL.FlexiPage();
		new ToolingAPIWSDL.CustomObject();
		new ToolingAPIWSDL.InvalidQueryLocatorFault();
		new ToolingAPIWSDL.WorkflowOutboundMessage();
		new ToolingAPIWSDL.InvalidNewPasswordFault();
		new ToolingAPIWSDL.Profile();
		new ToolingAPIWSDL.FieldSet();
		new ToolingAPIWSDL.MetadataContainerMember();
		new ToolingAPIWSDL.NumberValue();
		new ToolingAPIWSDL.AsyncApexJob();
		new ToolingAPIWSDL.WorkflowRuleMember();
		new ToolingAPIWSDL.ApexTestQueueItem();
		new ToolingAPIWSDL.CompactLayout();
		new ToolingAPIWSDL.Constructor();
		new ToolingAPIWSDL.LoginFault();
		new ToolingAPIWSDL.AggregateExpressionResultColumnMetadata();
		new ToolingAPIWSDL.WorkflowFieldUpdateMember();
		new ToolingAPIWSDL.FieldDefinition();
		new ToolingAPIWSDL.ProfileLayout();
		new ToolingAPIWSDL.ApexPageMember();
		new ToolingAPIWSDL.InvalidIdFault();
		new ToolingAPIWSDL.ApexClassMember();
		new ToolingAPIWSDL.ApexExecutionOverlayResult();
		new ToolingAPIWSDL.WorkflowRule();
		new ToolingAPIWSDL.User_x();
		new ToolingAPIWSDL.CustomTab();
		new ToolingAPIWSDL.RecordType();
		new ToolingAPIWSDL.ComplexQueryResultColumnMetadata();
		new ToolingAPIWSDL.InvalidFieldFault();
		new ToolingAPIWSDL.MetadataContainer();
		new ToolingAPIWSDL.ApexLog();
		new ToolingAPIWSDL.CustomField();
		new ToolingAPIWSDL.VisibilitySymbol();
		new ToolingAPIWSDL.ApiQueryFault();
		new ToolingAPIWSDL.MalformedQueryFault();
		new ToolingAPIWSDL.SetValue();
		new ToolingAPIWSDL.SforceService();		
		
		
	}
}