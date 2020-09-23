/**
 * @author aidan@nebulaconsulting.co.uk
 * @date 23/09/2020
 */

public with sharing class FlowTestRecordSource {

    static nebc.TestRecordSource testRecordSource = new nebc.TestRecordSource();

    @InvocableMethod
    public static List<SObject> getRecord(List<TestRecordSpecification> testRecordSpecifications) {
        TestRecordSpecification thisSpecification = testRecordSpecifications[0];
        SObjectType sObjectType = ((SObject)Type.forName(thisSpecification.sObjectType).newInstance()).getSObjectType();

        return testRecordSource.getRecord(sObjectType).asVariant(thisSpecification.variant).withInsert(testRecordSpecifications.size());
    }

    public class TestRecordSpecification {
        @InvocableVariable
        public String sObjectType;
        @InvocableVariable
        public String variant;
    }
}