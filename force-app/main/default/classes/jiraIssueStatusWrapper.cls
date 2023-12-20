public class jiraIssueStatusWrapper{
    @auraEnabled
    public String key { get;set;}
    @auraEnabled
    public string expand {get;set;}        
    @auraEnabled
    public Fields fields {get;set;}
    @auraEnabled
    public string caseSubject {get;set;}
    @auraEnabled
    public string caseDescription {get;set;}
    
    public class Fields{
        @auraEnabled
        public Status status {get;set;}
    }
    public  class Status{
        @auraEnabled
        public string name {get;set;}
        @auraEnabled
        public StatusCategory statusCategory {get;set;}
    }
    public class StatusCategory{
        @auraEnabled
        public string id {get;set;}
        @auraEnabled
        public string key {get;set;}
        @auraEnabled
        public string name {get;set;}
    }
}