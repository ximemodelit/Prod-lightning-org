/**
 * Test the class DataMoverDataMappingWrapper
 * @author Ximena Lasserre
 * @since December 2014
 */
@isTest
private class TestDataMoverDataMappingWrapper {

	static testmethod void testSearchAndCopyWrapper(){
		
        DataMoverDataMappingTestUtils dmtu = new DataMoverDataMappingTestUtils();
        SObject source = dmtu.createSourceOrTargetObjectToTestWrapper('source');
        SObject target = dmtu.createSourceOrTargetObjectToTestWrapper('target');        
        
        DataMoverDataMappingWrapper wrapperClass = new DataMoverDataMappingWrapper(source, target);
        
        Test.startTest();
        wrapperClass.updateSourceLookupWithTargetId();
        Test.stopTest();
        
            
	}
}