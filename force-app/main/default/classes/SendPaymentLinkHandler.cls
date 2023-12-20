global without sharing class SendPaymentLinkHandler {
    @AuraEnabled 
    global static lead getLeadData(String leadId){
        system.debug('leadId-->'+leadId);
        Lead leadRecToReturn = new Lead();
        leadRecToReturn = [Select id,Email,Phone,FirstName,LastName,Course_Fees__c From Lead Where Id=: leadId];
        system.debug('leadRecToReturn-->'+leadRecToReturn);
        return leadRecToReturn;
    }
    @AuraEnabled 
    global static Visa_Inquiry__c getVisaData(String visaId){
        system.debug('visaId-->'+visaId);
        Visa_Inquiry__c visaRecord = new Visa_Inquiry__c();
        visaRecord = [Select Id, Name,Lead__C,Lead__r.Name, Lead__r.Consultation_Fees__c,Lead__r.Email, Lead__r.Phone From Visa_Inquiry__c Where Id=: visaId];
        system.debug('visaRecord-->'+visaRecord);
        return visaRecord;
    }
    @AuraEnabled 
    global Static void sendPaymentLinkFromLead(id leadId){
        system.debug('leadId :: ' + leadId);
        RazorpayPaymentHandler.sendPaymentLink(leadId);
    }
    @AuraEnabled 
    global Static void createInvoiceRec(id recordId){
        system.debug('recordId :: ' + recordId);
        String objectAPIName = String.valueOf(recordId.getsobjecttype());
        if(objectAPIName=='Lead'){
           Lead leadRec = new Lead();
            leadRec.id = recordId;
            leadRec.Status = 'Under Payment';
            update leadRec;
        }
        if(objectAPIName=='Opportunity'){
            Opportunity oppRec = new Opportunity();
            oppRec.id = recordId;
            oppRec.StageName = 'Under Payment';
            update oppRec;
        }
        RazorpayPaymentHandler.createInvoiceRec(recordId);
    }
    @AuraEnabled 
    global static Opportunity getOpportunityData(String oppId){
        Opportunity oppRecToReturn = new Opportunity();
        system.debug('oppId-->'+oppId);
        oppRecToReturn = [Select id,Amount,Account.Email__c,Account.Phone From Opportunity Where Id=: oppId];
        system.debug('oppRecToReturn-->'+oppRecToReturn);
        return oppRecToReturn;
    }
    @AuraEnabled 
    global static School__c getSchoolData(String schoolId){
        School__c schoolRecToReturn = new School__c();
        system.debug('schoolId-->'+schoolId);
        schoolRecToReturn = [Select id,Promotional_Amount__c,Email__c,Phone__c From School__c Where Id=: schoolId];
        system.debug('schoolRecToReturn-->'+schoolRecToReturn);
        return schoolRecToReturn;
    }
    @AuraEnabled 
    global Static void sendPaymentLinkFromOpportunity(id oppId){
        system.debug('oppId :: ' + oppId);
        RazorpayPaymentHandler.sendPaymentLink(oppId);
    }
    @AuraEnabled 
    global Static void sendPaymentLinkFromVisaEnquiry(id visaId){
        system.debug('visaId :: ' + visaId);
        RazorpayPaymentHandler.sendPaymentLink(visaId);
    }
    @AuraEnabled 
    Public Static void createInvoiceRecForOppo(id oppId){
        system.debug('oppId :: ' + oppId);
        RazorpayPaymentHandler.createInvoiceRec(oppId);
    }
}