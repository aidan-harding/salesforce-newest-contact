/**
 * @author aidan@nebulaconsulting.co.uk
 * @date 09/09/2020
 */

@IsTest
private class NewestContactFlowTest {

    static NewestContactTest newestContactTest = new NewestContactTest('Flow');

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
}