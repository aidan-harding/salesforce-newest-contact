/**
 * @author aidan@nebulaconsulting.co.uk
 * @date 08/09/2020
 */

@IsTest
private class ContactNewestContactLazyTest {

    static ContactNewestContactTest newestContactTest = new ContactNewestContactTest('Lazy');

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

    @IsTest
    static void transferToNull() {
        newestContactTest.transferToNull();
    }

    @IsTest
    static void bulkTransfer() {
        newestContactTest.bulkTransfer(200);
    }

    @IsTest
    static void deleteSingle() {
        newestContactTest.deleteSingle();
    }

    @IsTest
    static void deleteWithOtherContact() {
        newestContactTest.deleteWithOtherContact();
    }
}