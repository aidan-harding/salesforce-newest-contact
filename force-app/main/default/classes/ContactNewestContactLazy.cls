/**
 * @author aidan@nebulaconsulting.co.uk
 * @date 08/09/2020
 */

global without sharing class ContactNewestContactLazy implements nebc.AfterInsert, nebc.AfterUpdate, nebc.AfterDelete {

    global void handleAfterInsert(List<Contact> newList) {
        new nebc.LazySObjectIterator(newList)
                .filterOnField(Contact.FirstName, 'Lazy')
                .filterOnField(Contact.AccountId, new nebc.IsNotNull())
                .filterOnField(Contact.AccountId, new nebc.IsUnique())
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
                .filterOnField(Contact.FirstName, 'Lazy')
                .filterOnField(Contact.AccountId, new nebc.IsNotNull())
                .get(Contact.AccountId, new Set<Id>());

        updateNewestContact(accountIdsToUpdate);
    }

    global void handleAfterDelete(List<Contact> oldList) {
        Set<Id> accountIdsToUpdate = new nebc.LazySObjectIterator(oldList)
                .filterOnField(Contact.FirstName, 'Lazy')
                .filterOnField(Contact.AccountId, new nebc.IsNotNull())
                .get(Contact.AccountId, new Set<Id>());

        updateNewestContact(accountIdsToUpdate);
    }

    private void updateNewestContact(Set<Id> accountIdsToUpdate) {
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