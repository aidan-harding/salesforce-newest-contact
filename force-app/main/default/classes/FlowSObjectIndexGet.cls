/**
 * @author aidan@nebulaconsulting.co.uk
 * @date 18/09/2020
 * @description Given a handle obtained from FlowSobjectIndexCreate, and an Id to look up, returns an SObject from the map
 */

public class FlowSObjectIndexGet {

    @InvocableMethod
    public static List<SObject> get(List<FlowSObjectIndexGet.Request> requests) {
        List<SObject> results = new List<SObject>();
        for(FlowSObjectIndexGet.Request thisRequest : requests) {
            results.add(FlowSObjectIndex.indexes[thisRequest.indexHandle].get(thisRequest.key));
        }
        return results;
    }

    public class Request {
        @InvocableVariable
        public Integer indexHandle;
        @InvocableVariable
        public String key;
    }
}