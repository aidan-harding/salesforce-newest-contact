/**
 * @author aidan@nebulaconsulting.co.uk
 * @date 08/09/2020
 * @description generic test handler that can be parameterised by the Contact.FirstName and goes through all the
 * scenarios that any solution should address
 */

public class ContactNewestContactTest {
    
    private String componentToTest;
    private nebc.TestRecordSource testRecordSource;
    private Long timeBefore;
    private Integer cpuTimeBefore;

    public ContactNewestContactTest(String componentToTest) {
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
        measureBefore();
        testContacts[1].AccountId = testAccounts[0].Id;
        update testContacts[1];
        debugMeasures();
        Test.stopTest();

        testAccounts[0] = [SELECT Newest_Contact__c FROM Account WHERE Id = :testAccounts[0].Id];
        testAccounts[1] = [SELECT Newest_Contact__c FROM Account WHERE Id = :testAccounts[1].Id];

        System.assertEquals(null, testAccounts[1].Newest_Contact__c);
        System.assertEquals(testContacts[1].Id, testAccounts[0].Newest_Contact__c);
    }

    public void transferToNull() {
        Account testAccount = (Account)testRecordSource.getRecord(Account.SObjectType).withInsert();
        Contact testContact = (Contact)testRecordSource.getRecord(Contact.SObjectType)
                .put(Contact.FirstName, componentToTest)
                .withInsert();

        Test.startTest();
        testContact.AccountId = null;
        update testContact;
        Test.stopTest();

        testAccount = [SELECT Newest_Contact__c FROM Account WHERE Id = :testAccount.Id];

        System.assertEquals(null, testAccount.Newest_Contact__c);
    }

    public void bulkTransfer(Integer nRecords) {
        List<Account> testAccounts = testRecordSource.getRecord(Account.SObjectType).withInsert(nRecords);
        List<Contact> testContacts = testRecordSource.getRecord(Contact.SObjectType)
                .put(Contact.FirstName, componentToTest)
                .withoutInsert(nRecords);

        for(Integer i=1; i < nRecords; i++ ) {
            testContacts[i].AccountId = testAccounts[i].Id;
        }
        insert testContacts;
        for(Integer i=1; i < nRecords; i++ ) {
            Test.setCreatedDate(testContacts[i].Id, Datetime.now().addMinutes(-i));
        }

        Test.startTest();
        measureBefore();
        for(Integer i=0; i < nRecords-1; i++ ) {
            testContacts[i].AccountId = testAccounts[i+1].Id;
        }
        update testContacts;
        debugMeasures();
        Test.stopTest();

        testAccounts = [SELECT Newest_Contact__c FROM Account WHERE Id = :testAccounts];

        for(Integer i=0; i < nRecords-1; i++ ) {
            System.assertEquals(testContacts[i].Id, testAccounts[i+1].Newest_Contact__c);
        }
        System.assertEquals(null, testAccounts[0].Newest_Contact__c);

    }

    public void deleteSingle() {
        Account testAccount = (Account)testRecordSource.getRecord(Account.SObjectType).withInsert();
        Contact testContact = (Contact)testRecordSource.getRecord(Contact.SObjectType)
                .put(Contact.FirstName, componentToTest)
                .withInsert();

        testAccount = [SELECT Newest_Contact__c FROM Account WHERE Id = :testAccount.Id];
        System.assertEquals(testContact.Id, testAccount.Newest_Contact__c);

        Test.startTest();
        delete testContact;
        Test.stopTest();

        testAccount = [SELECT Newest_Contact__c FROM Account WHERE Id = :testAccount.Id];
        System.assertEquals(null, testAccount.Newest_Contact__c);
    }

    public void deleteWithOtherContact() {
        Account testAccount = (Account)testRecordSource.getRecord(Account.SObjectType).withInsert();
        List<Contact> testContacts = testRecordSource.getRecord(Contact.SObjectType)
                .put(Contact.FirstName, componentToTest)
                .withInsert(2);
        testAccount = [SELECT Newest_Contact__c FROM Account WHERE Id = :testAccount.Id];
        Contact toDelete = new Contact(Id = testAccount.Newest_Contact__c);

        Test.startTest();
        delete toDelete;
        Test.stopTest();

        testAccount = [SELECT Newest_Contact__c FROM Account WHERE Id = :testAccount.Id];

        Contact remaining = testContacts[0].Id == toDelete.Id ? testContacts[1] : testContacts[0];
        System.assertEquals(remaining.Id, testAccount.Newest_Contact__c);
    }

    private void measureBefore() {
        timeBefore = Datetime.now().getTime();
        cpuTimeBefore = Limits.getCpuTime();
    }

    private void debugMeasures() {
        System.debug('SOQL queries: ' + Limits.getQueries());
        System.debug('DML statements: ' + Limits.getDmlStatements());
        System.debug('CPU time: ' + (Limits.getCpuTime() - cpuTimeBefore)/1000.0);
        System.debug('Elapsed time: ' + (Datetime.now().getTime() - timeBefore)/1000.0);
    }
}