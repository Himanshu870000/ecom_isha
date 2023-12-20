public class getOpportunityRecord {
    @AuraEnabled
    public Static Opportunity getOpportunity(String recordId){
        if(!String.isBlank(recordId)){
            Opportunity opp = [SELECT Id,Name,Amount,Due_Amount__c,Initiated_Amount__c,Realized_Amount__c,Account.Email__c,Account.Phone FROM Opportunity WHERE Id=:recordId ];
            System.debug('Opp record == >'+opp);
            return opp;
        }
        return null;
    }
    
    @AuraEnabled
    public static String SaveFile(Id parentId, String fileName, String base64Data, String contentType){
        try{
            opportunity oppRec = [Select Id,(sELECT iD,Amount__c,Due_Amount__c,Initiated_Amount__c,Realized_Amount__c From Invoices2__r order by CreatedDate Desc limit 1) From Opportunity where iD =:parentId ];
            base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
            String attachmentOwner = userInfo.getUserId();  //[Select Invoice__r.Opportunity__r.OwnerId from Receipt__c where id = :parentId].Invoice__r.Opportunity__r.OwnerId;
            Attachment attach = new Attachment();
            attach.parentId = oppRec.Invoices2__r[0].Id;
            attach.Body = EncodingUtil.base64Decode(base64Data);
            attach.Name = fileName;
            attach.ContentType = contentType;
            
            //Insert ContentVersion
            ContentVersion cVersion = new ContentVersion();
            cVersion.ContentLocation = 'S'; //S-Document is in Salesforce. E-Document is outside of Salesforce. L-Document is on a Social Netork.
            cVersion.PathOnClient = attach.Name;//File name with extention
            cVersion.Origin = 'H';//C-Content Origin. H-Chatter Origin.
            cVersion.OwnerId = attachmentOwner;//Owner of the file
            cVersion.Title = attach.Name;//Name of the file
            cVersion.VersionData = attach.Body;//File content
            Insert cVersion;
            
            //After saved the Content Verison, get the ContentDocumentId
            Id conDocument = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cVersion.Id].ContentDocumentId;
            
            //Insert ContentDocumentLink
            ContentDocumentLink cDocLink = new ContentDocumentLink();
            cDocLink.ContentDocumentId = conDocument;//Add ContentDocumentId
            cDocLink.LinkedEntityId = attach.ParentId;//Add attachment parentId
            cDocLink.ShareType = 'V';//V - Viewer permission. C - Collaborator permission. I - Inferred permission.
            cDocLink.Visibility = 'AllUsers';//AllUsers, InternalUsers, SharedUsers
            Insert cDocLink;
            System.debug('cDocLink === >'+cDocLink);
            return cDocLink.id;
        } catch (Exception e){
            system.debug('ERROR :: ' + e.getMessage() + 'AT LINE NUMBER :: ' + e.getLineNumber());
            // HandleBusinessException.captureError('ManualpaymentcreateInvoice', 'SaveFile', e, null);
        }
        return null;
    }
    
    
    @AuraEnabled
    public static void updateOpprecord(string recordId,string PaymentOptions,string PaymentType,String PaymentMode,String PaymentChannel,Decimal UpFrontPayment,String PaymentGateway){
        try{
            Opportunity opp = [SELECT Id,Name,Amount,Due_Amount__c,Initiated_Amount__c,Realized_Amount__c,StageName FROM Opportunity WHERE Id=:recordId ];
            //            if(opp.StageName == 'New')
            opp.StageName = 'Payment Initiated';
            opp.Initiated_Amount__c = UpFrontPayment;
            update opp;
            
            Invoices__c invoiceRecToInsert  = new Invoices__c();
            invoiceRecToInsert.Opportunity__c = recordId;
            if(!String.isBlank(PaymentOptions)){
                invoiceRecToInsert.Payment_Option__c = PaymentOptions;
            }
            if(!String.isBlank(PaymentType)){
                invoiceRecToInsert.Payment_Type__c = PaymentType;
            }
            invoiceRecToInsert.Payment_Mode__c = PaymentMode != null? PaymentMode: PaymentGateway;
            if(!String.isBlank(String.valueOf(UpFrontPayment))){
                invoiceRecToInsert.Initiated_Amount__c = UpFrontPayment;
                invoiceRecToInsert.Amount__c = opp.Amount;
            }
            invoiceRecToInsert.Invoice_Date__c = system.today();
            invoiceRecToInsert.Due_Date__c =  system.today().addDays(2);
            insert invoiceRecToInsert;
            if(PaymentOptions == 'Online Pay')
                RazorpayPaymentHandler.sendPaymentLink(invoiceRecToInsert.Id);

        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
        }
    }
}