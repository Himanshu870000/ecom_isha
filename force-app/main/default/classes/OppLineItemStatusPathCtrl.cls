public with sharing class OppLineItemStatusPathCtrl {
    @AuraEnabled(cacheable=true)
    public static List<String> getOpportunityLineItemStatusPicklistValues(String recordId) {
        List<String> picklistValues = new List<String>();

        OpportunityLineItem record = [SELECT Id, Status__c FROM OpportunityLineItem WHERE Id = :recordId LIMIT 1];
        String currentValue = record.Status__c;

        // Get the picklist values and mark the current value as selected
        Schema.DescribeFieldResult fieldResult = OpportunityLineItem.Status__c.getDescribe();
        List<Schema.PicklistEntry> picklistEntries = fieldResult.getPicklistValues();

        for (Schema.PicklistEntry entry : picklistEntries) {
            String value = entry.getLabel();
            if (value == currentValue) {
                value += '.';
            }
            picklistValues.add(value);
        }

        return picklistValues;
    }


    @AuraEnabled
    public static Boolean updatePicklistValue(String recordId, String selectedValue) {
        List<OpportunityLineItem> recordsToUpdate = [SELECT Id, Status__c FROM OpportunityLineItem WHERE Id = :recordId];

        if (!recordsToUpdate.isEmpty()) {
            OpportunityLineItem recordToUpdate = recordsToUpdate[0];
            recordToUpdate.Status__c = selectedValue;

            try {
                update recordToUpdate;
                return true;
            } catch (Exception e) {
                return false;
            }
        }

        return false;
    }
}