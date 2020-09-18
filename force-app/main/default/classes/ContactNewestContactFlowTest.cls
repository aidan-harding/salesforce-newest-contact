/**
 * @author aidan@nebulaconsulting.co.uk
 * @date 09/09/2020
 */

@IsTest
private class ContactNewestContactFlowTest {

    static ContactNewestContactTest newestContactTest = new ContactNewestContactTest('Flow');

    @IsTest
    static void singleContact() {
        newestContactTest.singleContact();
    }

    @IsTest
    static void twoContactsSameAccount() {
        newestContactTest.twoContactsSameAccount();
    }

    @IsTest
    static void twoContactsDifferentAccounts() {
        newestContactTest.twoContactsDifferentAccounts();
    }

    @IsTest
    static void noAccount() {
        newestContactTest.noAccount();
    }

    @IsTest
    static void transfer() {
        newestContactTest.transfer();
    }
}