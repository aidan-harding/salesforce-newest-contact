/**
 * @author aidan@nebulaconsulting.co.uk
 * @date 23/09/2020
 */

public with sharing class FlowGetTestRecord {

    @InvocableMethod(Label='Get Test Record')
    public static List<SObject> getRecord(List<TestRecordSpecification> testRecordSpecifications) {
        TestRecordSpecification thisSpecification = testRecordSpecifications[0];
        SObjectType sObjectType = Schema.describeSObjects(new List<String> {thisSpecification.sObjectType })[0].SObjectType;
        SObject theRecord = FlowTestRecordSource.testRecordSource.getRecord(sObjectType).asVariant(thisSpecification.variant).withInsert();
        return new List<SObject> { theRecord };
    }

    public class TestRecordSpecification {
        @InvocableVariable
        public String sObjectType;
        @InvocableVariable
        public String variant;
    }
}