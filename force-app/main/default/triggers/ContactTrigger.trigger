/**
 * @author aidan@nebulaconsulting.co.uk
 * @date 08/09/2020
 */

trigger ContactTrigger on Contact (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    new nebc.MetadataTriggerManager(Contact.SObjectType).handle();
}