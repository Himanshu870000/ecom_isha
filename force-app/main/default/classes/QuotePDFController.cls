public class QuotePDFController {

    public id QuoteID {get;set;}
    public List<QuoteLineItem> quoteLines {get;set;}
    public Quote billInfoForQuote {get;set;}
    public QuoteDocument quoteDoc {get;set;}
    public Quote TermsCond {get;set;}
    public aggregateResult TotalQty {get;set;}
    public Object qty {get;set;}
    
    Public Boolean showTaxColoumn {get;set;}
    public String quoteVersion {get;set;}
    public string CreatedDate {get;set;}
    public string NoToWord {get;set;}
    //public List<Payment_Term_Details__c> paymentDetails {get;set;}
    public decimal totalPrice {get;set;}
    
    public Terms_Condition__c termsCondition {get;set;}
    
    public Double totalAmount {get;set;}
    public Double TotalTax {get;set;}
    public QuotePDFController()
    {
        this.totalAmount=0;
        string id= ApexPages.currentPage().getParameters().get('id');
        System.debug('ID::'+id);
        //id = '0Q0N0000000AlvFKAS';
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
        totalPrice = 1;
        this.showTaxColoumn = false;
		//Quote Line Items of Quote
        this.quoteLines=[Select Id,OpportunityLineItem.Price_on_Request__c,ProdImage__c,ListPrice,Product2Id,Product2.Make__c,Product2.Name,Product2.ProductCode,Product2.HSN_Code__c,Product2.Image__c,Product2.Description,Product2.Product_Image_URL__c,TotalPrice,unitPrice,Quantity,Discount from QuoteLineItem where QuoteId=:this.QuoteID order by CreatedDate asc];
        
        //Bill info,address and total 
        this.billInfoForQuote=[select QuoteNumber,GrandTotal,Subtotal,TotalPrice,
                               Name,
		Account.Name,Account.BillingStreet,Account.BillingCity,Account.BillingState,
		Contact.Name,Contact.Email,Contact.Salutation,
		Account.ShippingCity,
		Account.ShippingStreet,Account.ShippingState,Account.ShippingCountry,
                               Owner.Name,Owner.Email,Owner.PHone
                               
                               from Quote where Id=:this.QuoteID LIMIT 1];
           for(QuoteLineItem quote : quoteLines){
                totalPrice = quote.ListPrice * quote.Quantity; 
            }
        //Terms and conditions
        //select Id,Name,ContentVersionDocumentId,Document from QuoteDocument where QuoteId='0Q00w0000001mH1CAI'
        List<QuoteDocument> quoteDoc=[select Id,Name,ContentVersionDocumentId,Document,CreatedDate  from QuoteDocument where QuoteId=:this.QuoteID  order by CreatedDate desc];
        if(quoteDoc.size() >= 1){
        	this.quoteDoc=quoteDoc[0];
            this.quoteVersion='|'+(quoteDoc.size()+1)+'';
        }
        else{
            //System.debug(quoteDoc[0]);
            this.quoteVersion='';
        }
        
        this.TotalQty=[Select sum(Quantity) qty from QuoteLineItem where QuoteId=:this.QuoteID ];
        //this.paymentDetails=[Select Id,Name,Percentage_Of_Cost__c,Total__c,Quote__r.QuoteNumber,Tax__c,Payment_Status__c,Due_Date__c,Amount__c,Total_Amount__c,Sequence__c From Payment_Term_Details__c WHERE Quote__c=:this.QuoteID AND Payment_Term_Applicable__c=true ORDER BY Sequence__c];
        
        //System.debug(this.paymentDetails[0].Total__c);
        this.termsCondition=[Select packaging_charge__c,Delivery__c,Routing_Number__c,Swift_Code__c,SWIFT_Code_of_Federal_Bank_s_Correspond__c,Transit_Insurance__c,Federal_Bank_s_correspondent__c,Federal_Bank_s_a_c_with_Correspondent__c,A_c_Name__c,A_c_no__c,CIN__c,GSTIN__c,Mode_of_payment__c,MSME_No__c,Our_Banker__c,Prices__c,Supply__c,Tax_and_Duties__c,Validity__c,IFSC_Code__c,
                             Installation__c,Warranty__c,Unloading__c,Pre_Dispatch_Inspection_If_Applicable__c,
                             Note__c From Terms_Condition__c where  Quote__c=:this.QuoteID];
        this.TotalTax=0;
        /*for(Payment_Term_Details__c terms:paymentDetails){
            System.debug(terms.Percentage_Of_Cost__c);
            if(terms.Tax__c == null){
                terms.Tax__c=0;
            }else{
                this.showTaxColoumn = true;
            }
            if(TotalTax==0){
                this.TotalTax=terms.Tax__c;
            }
            
        }*/
        System.debug(this.totalAmount);
        System.debug(billInfoForQuote.GrandTotal);
        System.debug(this.TotalTax);
        //this.totalAmount=billInfoForQuote.Amount_to_be_paid__c+((billInfoForQuote.Amount_to_be_paid__c *this.TotalTax)/100);
        System.debug(this.totalAmount);
        //System.debug(this.termsCondition);
        if(this.TotalQty!=null)
        {
           this.qty=this.TotalQty.get('qty');
        }
        this.NoToWord=new NumberTOWordConvertion().convert((Integer)billInfoForQuote.TotalPrice);
    }
    
    @AuraEnabled
    public static string savePDF(String url,String id,String fileName){
        try {
            
            PageReference ref = new PageReference(url);
            ContentVersion cont = new ContentVersion();
            
            cont.Title = fileName;
            cont.PathOnClient = fileName+'.pdf';
            cont.VersionData = ref.getContentAsPdf();
            cont.Origin = 'H';
            
            insert cont;
            
            /*Attachment att = new Attachment(Body = ref.getContentAsPdf(), contentType = 'application/pdf', Name = fileName, parentId = id);
            insert att;
            System.debug('---'+att.Id); */
            ContentDocumentLink cdl = createContentLink(cont.Id, id);
            return 'Success';
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    private static ContentDocumentLink createContentLink(String contentVersionId, String recordId) {
        if (contentVersionId == null || recordId == null) { return null; }
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = [ SELECT ContentDocumentId FROM ContentVersion WHERE Id =: contentVersionId ].ContentDocumentId;
        cdl.LinkedEntityId = recordId;
        cdl.ShareType = 'V';
        try {
            insert cdl;
            return cdl;
        } catch(DMLException e) {
            System.debug(e);
            return null;
        }
    }
}