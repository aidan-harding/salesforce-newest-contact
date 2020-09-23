/**
 * @author aidan@nebulaconsulting.co.uk
 * @date 23/09/2020
 */

@IsTest
private class TestContactNewestContactSingleContact {

    @IsTest
    static void testBehavior() {
        new Flow.Interview.Test_Contact_Newest_Contact_Single_Contact(new Map<String, Object>()).start();
    }
}