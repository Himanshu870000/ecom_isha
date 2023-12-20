public class StudentProfileCardController {

    @AuraEnabled(cacheable=true)
    public static Lead GetLeadandChildDetails(String LeadId) {
        AccountEngagementHistoryWrapper AccEngageHistWrap = New AccountEngagementHistoryWrapper();
        return [
            SELECT Affiliation__c,Board__c,Branch__c,Budget__c,City,City__c,Class__c,Country,Country__c,Exam__c,LastName,Name,Preferred_Area__c,Preferred_City__c,Preferred_Country__c,Preferred_State__c,State__c 
            FROM Lead
            WHERE Id=:  LeadId
        ];

    }

    public class AccountEngagementHistoryWrapper{
        @AuraEnabled
        public Lead accRecord{get;set;}
        @AuraEnabled
        public List<Contact> EngagementHistory{get;set;}
    }


}