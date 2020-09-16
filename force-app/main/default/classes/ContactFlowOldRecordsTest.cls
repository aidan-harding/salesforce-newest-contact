/**
 * @author aidan@nebulaconsulting.co.uk
 * @date 27/08/2020
 */

@IsTest
private class ContactFlowOldRecordsTest {

    static nebc.TestRecordSource testRecordSource = new nebc.TestRecordSource();

    @IsTest
    static void testBehavior() {
        String nameBefore = 'Duck';
        String nameAfter = 'Rabbit';

        Contact testContact = (Contact)testRecordSource.getRecord(Contact.SObjectType)
                .put(Contact.LastName, nameBefore)
                .withInsert();

        Test.startTest();
        testContact.LastName = nameAfter;
        update testContact;
        Test.stopTest();

        List<Contact> beforeContacts = FlowOldRecords.getOldRecord(new List<Contact> {testContact});
        System.assertEquals(nameBefore, beforeContacts[0].LastName);
    }
}