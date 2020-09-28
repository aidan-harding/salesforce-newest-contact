# Salesforce Newest Contact

This is a small programming challenge to demonstrate techniques/tools in Salesforce.

## The Challenge

The only objects involved are standard Accounts and Contacts. Account has a new field on it, called Newest_Contact__c. 
This is a lookup field to Contact, and the challenge is to write code to automatically populate that field with the 
most recently added Contact on any particular Account. If there is more than one Contact inserted for the same Account 
in the same transaction, we don’t care which one becomes the Newest_Contact__c.

## Background

See [Flow For Developers](https://nebulaconsulting.co.uk/insights/flow-for-developers/) for details on the Flow and Apex
solutions below.

## Nebula Core

Where code here is referencing items from the nebc namespace, that is using our open-source library [Nebula Core](https://bitbucket.org/nebulaconsulting/nebula-core/src/master/).
Most of the usage (e.g. the trigger framework) is quite light, so you can probably understand the code here without 
having to delve deep into the main library. 

The LazyIterator implementation is a more complex concept from Nebula Core. For a (slighly out-dated) background on it, 
see [Using Lazy Evaluation to Write Salesforce Apex Code Without For-Loops](https://nebulaconsulting.co.uk/insights/using-lazy-evaluation-to-write-salesforce-apex-code-without-for-loops/).

## The Solutions

Each solution looks at the FirstName of the contact to determine whether it should handle that particular record. 
They expect "Apex", "Flow", or "Lazy" for the Apex, Flow, and LazyIterator implementations respectively.

### Apex

The Apex solution is in a single class, [ContactNewestContactApex](force-app/main/default/classes/ContactNewestContactApex.cls).
Tests are in [ContactNewestContactApexTest](force-app/main/default/classes/ContactNewestContactApexTest.cls)

### Flow

The Flow solution is in a number of Flows. [Contact_Insert_Newest_Contact](force-app/main/default/flows/Contact_Insert_Newest_Contact.flow-meta.xml)
handles the insert scenario. [Contact_Update_Newest_Contact](force-app/main/default/flows/Contact_Update_Newest_Contact.flow-meta.xml) 
handles update. [Contact_Update_Newest_Contact_SObjectIndex](force-app/main/default/flows/Contact_Update_Newest_Contact_SObjectIndex.flow-meta.xml)
is an improved version of the update-case, using an Apex Action to implement a Map.

There are Apex Actions in support of the Flows:

 - [FlowAssert](force-app/main/default/classes/FlowAssert.cls) and  [FlowAssertEquals](force-app/main/default/classes/FlowAssertEquals.cls) call Apex asserts for writing tests in Flow
 - [FlowTestRecordSource](force-app/main/default/classes/FlowTestRecordSource.cls), [FlowGetTestRecord](force-app/main/default/classes/FlowGetTestRecords.cls), and [FlowGetTestRecords](force-app/main/default/classes/FlowGetTestRecord.cls) insert and return test data for Flows
 - [FlowOldRecords](force-app/main/default/classes/FlowOldRecords.cls) allows Flow access to the old records in an update
 - [FlowSObjectIndex](force-app/main/default/classes/FlowSObjectIndex.cls), [FlowSObjectIndexCreate](force-app/main/default/classes/FlowSObjectIndexCreate.cls), and [FlowSObjectIndexGet](force-app/main/default/classes/FlowSObjectIndexGet.cls) allow the creation of an SObjectIndex and retrieval of records from it

Apex tests are in [ContactNewestContactFlowTest](force-app/main/default/classes/ContactNewestContactFlowTest.cls)

Flow tests are in [Test_Contact_Newest_Contact_Single_Contact](force-app/main/default/flows/Test_Contact_Newest_Contact_Single_Contact.flow-meta.xml) (run by [TestContactNewestContactSingleContact](force-app/main/default/classes/TestContactNewestContactSingleContact.cls))
and [Test_Contact_Newest_Contact_Two_Contacts](force-app/main/default/flows/Test_Contact_Newest_Contact_Two_Contacts.flow-meta.xml) (run by [TestContactNewestContactTwoContacts](force-app/main/default/classes/TestContactNewestContactTwoContacts.cls)).

### Apex - LazyIterator

The Apex LazyIterator solution is in a single class, [ContactNewestContactLazy](force-app/main/default/classes/ContactNewestContactLazy.cls).
Tests are in [ContactNewestContactLazyTest](force-app/main/default/classes/ContactNewestContactLazyTest.cls)

## License

MIT, see [LICENSE](LICENSE)


