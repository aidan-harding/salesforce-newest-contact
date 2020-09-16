/**
 * @author aidan@nebulaconsulting.co.uk
 * @date 08/09/2020
 */

global without sharing class NewestContactLazy implements nebc.AfterInsert, nebc.AfterUpdate {

    global void handleAfterInsert(List<Contact> newList) {
        new nebc.LazySObjectIterator(newList)
                .filterT(new nebc.IsEqual(Contact.FirstName, 'Lazy'))
                .filterT(new nebc.IsNotNull(Contact.AccountId))
                .filterT(new nebc.IsUniqueOn(Contact.AccountId))
                .mapValuesT(
                new nebc.SObjectFromPrototype(new Account())
                        .putField(Account.Id, Contact.AccountId)
                        .putField(Account.Newest_Contact__c, Contact.Id))
                .doUpdate();
    }

    global void handleAfterUpdate(List<Contact> oldList, List<Contact> newList) {
        Set<Id> accountIdsToUpdate = new nebc.LazyTriggerContextPairIterator(oldList, newList)
                .filterT(new nebc.IsFieldChangedInTrigger(Contact.AccountId))
                .bothRecords()
                .filterT(new nebc.IsEqual(Contact.FirstName, 'Lazy'))
                .filterT(new nebc.IsNotNull(Contact.AccountId))
                .get(Contact.AccountId, new Set<Id>());

        if(!accountIdsToUpdate.isEmpty()) {
            List<Account> accountsToUpdate = [
                    SELECT Id, (SELECT Id, CreatedDate FROM Contacts ORDER BY CreatedDate DESC LIMIT 1)
                    FROM Account
                    WHERE Id IN :accountIdsToUpdate
            ];

            new nebc.LazySObjectIterator(accountsToUpdate)
                    .put(
                    Account.Newest_Contact__c,
                    new nebc.Composition(new nebc.SObjectsFromSObject('Contacts'))
                            .compose(new nebc.FirstOrDefault(new Contact(Id = null)))
                            .compose(new nebc.FieldFromSObject(Contact.Id)))
                    .doUpdate();
        }
    }
}