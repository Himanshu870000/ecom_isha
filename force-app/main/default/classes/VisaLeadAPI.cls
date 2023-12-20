@RestResource(urlMapping='/lead_visa')
global with sharing class VisaLeadAPI {
    
    @HttpPost
    global static void doPost() {
        
        RestRequest req = RestContext.request;
        Blob body = req.requestBody;
        String requestString = body.toString();
        System.debug('--- rquestString'+ requestString);
        VisaLeadAPIWrapper lWrapper = (VisaLeadAPIWrapper)JSON.deserialize(requestString, VisaLeadAPIWrapper.class);
        if(lWrapper != null) {         
            system.debug('calling with wrapper --- '+lWrapper);
            if(insertLeadVisa(lWrapper))
                RestContext.response.responseBody = Blob.valueOf(JSON.serialize(new SAPIntegrationWrappers.APIResponseWrapper('Success', 'Visa Enquiry Created successfully')));
            else
                RestContext.response.responseBody = Blob.valueOf(JSON.serialize(new SAPIntegrationWrappers.APIResponseWrapper('Error', 'Something went wrong')));
        }
    }
    
    private static boolean insertLeadVisa(VisaLeadAPIWrapper wrapData){
        try{
            if(wrapData.Mobile != null ){
                List<Lead> leadList = [SELECT Id, MobilePhone, Visa_Type__c, Sales_Team_Member__c FROM Lead WHERE MobilePhone =: wrapData.Mobile];
                system.debug('leadList :: ' + leadList);
                leadList[0].Visa_Type__c = wrapData.Visa_Type;
                leadList[0].Visa_Purpose__c = wrapData.Visa_Purpose;                
                if(leadList != null){
                                        
                    Visa_Inquiry__c newVisaEnq = new Visa_Inquiry__c();
                    newVisaEnq.Lead__c = leadList[0].Id;
                    newVisaEnq.Name = !String.isBlank(wrapData.Visa_Type) ? wrapData.Visa_Type : '';
                    newVisaEnq.Visa_Type__c = !String.isBlank(wrapData.Visa_Type) ? wrapData.Visa_Type : '';
                    newVisaEnq.Visa_Purpose__c = !String.isBlank(wrapData.Visa_Purpose) ? wrapData.Visa_Purpose : '' ;
                    newVisaEnq.Stage__c = 'New';
                    newVisaEnq.Sales_Team_Member__c=leadList[0].Sales_Team_Member__c;
                    insert newVisaEnq;
                    update leadList;
                    return true;
                }
            }
            return false;
        }
        catch(Exception e){
            System.debug(' --- Error Msg '+ e.getMessage());
            System.debug(' --- Error LineNo '+ e.getLineNumber());
            return false;
        }
    } 
}