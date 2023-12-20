public without sharing class RazorpayPaymentHandler {
    public RazorpayPaymentHandler() {}
    
    @AuraEnabled(cacheable=true)
    public static List<Opportunity> displayOppRecord(){
        return [Select Id,Name from Opportunity];
    }
    
    @AuraEnabled(cacheable = true)
    @future(callout=true)
    public static void sendPaymentLink(String recordId){
        
        if(!String.isBlank(recordId)){
            Id recId = (Id) recordId;
            String objectAPIName = String.valueOf(recId.getsobjecttype());
            
            System.debug('RecordId---'+recordId+' ---OBJNAME---'+objectAPIName);
            Opportunity opp;
            Lead ld;
            Visa_Inquiry__c visa;
            String email;
            String contact;
            String name;
            Decimal amount;
            
            
            if(objectAPIName=='Opportunity'){
                opp = [SELECT Id, Name, Amount ,AccountId,Account.Phone,Account.Email__c From Opportunity Where Id =: recordId];
                
                if(opp.Amount!=null && opp.Account.Email__c!=null && opp.Account.Phone!=null){
                    email = opp.Account.Email__c;
                    contact = opp.Account.Phone;
                    name = opp.Name;
                    amount = opp.Amount*100;
                }
            }else if(objectAPIName=='Lead'){
                system.debug('objectAPIName-->>'+objectAPIName);
                ld = [Select Id, Name,Lead_Stage__c, Consultation_Fees__c,Course_Fees__c,Email, Phone From Lead Where Id=: recordId];
                system.debug('ld-->'+ld);
                if(ld.Course_Fees__c!=null && ld.Email!=null && ld.Phone!=null){
                    
                    system.debug('Sending Request-->'+ld);
                    email = ld.Email;
                    contact = ld.Phone;
                    name = ld.Name;
                    amount = ld.Course_Fees__c*100;
                }
            }else if(objectAPIName=='Visa_Inquiry__c'){
                visa = [Select Id, Name,Lead__C,Lead__r.Name, Lead__r.Consultation_Fees__c,Lead__r.Email, Lead__r.Phone From Visa_Inquiry__c Where Id=: recordId];
                system.debug('Sending Request-->'+ld);
                email = visa.Lead__r.Email;
                contact = visa.Lead__r.Phone;
                name = visa.Lead__r.Name;
                amount = visa.Lead__r.Consultation_Fees__c*100;
                
            }else if(objectAPIName == 'Quote'){
                Quote q = [Select Id,Name,TotalPrice,Account.Email__c,Phone From Quote Where Id=:recordId];
                email = q.Account.Email__c;
                contact = q.Account.Phone;
                name = q.Name;
                amount = q.TotalPrice * 100;
            }else if(objectAPIName == 'Invoices__c'){
                Invoices__c invoiceRec =[SELECT Id,Amount__c,Due_Amount__c,Initiated_Amount__c,Payment_Option__c,Payment_Type__c,Realized_Amount__c,Opportunity__r.Name,Opportunity__r.Account.Email__c,Opportunity__r.Account.Phone From Invoices__c where Id=:recordId order by CreatedDate Desc limit 1 ];
                email = invoiceRec.Opportunity__r.Account.Email__c;
                contact = invoiceRec.Opportunity__r.Account.Phone;
                name = invoiceRec.Opportunity__r.Name;
                amount = invoiceRec.Initiated_Amount__c * 100;
            }else if(objectAPIName == 'School__c'){
                School__c schoolRec =[Select id,Name,Promotional_Amount__c,Email__c,Phone__c From School__c Where Id=: recordId];
                 if(schoolRec.Promotional_Amount__c != null && schoolRec.Email__c != null && schoolRec.Phone__c != null){
                    email = schoolRec.Email__c;
                    contact = schoolRec.Phone__c;
                    name = schoolRec.Name;
                    amount = schoolRec.Promotional_Amount__c*100;
                }
            }
            
            
            if(amount!=null && email!=null && contact!=null){
                try {
                    RazorpayRequestJSON razorpayRequestJSON = new RazorpayRequestJSON();
                    
                    razorpayRequestJSON.amount = amount;
                    razorpayRequestJSON.first_min_partial_amount = amount;
                    razorpayRequestJSON.setCustomer(name,contact,email);
                    razorpayRequestJSON.setNotes(recordId,objectAPIName);
                    
                    String body = JSON.serialize(razorpayRequestJSON);
                    body = body.replace('currencyType','currency');
                    
                    System.debug('Body---'+body);
                    
                    HTTP http = new HTTP();
                    HttpRequest req = new HttpRequest();
                    
                    req.setHeader('Content-Type', 'application/json');
                    req.setEndpoint('callout:RazorPay');
                    req.setMethod('POST');
                    req.setBody(body);
                    
                    HTTPResponse res = http.send(req);
                    Map<String,Object> jsonBody = (Map<String,Object>) Json.deserializeUntyped(res.getBody());
                    
                    System.debug('RESPPPP'+jsonBody);
                    //                    return jsonBody;   
                    if(objectAPIName=='Lead' && ld.Lead_Stage__c != 'Dormant'){
                        ld.Lead_Stage__c = 'Under Payment';
                        update ld;
                    }    
                }
                catch (Exception e) {
                    System.debug('e.getMessage() -- ' + e.getMessage() + 'Line No -- ' + e.getLineNumber());
                }
            }
        }else{
        }
    }
    
    @future(callout=true)
    public static void getPaymentLinkForInvoice(Map<String,String> reqMap){
        String recordId = reqMap.get('id');
        system.debug('recordId--->'+recordId);
		String email = reqMap.get('email');
        String contact = reqMap.get('phone');
        String name = reqMap.get('name');
        Decimal amount = Decimal.valueOf(reqMap.get('amount'));
        
        RazorpayRequestJSON razorpayRequestJSON = new RazorpayRequestJSON();
        razorpayRequestJSON.amount = amount;
        razorpayRequestJSON.first_min_partial_amount = amount;
        razorpayRequestJSON.setCustomer(name,contact,email);
        razorpayRequestJSON.setNotes(recordId,'Invoices__c');
        
        
        String body = JSON.serialize(razorpayRequestJSON);
        body = body.replace('currencyType','currency');
        
        System.debug('Body---'+body);
        
        HTTP http = new HTTP();
        HttpRequest req = new HttpRequest();
        
        req.setHeader('Content-Type', 'application/json');
        req.setEndpoint('callout:RazorPay');
        req.setMethod('POST');
        req.setBody(body);
        
        HTTPResponse res = http.send(req);
        Map<String,Object> jsonBody = (Map<String,Object>) Json.deserializeUntyped(res.getBody());
        //return 'Success';
    }
    
    @AuraEnabled
    public static void createInvoiceRec(String recordId){
        try {
            if(!String.isBlank(recordId)){
                Id recId = (Id) recordId;
                String objectAPIName = String.valueOf(recId.getsobjecttype());
                
                System.debug('RecordId---'+recordId+' ---OBJNAME---'+objectAPIName);
                Opportunity opp;
                Lead ld;
                Visa_Inquiry__c visa = new Visa_Inquiry__c();
                
                system.debug('objectAPIName-->'+objectAPIName);
                if(objectAPIName=='Opportunity'){
                    
                    opp = [SELECT Id, Name, Amount ,AccountId,Account.Phone,Account.Email__c From Opportunity Where Id =: recordId];
                    system.debug('opp-->'+opp);
                    Invoice__c invoiceRec = new Invoice__c();
                    invoiceRec.Opportunity__c = opp.Id;
                    invoiceRec.Account__c = opp.AccountId;          
                    invoiceRec.Due_Date__c = system.today().addDays(2);
                    invoiceRec.Amount__c = opp.Amount;
                    invoiceRec.Status__c = 'Initiated';     
                    invoiceRec.Initiated_Date__c = system.today();
                    insert invoiceRec;
                    system.debug('invoiceRec--->'+invoiceRec);
                    
                }else if(objectAPIName=='Lead'){
                    ld = [Select Id, Name, Consultation_Fees__c,Course_Fees__c,Email, Phone From Lead Where Id=: recordId];
                    Invoice__c invoiceRec = new Invoice__c();
                    invoiceRec.Lead__c = ld.Id;
                    invoiceRec.Amount__c = ld.Course_Fees__c;
                    invoiceRec.Status__c = 'Initiated';
                    invoiceRec.Due_Date__c = system.today().addDays(2);
                    invoiceRec.Initiated_Date__c = system.today();
                    insert invoiceRec;
                }
                else if(objectAPIName=='Visa_Inquiry__c'){
                    visa = [Select Id, Name,Lead__C, Lead__r.Consultation_Fees__c,Lead__r.Email, Lead__r.Phone From Visa_Inquiry__c Where Id=: recordId];
                    
                    Invoice__c invoiceRec = new Invoice__c();
                    invoiceRec.Lead__c = visa.Lead__C;
                    invoiceRec.Visa_Inquiry__c = visa.Id;
                    invoiceRec.Amount__c =  visa.Lead__r.Consultation_Fees__c;
                    invoiceRec.Status__c = 'Initiated';
                    invoiceRec.Due_Date__c = system.today().addDays(2);
                    invoiceRec.Initiated_Date__c = system.today();
                    insert invoiceRec;
                }else if(objectAPIName == 'Quote'){
                    Quote q = [Select Id,Name,TotalPrice,Account.Email__c,Phone From Quote Where Id=:recordId];
                    
                    Invoices__c invoiceRec = new Invoices__c();
                    invoiceRec.Quote__c = q.Id;
                    invoiceRec.Amount__c =  q.TotalPrice;
                    invoiceRec.Status__c = 'Invoice Sent';
                    insert invoiceRec;
                }else if(objectAPIName == 'School__C'){
                    School__C schoolRec = [Select id,Name,Promotional_Amount__c,Email__c,Phone__c From School__c Where Id=: recordId];
                    
                    Invoices__c invoiceRec = new Invoices__c();
                    invoiceRec.School__c = schoolRec.Id;
                    invoiceRec.Amount__c =  schoolRec.Promotional_Amount__c;
                    invoiceRec.Status__c = 'Initiated';
                    invoiceRec.Initiated_Amount__c = schoolRec.Promotional_Amount__c;
                    invoiceRec.Invoice_Date__c = system.today(); 
                    invoiceRec.Due_Date__c = system.today().addDays(2);
                    insert invoiceRec;
                }
            }    
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}