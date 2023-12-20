public class schoolPageCmpHelper {
    @AuraEnabled
    public static school__c getRecordData(String recordId) {
        // Retrieve the record based on the provided recordId
        return [SELECT Id,School_Type__c,ImageURL__c FROM school__c WHERE Id = :recordId];
    }
}