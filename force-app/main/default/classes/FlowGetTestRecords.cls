/**
 * @author aidan@nebulaconsulting.co.uk
 * @date 23/09/2020
 */

public with sharing class FlowGetTestRecords {

    @InvocableMethod(Label='Get Test Records')
    public static List<List<SObject>> getRecord(List<TestRecordSpecification> testRecordSpecifications) {
        TestRecordSpecification thisSpecification = testRecordSpecifications[0];
        SObjectType sObjectType = Schema.describeSObjects(new List<String> {thisSpecification.sObjectType })[0].SObjectType;
        List<SObject> theRecords = FlowTestRecordSource.testRecordSource.getRecord(sObjectType).asVariant(thisSpecification.variant).withInsert(thisSpecification.nRecords);
        return new List<List<SObject>> { theRecords };
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