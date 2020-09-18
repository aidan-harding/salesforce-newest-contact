/**
 * @author aidan@nebulaconsulting.co.uk
 * @date 18/09/2020
 * @description Creates an SObjectIndex from the given key field and data, then returns a handle to that index
 */

public class FlowSObjectIndexCreate {

    @InvocableMethod
    public static List<Integer> create(List<FlowSObjectIndexCreate.Request> requests) {
        Integer handle = FlowSObjectIndex.indexes.size();
        nebc.SObjectIndex thisSObjectIndex = new nebc.SObjectIndex(requests[0].indexField);
        FlowSObjectIndex.indexes.add(thisSObjectIndex);

        List<Integer> results = new List<Integer>();
        for(FlowSObjectIndexCreate.Request thisRequest : requests) {
            results.add(handle);
            thisSObjectIndex.putAll(thisRequest.records);
        }
        return results;
    }

    public class Request {
        @InvocableVariable
        public String indexField;
        @InvocableVariable
        public List<SObject> records;
    }
}