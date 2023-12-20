@RESTResource(urlMapping='/razorpayWebhook/*')
global without sharing class RazorpayWebhookHandler {
    @HttpPost
    global static String webhookListener(){
        
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        
        String body = req.requestBody.toString();
        
        System.debug('REQUEST----'+body);
        Map<String, Object> m = (Map<String, Object>)JSON.deserializeUntyped(body);
        Map<String,Object> m2 =  (Map<String, Object>) m.get('payload');
        Map<String,Object> m3 =  (Map<String, Object>) m2.get('payment');
        Map<String,Object> m4 =  (Map<String, Object>) m3.get('entity');
        Map<String,Object> m5 = new Map<String, Object>();
        System.debug('PAYMENTID-----'+m4.get('id'));
        if(m4.containsKey('captured')){
            m5 =  (Map<String, Object>) m4.get('notes');
            String recId = m5.get('policy_name').toString();
            String objName = m5.get('objectName').toString();
            system.debug('objName-->'+objName);
            system.debug('recId---->'+recId);
            if(objName=='Opportunity'){
                String AccountId = [Select Id,AccountId From Opportunity where id =:recId].Accountid;
                Opportunity opp = new Opportunity(Id=recId, Payment_Captured__c= m4.get('captured')==true?'Success':'Failed');
                opp.StageName = 'Payment Received';
                update opp;
                Account accRec = new Account();
                accRec.Id = AccountId;
                accRec.Status__c = 'Active';
                update accRec;
                Invoice__c invoiceRec = [Select Id,Status__c From Invoice__c Where Opportunity__c =: recId ORDER BY CreatedDate DESC limit 1];
                if(m4.get('captured')==true){
                    invoiceRec.Status__c = 'Realized';
                }
                if(m4.get('captured')==false){
                    invoiceRec.Status__c = 'Not realized';
                }
                update invoiceRec;
            }else if(objName=='Lead'){
                LeadTriggerHelper.convertLeadAfterPayment(recId, m4);
            }else if(objName=='Invoices__c'){
                Invoices__c invoiceRec = [SELECT Id,Amount__c,Opportunity__c,Opportunity__r.Initiated_Amount__c,Opportunity__r.Amount,Opportunity__r.Realized_Amount__c,Due_Amount__c,Initiated_Amount__c,Payment_Option__c,Payment_Type__c,Realized_Amount__c From Invoices__c where Id=: recId order by CreatedDate Desc limit 1];
                invoiceRec.Status__c = 'Realized';
                update invoiceRec;
                Opportunity oppToUpdate = new Opportunity();
                oppToUpdate.Id = invoiceRec.Opportunity__c;
                //if(invoiceRec.Opportunity__r.Initiated_Amount__c == invoiceRec.Opportunity__r.Amount){
                    oppToUpdate.StageName = 'Payment Received';
                //}else{
                    oppToUpdate.StageName = 'Partially Paid';
                //}
                if(invoiceRec.Opportunity__r.Realized_Amount__c == null)
                    invoiceRec.Opportunity__r.Realized_Amount__c =0;
                if(invoiceRec.Opportunity__r.Initiated_Amount__c == null)
                    invoiceRec.Opportunity__r.Initiated_Amount__c =0;
                oppToUpdate.Realized_Amount__c = invoiceRec.Opportunity__r.Realized_Amount__c + invoiceRec.Opportunity__r.Initiated_Amount__c;
                update oppToUpdate;
            }else if(objName=='Quote'){
                update new Quote(Id=recId,Payment_Status__c = 'Paid');
                Invoices__c invoiceRec = [Select Id,Status__c From Invoices__c Where Quote__c =: recId ORDER BY CreatedDate DESC limit 1];
                if(m4.get('captured')==true){
                    invoiceRec.Status__c = 'Paid';
                }
                if(m4.get('captured')==false){
                    invoiceRec.Status__c = 'Not realized';
                }
                update invoiceRec;
            }
            else if(objName=='School__c'){
                Invoices__c invoiceRec = [SELECT Id,Amount__c,Opportunity__c,Opportunity__r.Initiated_Amount__c,Opportunity__r.Amount,Opportunity__r.Realized_Amount__c,Due_Amount__c,Initiated_Amount__c,Payment_Option__c,Payment_Type__c,Realized_Amount__c From Invoices__c where school__C=: recId order by CreatedDate Desc limit 1];
                invoiceRec.Status__c = 'Realized';
                update invoiceRec;
                School__c schoolRec = new School__c();
                schoolRec.Id = recId;
                schoolRec.School_Type__c = 'Premium';
                schoolRec.Status__c = 'Active';
                update schoolRec;
            }
        }
        return 'Success';
    }
}