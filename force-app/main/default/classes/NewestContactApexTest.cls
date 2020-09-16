/**
 * @author aidan@nebulaconsulting.co.uk
 * @date 08/09/2020
 */

@IsTest
private class NewestContactApexTest {

    static NewestContactTest newestContactTest = new NewestContactTest('Apex');

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