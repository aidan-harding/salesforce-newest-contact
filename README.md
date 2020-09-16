# Salesforce Newest Contact

This is a small programming challenge to demonstrate techniques/tools in Salesforce.

## The Challenge

The only objects involved are standard Accounts and Contacts. Account has a new field on it, called Newest_Contact__c. 
This is a lookup field to Contact, and the challenge is to write code to automatically populate that field with the 
most recently added Contact on any particular Account. If there is more than one Contact inserted for the same Account 
in the same transaction, we don’t care which one becomes the Newest_Contact__c.

## License

MIT, see [LICENSE](LICENSE)


