global without sharing class TaxInvoiceHelperKlincoPDF {
    
    public Account accDetails {get;set;}
    public Invoices__c getInvRecord {get;set;}
    Public String todayDate {get;set;}
    public  Company_Specifications__c companyDetails {get; set;} 
    public TaxInvoiceHelperKlincoPDF(ApexPages.StandardController controller){
        String recordId = ApexPages.currentPage().getParameters().get('id');
        companyDetails = [Select Name__c,Address__c,CIN__c,Email__c,GSTIN__c,PAN__c,Phone__c,Klincoaddress__c From Company_Specifications__c  where Name ='EDUSTEP'];
        
        if(!String.isBlank(recordId)){
            getInvRecord = [SELECT Id,Name,Amount__c,Account__c,Opportunity__c,CreatedDate FROM Invoices__c WHERE Id =: recordId];
        }
        String todayDateTostring = String.valueOf(getInvRecord.CreatedDate);
        String[] str2 = todayDateTostring.split(' ');
        todayDate = str2[0];
        if(!String.isBlank(getInvRecord.Account__c)){
            accDetails = [SELECT Id,Name,BillingStreet,BillingCity, BillingState,Email__c, BillingPostalCode, BillingCountry FROM Account WHERE Id =: getInvRecord.Account__c];
        }
    }
}