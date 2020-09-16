/**
 * @author aidan@nebulaconsulting.co.uk
 * @date 08/09/2020
 */

@IsTest
private class NewestContactLazyTest {

    static NewestContactTest newestContactTest = new NewestContactTest('Lazy');

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