public class BeatPlannerUtilityClass {
    
    @AuraEnabled
    Public static List<Visit__c> getVisitRec(){
        List<Visit__c> visitRecList = [Select Id,KPI_Target__r.Name,Account__c,Account__r.Name,Lead__c,Lead__r.Name,Start_Date_Time__c,Route__c From Visit__c Where KPI_Target__c !=null];
        return visitRecList;
    }
    
    @AuraEnabled
    Public static List<Lead> getLeadRec(){
        List<Lead> LeadRecList = [Select Id,FirstName,LastName,Email,Phone,Lead_Stage__c From Lead];
        return LeadRecList;
    }
    
    @AuraEnabled
    Public static List<Event> getEventRec(){
        List<Event> eventList = [Select Id,WhoId,Type,EndDateTime,StartDateTime,Description From Event];
        return eventList;
    }
    
    @AuraEnabled
    Public static List<Opportunity> getOppRec(){
        List<Opportunity> oppList = [Select Id,Name,AccountId,Account.Name,Total_Amount__c,StageName,CloseDate From Opportunity];
        return oppList;
    }
    
    @AuraEnabled
    Public static List<Opportunity> getOppNegoRec(){
        List<Opportunity> oppList = [Select Id,Name,AccountId,Account.Name,Total_Amount__c,StageName,CloseDate From Opportunity Where StageName = 'Negotiation'];
        return oppList;
    }
    
    @AuraEnabled
    Public static List<Quote> getquoteRec(){
        List<Quote> quoteList = [Select Id,AccountId,Account.Name,ExpirationDate,Status,TotalPrice From Quote ];
        return quoteList;
    }
    
    @AuraEnabled
    Public static List<Invoices__c> getinvoRec(){
        List<Invoices__c> invoList = [Select Id,Invoice_Date__c From Invoices__c ];
        return invoList;
    }
    
    @AuraEnabled
    Public static List<Case> getCaseRec(){
        List<Case> caseList = [Select Id,AccountId,Account.Name,Status,CreatedDate From Case ];
        return caseList;
    }
}