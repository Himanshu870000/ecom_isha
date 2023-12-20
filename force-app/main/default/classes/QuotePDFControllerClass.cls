public class QuotePDFControllerClass {
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
    public List<Payment_Term_Details__c> paymentDetails {get;set;}
    Public Terms_And_Conditions__c newTermsandCondition {get;set;}
    
    
    public Terms_Condition__c termsCondition {get;set;}
    
    public Double totalAmount {get;set;}
    public Double TotalTax {get;set;}
    public QuotePDFControllerClass(ApexPages.StandardController controller)
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
        this.quoteLines=[Select Id,Product2Id,Product2.Name,Product2.ProductCode,TotalPrice,unitPrice,Quantity,Discount,Description__c,Discount__c,Product_Name_Not_Required__c,Amount_to_be_Paid__c from QuoteLineItem where QuoteId=:this.QuoteID order by CreatedDate asc];
        
        if(!this.quoteLines.isEmpty()){
            for(QuoteLineItem qli : this.quoteLines){
                if(qli.Discount__c != null && qli.Discount__c > 0){
                    qliDiscount = true;
                }
            }
        }


        //Bill info,address and total 
        this.billInfoForQuote=[select BillingStreet,BillingState,BillingPostalCode,BillingCountry,BillingCity,QuoteNumber,GrandTotal,Subtotal,TotalPrice,Discount__c,Amount_to_be_paid__c,
                               Name,Product_Total_Amount__c,
                               Account.Name,Account.BillingStreet,Account.BillingCity,Account.BillingState,
                               Contact.Name,Contact.Email,Contact.Salutation,
                               Account.GSTIN__c,  Account.ShippingCity,
                               Account.ShippingStreet,Account.ShippingState,Account.ShippingCountry,
                               Owner.Name,Owner.Email,Owner.PHone
                               
                               from Quote where Id=:this.QuoteID LIMIT 1];
        
        
        
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


        this.newTermsandCondition= [SELECT Id,Name,Quote__c,Inclusions__c,Drugs_and_Alcohol__c,Changing_Dates__c,Change_in_number_of_attendees__c,Weather__c,Liability_for_Damage__c,Payment__c,Substitution__c,Company_Authority__c,Cancellation__c,Force_Majeure__c,Inflatable_Events__c,Copyright__c FROM Terms_And_Conditions__c where  Quote__c=:this.QuoteID LIMIT 1];

        this.TermsCond=[Select Account.Mode_of_Payment__c,
                        Account.Name,
                        
                        Account.Pre_Dispatch_Inspection_If_Applicable__c,
                        Account.Supply__c,Account.Transit_Insurance__c,Account.Unloading__c,Account.Warranty__c,
                        Account.Installation__c ,Account.Packing_Charges__c from Quote where Id=:this.QuoteID LIMIT 1];
        this.TotalQty=[Select sum(Quantity) qty from QuoteLineItem where QuoteId=:this.QuoteID ];
        this.paymentDetails=[Select Id,Name,Percentage_Of_Cost__c,Tax__c,Payment_Status__c,Due_Date__c,Amount__c,Sequence__c From Payment_Term_Details__c ];
        
        //System.debug(this.paymentDetails[0].Total__c);
        // this.termsCondition=[Select packaging_charge__c,Delivery__c,Routing_Number__c,Swift_Code__c,SWIFT_Code_of_Federal_Bank_s_Correspond__c,Transit_Insurance__c,Transit_Insurance_New__c,Federal_Bank_s_correspondent__c,Federal_Bank_s_a_c_with_Correspondent__c,A_c_Name__c,A_c_no__c,CIN__c,GSTIN__c,Mode_of_payment__c,MSME_No__c,Our_Banker__c,Prices__c,Supply__c,Supply_New__c,Tax_and_Duties__c,Tax_and_Duties_new__c,Validity__c,IFSC_Code__c,
        //                      Installation__c,Installation_New__c,Warranty__c,Unloading__c,Unloading_New__c,Pre_Dispatch_Inspection_If_Applicable__c,
        //                      Note__c,Payment_Term__c,packaging_charge_New__c From Terms_Condition__c where  Quote__c=:this.QuoteID LIMIT 1];
        // System.debug('termsCondition  Data :::'+termsCondition);
        
        this.TotalTax=0;
        for(Payment_Term_Details__c terms:paymentDetails){
            System.debug(terms.Percentage_Of_Cost__c);
            if(terms.Tax__c == null){
                terms.Tax__c=0;
            }else{
                this.showTaxColoumn = true;
            }
            if(terms.Tax__c > 0){
                this.TotalTax = this.TotalTax + terms.Tax__c;
            }
            
        }
        System.debug(this.totalAmount);
        System.debug(billInfoForQuote.GrandTotal);
        System.debug(this.TotalTax);
        //  this.totalAmount=billInfoForQuote.Amount_to_be_paid__c+((billInfoForQuote.Amount_to_be_paid__c *this.TotalTax)/100);
        System.debug(this.totalAmount);
        System.debug(this.termsCondition);
        if(this.TotalQty!=null)
        {
            this.qty=this.TotalQty.get('qty');
        }
        Integer data = 35000 ; 
        System.debug('data ==== >'+data);
        //  this.NoToWord=new NumberTOWordConvertion().convert((Integer)billInfoForQuote.Amount_to_be_paid__c);
    }
    
    @AuraEnabled
    public static string savePDFQuote(String recordId){
        try {
            List<Attachment> attachmentList = new List<Attachment>();
            PageReference pageRef = page.QuotePDF_InterState;
            pageRef.getParameters().put('id',recordId);
            blob vBody;
            vBody=pageRef.getContent();
            Attachment attach = new Attachment();
            attach.Body = vBody;
            attach.Name = 'QuotePDF'+'_'+System.now()+'.pdf';
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