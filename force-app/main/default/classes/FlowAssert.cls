/**
 * @author aidan@nebulaconsulting.co.uk
 * @date 23/09/2020
 */

public with sharing class FlowAssert {

    @InvocableMethod(Label='Assert')
    public static  void makeAssertions(List<Assertion> assertions) {
        for(Assertion thisAssertion : assertions) {
            System.assert(thisAssertion.condition, thisAssertion.message);
        }
    }

    public class Assertion {
        @InvocableVariable
        public Boolean condition;
        @InvocableVariable
        public String message;
    }
}