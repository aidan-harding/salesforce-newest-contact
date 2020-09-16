/**
 * @author aidan@nebulaconsulting.co.uk
 * @date 08/09/2020
 * @description generic test handler that can be parameterised by the Contact.FirstName and goes through all the
 * scenarios that any solution should address
 */

public class NewestContactTest {
    
    private String componentToTest;
    private nebc.TestRecordSource testRecordSource;

    public NewestContactTest(String componentToTest) {
        this.componentToTest = componentToTest;
        this.testRecordSource = new nebc.TestRecordSource();
    }

    public void singleContact() {
        Account testAccount = (Account)testRecordSource.getRecord(Account.SObjectType).withInsert();

        Test.startTest();
        Contact testContact = (Contact)testRecordSource.getRecord(Contact.SObjectType)
                .put(Contact.FirstName, componentToTest)
                .withInsert();
        Test.stopTest();

        testAccount = [SELECT Newest_Contact__c FROM Account WHERE Id = :testAccount.Id];

        System.assertEquals(testContact.Id, testAccount.Newest_Contact__c);
    }

    public void twoContactsSameAccount() {
        Account testAccount = (Account)testRecordSource.getRecord(Account.SObjectType).withInsert();

        Test.startTest();
        List<Contact> testContacts = testRecordSource.getRecord(Contact.SObjectType)
                .put(Contact.FirstName, componentToTest)
                .withInsert(2);
        Test.stopTest();

        testAccount = [SELECT Newest_Contact__c FROM Account WHERE Id = :testAccount.Id];

        System.assert(testAccount.Newest_Contact__c == testContacts[0].Id || testAccount.Newest_Contact__c == testContacts[1].Id);
    }

    public void twoContactsDifferentAccounts() {
        List<Account> testAccounts = testRecordSource.getRecord(Account.SObjectType).withInsert(2);

        Test.startTest();
        List<Contact> testContacts = testRecordSource.getRecord(Contact.SObjectType)
                .put(Contact.FirstName, componentToTest)
                .withoutInsert(2);
        testContacts[1].AccountId = testAccounts[1].Id;
        insert testContacts;
        Test.stopTest();

        testAccounts[0] = [SELECT Newest_Contact__c FROM Account WHERE Id = :testAccounts[0].Id];
        testAccounts[1] = [SELECT Newest_Contact__c FROM Account WHERE Id = :testAccounts[1].Id];

        System.assertEquals(testContacts[0].Id, testAccounts[0].Newest_Contact__c);
        System.assertEquals(testContacts[1].Id, testAccounts[1].Newest_Contact__c);
    }

    public void noAccount() {
        Account testAccount = (Account)testRecordSource.getRecord(Account.SObjectType).withInsert();

        Test.startTest();
        testRecordSource.getRecord(Contact.SObjectType)
                .put(Contact.FirstName, componentToTest)
                .put(Contact.AccountId, null)
                .withInsert();
        Test.stopTest();

        testAccount = [SELECT Newest_Contact__c FROM Account WHERE Id = :testAccount.Id];

        System.assertEquals(null, testAccount.Newest_Contact__c);
    }

    public void transfer() {
        List<Account> testAccounts = testRecordSource.getRecord(Account.SObjectType).withInsert(2);
        List<Contact> testContacts = testRecordSource.getRecord(Contact.SObjectType)
                .put(Contact.FirstName, componentToTest)
                .withoutInsert(2);

        testContacts[1].AccountId = testAccounts[1].Id;
        insert testContacts;

        Test.setCreatedDate(testContacts[0].Id, Datetime.now().addMinutes(-1));

        Test.startTest();
        testContacts[1].AccountId = testAccounts[0].Id;
        update testContacts[1];
        Test.stopTest();

        testAccounts[0] = [SELECT Newest_Contact__c FROM Account WHERE Id = :testAccounts[0].Id];
        testAccounts[1] = [SELECT Newest_Contact__c FROM Account WHERE Id = :testAccounts[1].Id];

        System.assertEquals(null, testAccounts[1].Newest_Contact__c);
        System.assertEquals(testContacts[1].Id, testAccounts[0].Newest_Contact__c);
    }
}