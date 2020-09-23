/**
 * @author aidan@nebulaconsulting.co.uk
 * @date 23/09/2020
 */

public with sharing class FlowGetTestRecord {

    @InvocableMethod(Label='Get Test Record')
    public static List<SObject> getRecord(List<TestRecordSpecification> testRecordSpecifications) {
        TestRecordSpecification thisSpecification = testRecordSpecifications[0];
        SObjectType sObjectType = ((SObject)Type.forName(thisSpecification.sObjectType).newInstance()).getSObjectType();
        SObject theRecord = FlowTestRecordSource.testRecordSource.getRecord(sObjectType).asVariant(thisSpecification.variant).withInsert();
        List<SObject> results = new List<SObject>();
        for(Integer i=0; i < testRecordSpecifications.size(); i++) {
            results.add(theRecord);
        }
        return results;
    }

    public class TestRecordSpecification {
        @InvocableVariable
        public String sObjectType;
        @InvocableVariable
        public String variant;
    }
}