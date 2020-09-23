/**
 * @author aidan@nebulaconsulting.co.uk
 * @date 23/09/2020
 */

public with sharing class FlowAssertEquals {
    @InvocableMethod
    public static  void makeAssertions(List<Assertion> assertions) {
        for(Assertion thisAssertion : assertions) {
            System.assertEquals(thisAssertion.expected, thisAssertion.actual, thisAssertion.message);
        }
    }

    public class Assertion {
        @InvocableVariable
        public String expected;
        @InvocableVariable
        public String actual;
        @InvocableVariable
        public String message;
    }
}