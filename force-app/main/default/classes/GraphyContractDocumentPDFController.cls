global without sharing class GraphyContractDocumentPDFController {
    
    
    Public String oppId {get;set;}
    Public Opportunity oppRec {get;set;}
    Public Account accRec {get;set;}
    Public Date TodayaddFiveDays {get;set;}
    public Date todayDate {get;set;}
    
    global GraphyContractDocumentPDFController(ApexPages.StandardController controller){
        if(!String.isBlank(controller.getId())){
            oppId = controller.getId();
            if(!string.isBlank(oppId)){
                oppRec = [SELECT Id,Name,StageName,AccountId,Amount,Account.Name,Account.BillingStreet, Account.BillingCity, Account.BillingState, Account.BillingPostalCode,Account.BillingCountry,Account.ShippingCity,Account.ShippingCountry,Account.ShippingState FROM Opportunity Where Id=:oppId LIMIT 1];
                TodayaddFiveDays = System.today().addDays(5);
                todayDate = System.today();
            }
        }
    }
    @auraEnabled
    global static void attachPdf(string recordId){
        
        try{
            system.debug('UserInfo.getUserId()-->'+UserInfo.getUserId());
            String reciepientEmail;
            PageReference pdfPage;
            Blob pdfBlob; 
            //internal user
            
            Opportunity opp = new Opportunity();
            opp.Id = recordId;
            opp.StageName = 'Contract Sent';
            update opp;
            
            pdfPage = Page.GraphyContractDocumentPDF;
            pdfPage.getParameters().put('id',recordId);
            pdfBlob = pdfPage.getContent(); 
            
            Attachment attach = new Attachment(parentId = recordId, Name = 'GraphyContractDocumentPDF.pdf', body = pdfBlob); 
            insert attach;
            reciepientEmail = [SELECT Id,Account.Email__c From Opportunity where Id =: recordId].Account.Email__c;
            system.debug('reciepientEmail :: '+ reciepientEmail);
            if(!string.isBlank(reciepientEmail)){
                EmailIUtility.sendEmailForPaymentSuccess(reciepientEmail, 'Graphy Send Contract', 'Opportunity', recordId);
            }
        }catch(exception ex){
            system.debug('Error-->'+ex.getLineNumber());
            system.debug('Error-->>'+ex.getMessage());
        }
    } 
}