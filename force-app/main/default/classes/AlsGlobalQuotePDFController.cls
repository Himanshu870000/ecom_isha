public class AlsGlobalQuotePDFController {
    
    public Static  String QuoteId {get;set;}
    public Static  Account accRec {get;set;}
    public Static  Quote QuoteRec {get;set;}
    public Static  Contact conRec {get;set;}
    public AlsGlobalQuotePDFController(ApexPages.StandardController controller) {
        try{
            if(!string.isBlank(controller.getId())){
                QuoteId = controller.getId();
                system.debug('QuoteId == >'+QuoteId);
                if(!string.isBlank(QuoteId)){
                    QuoteRec= [SELECT Id,Name,QuoteNumber,createdDate,ExpirationDate,Phone,AccountId FROM Quote WHERE Id=:QuoteId];
                    system.debug('QuoteRec == >'+QuoteRec);
                    if(!String.isBlank(QuoteRec.AccountId)){
                        accRec = [SELECT id,Name,BillingStreet, BillingCity, BillingState, BillingPostalCode,BillingCountry,ShippingCity,ShippingCountry,ShippingState FROM Account WHERE Id=:QuoteRec.AccountId];
                        system.debug('accRec == >'+accRec);
                        conRec = [SELECT Id,Name,Email,FirstName,LastName,Phone,AccountId FROM Contact WHERE AccountId=:accRec.Id LIMIT 1];
                        system.debug('conRec == >'+conRec);
                    }
                }
            }
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
        }        
    }
    
    @AuraEnabled
    Public Static String GenerateQuotePDFAttachement(String recordId){
        try{
            if(!String.isBlank(recordId)){
                if(!String.isBlank(recordId)){
                    PageReference pageRef = page.AlsGlobalQuotePDF;
                    pageRef.getParameters().put('id',recordId);
                    Blob vBody;
                    vBody=pageRef.getContent();
                    Attachment attach = new Attachment();
                    attach.Body = vBody;
                    String nowtime = String.valueOf(System.now());
                    attach.Name = 'QuoteDoc_'+nowtime+'_.PDF';
                    attach.ParentId =recordId;
                    attach.ContentType = 'application/pdf';
                    insert attach; 
                    System.debug('Inserted Attachment === >'+attach);
                    return 'SUCCESS';
                }
            }
            
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
        }
        return 'ERROR';
    }
}