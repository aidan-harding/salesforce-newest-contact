/**
 * @author aidan@nebulaconsulting.co.uk
 * @date 27/08/2020
 * @description Stores all the old records as they pass through Apex, so that a Flow can pick them up later
 */

global without sharing class FlowOldRecords implements nebc.BeforeUpdate {

    private static Map<SObjectType, Map<Id, SObject>> typeToOldMap = new Map<SObjectType, Map<Id, SObject>>();

    public void handleBeforeUpdate(List<SObject> oldList, List<SObject> newList) {
        SObjectType thisType = oldList.getSObjectType();
        if(!typeToOldMap.containsKey(thisType)) {
            typeToOldMap.put(thisType, new Map<Id, SObject>());
        }
        typeToOldMap.get(thisType).putAll(oldList);
    }

    @InvocableMethod
    public static List<SObject> getOldRecord(List<SObject> data) {
        List<SObject> results = new List<SObject>();
        for(SObject thisSobject : data) {
            results.add(typeToOldMap.get(thisSobject.getSObjectType()).get(thisSobject.Id));
        }
        return results;
    }
}