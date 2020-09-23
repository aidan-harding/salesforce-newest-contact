/**
 * @author aidan@nebulaconsulting.co.uk
 * @date 23/09/2020
 */

public with sharing class FlowGetTestRecords {

    @InvocableMethod(Label='Get Test Records')
    public static List<List<SObject>> getRecord(List<TestRecordSpecification> testRecordSpecifications) {
        TestRecordSpecification thisSpecification = testRecordSpecifications[0];
        SObjectType sObjectType = ((SObject)Type.forName(thisSpecification.sObjectType).newInstance()).getSObjectType();
        List<SObject> theRecords = FlowTestRecordSource.testRecordSource.getRecord(sObjectType).asVariant(thisSpecification.variant).withInsert(thisSpecification.nRecords);
        List<List<SObject>> results = new List<List<SObject>>();
        for(Integer i=0; i < testRecordSpecifications.size(); i++) {
            results.add(theRecords);
        }
        return results;
    }

    public class TestRecordSpecification {
        @InvocableVariable
        public String sObjectType;
        @InvocableVariable
        public String variant;
        @InvocableVariable
        public Integer nRecords;
    }
}