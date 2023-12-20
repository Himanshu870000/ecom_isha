global class GraphyShareMrktBroucherHelper {
    @auraEnabled
    global static void attachPdf(string recordId){
        
        try{
            system.debug('UserInfo.getUserId()-->'+UserInfo.getUserId());
            String reciepientEmail;
            PageReference pdfPage;
            Blob pdfBlob; 
            //internal user
            pdfPage = Page.GraphyMarketingPDF;
//            pdfPage.getParameters().put('id',recordId);
            pdfBlob = pdfPage.getContent(); 
            Opportunity opp = new Opportunity();
            opp.Id = recordId;
            opp.StageName = 'Value Proposition';
            update opp;
            
            Attachment attach = new Attachment(parentId = recordId, Name = 'GraphyMarketingBroucher.pdf', body = pdfBlob); 
            insert attach;
            reciepientEmail = [SELECT Id,Account.Email__c From Opportunity where Id =: recordId].Account.Email__c;
            system.debug('reciepientEmail :: '+ reciepientEmail);
            if(!string.isBlank(reciepientEmail)){
                EmailIUtility.sendEmailForPaymentSuccess(reciepientEmail, 'Graphy Marketing Brochure', 'Opportunity', recordId);
            }
        }catch(exception ex){
            system.debug('Error-->'+ex.getLineNumber());
            system.debug('Error-->>'+ex.getMessage());
        }
    } 
}