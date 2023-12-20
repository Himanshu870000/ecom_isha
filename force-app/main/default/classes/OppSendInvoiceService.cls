@RestResource(urlMapping='/send_payment')
global without sharing class OppSendInvoiceService {
    @HttpPost
    global static void sendPaymentLink(){
        RestRequest req = RestContext.request;
        Blob body = req.requestBody;
        String requestString = body.toString();
        
        Map<String,Object> oppIdMap = (Map<String,Object>)JSON.deserializeUntyped(requestString);
        
        Opportunity opp = getOpportunity(oppIdMap.get('Id').toString());
        Invoices__c inv = createInvoice(opp);
        
        Map<String,String> reqPaymentMap = new Map<String,String>();
        reqPaymentMap.put('id', inv.Id);
        reqPaymentMap.put('email', opp.Account.Email__c);
        reqPaymentMap.put('name', opp.Name);
        reqPaymentMap.put('phone', opp.Account.Phone);
        reqPaymentMap.put('amount', String.valueOf(opp.Discounted_Amount__c*100));
        
        RazorpayPaymentHandler.getPaymentLinkForInvoice(reqPaymentMap);
        inv.Status__c = 'Invoice Sent';
        update inv;
        
        String responseBody = JSON.serialize(new APIResponseWrapper('Success', 'Payment Request sent successfully'));
        RestContext.response.statusCode = 200;
        RestContext.response.responseBody = Blob.valueOf(responseBody);
       	
    }		
    
    global Static Opportunity getOpportunity(String oppId){
        return [Select Id,Name,AccountId,Account.Email__c,Discounted_Amount__c,Account.Phone From Opportunity Where Id=:oppId];
    }
    
    global static Invoices__c createInvoice(Opportunity opp){
        Invoices__c inv = new Invoices__c();
        inv.Opportunity__c = opp.Id;
        inv.Account__c = opp.AccountId;
        inv.Status__c = 'Invoice Sent';
        inv.Amount__c = opp.Discounted_Amount__c;
        insert inv;
        return inv;
    }
    
    global class APIResponseWrapper{
        public String message;
        public String status;

        global APIResponseWrapper(String status, String message) {
            this.status = status;
            this.message = message;
        }
    }
}