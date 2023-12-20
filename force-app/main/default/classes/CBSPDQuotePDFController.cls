public without sharing class CBSPDQuotePDFController {
    
    public id QuoteID {get;set;}
    public List<QuoteLineItem> quoteLines {get;set;}
    public Quote billInfoForQuote {get;set;}
    public QuoteDocument quoteDoc {get;set;}
    public Quote TermsCond {get;set;}
    public boolean qliDiscount {get;set;}
    public aggregateResult TotalQty {get;set;}
    public Object qty {get;set;}
    
    Public Boolean showTaxColoumn {get;set;}
    public String quoteVersion {get;set;}
    public string CreatedDate {get;set;}
    public string NoToWord {get;set;}  
    public Double totalAmount {get;set;}
    public Double TotalTax {get;set;}
    public CBSPDQuotePDFController(ApexPages.StandardController controller)
    {
        this.totalAmount=0;
        string id= ApexPages.currentPage().getParameters().get('id');
        System.debug(id);
        if(id!=null)
        {
            this.QuoteID=id;
            this.getQuoteLineItems();
            DateTime todaysDate = System.today();
            CreatedDate = todaysDate.format('dd-MM-yyyy');
            System.debug(CreatedDate);
        }
    }
    public void getQuoteLineItems()
    {
        this.showTaxColoumn = false;
        //Quote Line Items of Quote
        this.quoteLines=[ Select Id,Product2Id,Product2.Name,Product2.ProductCode,TotalPrice,unitPrice,Quantity,Discount from QuoteLineItem where QuoteId=:this.QuoteID order by CreatedDate asc];
        this.billInfoForQuote=[select BillingStreet,BillingState,BillingPostalCode,BillingCountry,BillingCity,QuoteNumber,GrandTotal,Subtotal,TotalPrice,
                               Name,
                               Account.Name,Account.BillingStreet,Account.BillingCity,Account.BillingState,
                               Contact.Name,Contact.Email,Contact.Salutation,
                               Account.GSTIN__c,  Account.ShippingCity,
                               Account.ShippingStreet,Account.ShippingState,Account.ShippingCountry,
                               Owner.Name,Owner.Email,Owner.PHone
                               
                               from Quote where Id=:this.QuoteID LIMIT 1];
        
        this.NoToWord=new NumberTOWordConvertion().convert((Integer)billInfoForQuote.TotalPrice);
        
        List<QuoteDocument> quoteDoc=[select Id,Name,ContentVersionDocumentId,Document,CreatedDate  from QuoteDocument where QuoteId=:this.QuoteID  order by CreatedDate desc];
        if(quoteDoc.size() >= 1){
            this.quoteDoc=quoteDoc[0];
            this.quoteVersion='|'+(quoteDoc.size()+1)+'';
        }
        else{
            //System.debug(quoteDoc[0]);
            this.quoteVersion='';
        } 
    }
    
    @AuraEnabled
    public static string savePDFCBSPD(String recordId){
        try {
            
            List<Attachment> attachmentList = new List<Attachment>();
            PageReference pageRef = page.CBSPDQuotePDF;
            pageRef.getParameters().put('id',recordId);
            blob vBody;
            vBody=pageRef.getContent();
            Attachment attach = new Attachment();
            attach.Body = vBody;
            attach.Name = 'Quote Template.pdf';
            attach.ParentId = recordId;
            attach.ContentType = 'application/pdf';
            attachmentList.add(attach);
            if(!attachmentList.isEmpty()){
                insert attachmentList;
                system.debug('attachmentList ID==>' +attachmentList[0].Id);
            }
            return 'Success';
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    
    
}