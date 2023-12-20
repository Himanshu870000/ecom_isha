trigger TriggerOnVendor on Vendor__c (before insert,after insert) {
    
    if(trigger.isInsert && trigger.isafter){
        TriggerOnVendorHelper.documentCaegories(trigger.new);
    }
}