/**
 * @author aidan@nebulaconsulting.co.uk
 * @date 22/09/2020
 */

@IsTest
private class PerformanceTest {

    static ContactNewestContactTest newestContactTest = new ContactNewestContactTest('Flow');

    @IsTest
    static void singleContact() {
        newestContactTest.transfer();
    }

    @IsTest
    static void transfer50() {
        newestContactTest.bulkTransfer(50);
    }
    @IsTest
    static void transfer100() {
        newestContactTest.bulkTransfer(100);
    }
    @IsTest
    static void transfer150() {
        newestContactTest.bulkTransfer(150);
    }
    @IsTest
    static void transfer200() {
        newestContactTest.bulkTransfer(200);
    }
    @IsTest
    static void transfer250() {
        newestContactTest.bulkTransfer(250);
    }
    @IsTest
    static void transfer300() {
        newestContactTest.bulkTransfer(300);
    }
    @IsTest
    static void transfer350() {
        newestContactTest.bulkTransfer(350);
    }
    @IsTest
    static void transfer400() {
        newestContactTest.bulkTransfer(400);
    }
}