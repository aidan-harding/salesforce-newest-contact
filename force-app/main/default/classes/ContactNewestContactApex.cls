/**
 * @author aidan@nebulaconsulting.co.uk
 * @date 08/09/2020
 */

global without sharing class ContactNewestContactApex implements nebc.AfterInsert, nebc.AfterUpdate, nebc.AfterDelete {

    global void handleAfterInsert(List<Contact> newList) {
        Map<Id, Account> toUpdate = new Map<Id, Account>();

        for(Contact thisContact : newList) {
            if(thisContact.AccountId != null && thisContact.FirstName == 'Apex') {
                Account thisAccount = new Account(Id = thisContact.AccountId, Newest_Contact__c = thisContact.Id);
                toUpdate.put(thisAccount.Id, thisAccount);
            }
        }

        update toUpdate.values();
    }

    global void handleAfterUpdate(List<Contact> oldList, List<Contact> newList) {
        Set<Id> accountIdsToUpdate = new Set<Id>();

        for (Integer i = 0; i < oldList.size(); i++) {
            Id oldContactAccountId = oldList[i].AccountId;
            Contact newContact = newList[i];
            if (oldContactAccountId != newContact.AccountId && newContact.FirstName == 'Apex') {
                accountIdsToUpdate.add(oldContactAccountId);
                accountIdsToUpdate.add(newContact.AccountId);
            }
        }

        updateNewestContact(accountIdsToUpdate);
    }

    global void handleAfterDelete(List<Contact> oldList) {
        Set<Id> accountIdsToUpdate = new Set<Id>();

        for (Integer i = 0; i < oldList.size(); i++) {
            Contact oldContact = oldList[i];
            if(oldContact.FirstName == 'Apex') {
                accountIdsToUpdate.add(oldContact.AccountId);
            }
        }

        updateNewestContact(accountIdsToUpdate);
    }

    private void updateNewestContact(Set<Id> accountIdsToUpdate) {
        accountIdsToUpdate.remove(null);

        if(!accountIdsToUpdate.isEmpty()) {
            List<Account> accountsToUpdate = [
                    SELECT Id, (SELECT Id, CreatedDate FROM Contacts ORDER BY CreatedDate DESC LIMIT 1)
                    FROM Account
                    WHERE Id IN :accountIdsToUpdate
            ];

            for (Account thisAccount : accountsToUpdate) {
                thisAccount.Newest_Contact__c = thisAccount.Contacts.isEmpty() ? null : thisAccount.Contacts[0].Id;
            }

            update accountsToUpdate;
        }
    }
}