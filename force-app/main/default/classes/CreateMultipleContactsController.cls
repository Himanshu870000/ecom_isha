public without sharing class CreateMultipleContactsController {
     @AuraEnabled
    public static List<Contact> createContacts(List<Contact> contactList, Id opportunityId) {
        List<OpportunityContactRole> ocrList = new List<OpportunityContactRole>();
        
        for (Contact c : contactList) {
            insert c;
            OpportunityContactRole ocr = new OpportunityContactRole();
            ocr.ContactId = c.Id;
            ocr.OpportunityId = opportunityId;
            ocr.Role = 'Decision Maker';
            ocrList.add(ocr);
        }
        
        insert ocrList;
        
        return contactList;
    }
}