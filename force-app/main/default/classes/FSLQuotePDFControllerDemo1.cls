public  class FSLQuotePDFControllerDemo1 {
    
    public id QuoteID {get;set;}
    public String recordId {get;set;}
    public string opprecordId {get;set;}
    public string oppLineItemId {get;set;}
    public List<QuoteLineItem> quoteLines {get;set;}
    public QuoteLineItem getCurrentRecord {get;set;}
    public List<OpportunityLineItem> oppLineitemList {get;set;}
    public List<Product_Supplier__c> prodSupplierList {get;set;}
    public List<Product2> prdouctList {get;set;}
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
    Public Set<Id> venderIdSet {get;set;}
    public Map<Id,Id> MapOfVenerIdProductList {get;set;}
    public Vendor__c getVendorDetails {get;set;}
    public   Set<Id> VendoerIdSet {get;set;}
    public OpportunityLineItem getCurrentOppLineRecord {get;set;}
    Public String singleVendorId {get;set;}
    public List<Vendor__c> venderList {get;set;}
    public Opportunity oppRec {get;set;}
    public FSLQuotePDFControllerDemo1(ApexPages.StandardController controller) {
        opprecordId =  controller.getId();{
            this.getQuoteLineItems();
        }
    }
    public void getQuoteLineItems(){
        oppRec = [SELECT Id,Name,Amount from Opportunity WHERE Id=:opprecordId];
        oppLineitemList = [SELECT Id,Name,Quantity,unitPrice,ProductCode,Product2.Name,Vendor__c  FROM OpportunityLineItem WHERE OpportunityId =:opprecordId];
          if(oppLineitemList.size()>0){
            for(OpportunityLineItem oppline : oppLineitemList){
                if(oppline.Vendor__c !=null && String.isNotBlank(oppline.Vendor__c)){
                   // venderIdSet.add(oppline.Vendor__c);
                }else{
                    System.debug('No Vendor Record Found');
                }
            }
          }
        getVendorDetails = [SELECT Id,Name,Address__Street__s,Address__City__s,Address__PostalCode__s FROM Vendor__c WHERE Id='a5cN000000053tqIAA'];
         this.NoToWord=new NumberTOWordConvertion().convert((Integer)oppRec.Amount);
    }
    
    @AuraEnabled
    public static string savePDF(String recordId){
        try {
            List<Attachment> attachmentList = new List<Attachment>();
            PageReference pageRef = page.FslQuotePdf;
            pageRef.getParameters().put('id',recordId);
            blob vBody;
            vBody=pageRef.getContent();
            Attachment attach = new Attachment();
            attach.Body = vBody;
            attach.Name = 'Quote.pdf';
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
    //===============================================================================================================================================================
    // Method for Downloading Attachment for Purches Order on Opportunity
    @AuraEnabled
    public static void saveMultipleOpplineitemPDF(String recordId){
        String PDfToCall = 'NewDemoPDFFslQuotePdf';
         List<OpportunityLineItem> oppLineitemList = new  List<OpportunityLineItem>();
         Map<Id,Id> MapOfOppLineIdVenderId = new  Map<Id,Id>();
        Set<Id> VendoerIdSet = new Set<Id>();
        List<Vendor__c> venderList = new List<Vendor__c>();
         Opportunity oppRec = new Opportunity();
         oppRec = [SELECT Id,Name FROM Opportunity WHERE Id=:recordId];
        oppLineitemList = [SELECT id,Name,OpportunityId,Product2Id,Vendor__c FROM OpportunityLineItem WHERE OpportunityId =:recordId];
         if(oppLineitemList.size()>0){
            for(OpportunityLineItem oppline :oppLineitemList ){
                VendoerIdSet.add(oppline.Vendor__c);
            }
            System.debug('VendoerIdSet === >'+VendoerIdSet.size());
            venderList = [SELECt Id,Name,Address__Street__s,Address__City__s,Address__PostalCode__s FROM Vendor__c WHERE Id IN:VendoerIdSet];
           if(venderList.size()>0){
            List<Attachment> attachListVendor = new List<Attachment>();
             for(Vendor__c ven : venderList){
                String  nowtime = String.valueOf(System.now());
                PageReference pdfPage = Page.NewDemoPDFFslQuotePdf;
                pdfPage.getParameters().put('id',oppRec.Id);
                blob pdfBody;
                pdfBody = (!Test.isRunningTest() ? pdfPage.getContent() : Blob.valueOf('Test content'));
                Attachment attach = new Attachment(); 
                attach.Body = pdfBody;
                attach.Name = 'Purches Order_'+nowtime+'_.pdf';
                attach.ParentId =ven.Id;
                attach.ContentType = 'application/pdf';
                attachListVendor.add(attach);
             }
             if(!attachListVendor.isEmpty()){
                insert attachListVendor;
               System.debug('PO Inserted SUCCESSFULLY For Vendoer ID =:'+attachListVendor[0].Id);
            }
           }
         }
          List<Attachment> attachList = new List<Attachment>();
           String  nowtime = String.valueOf(System.now());
            PageReference pdfPage = Page.NewDemoPDFFslQuotePdf;
            pdfPage.getParameters().put('id',oppRec.Id);
            blob pdfBody;
            pdfBody = (!Test.isRunningTest() ? pdfPage.getContent() : Blob.valueOf('Test content'));
            Attachment attach = new Attachment(); 
            attach.Body = pdfBody;
            attach.Name = 'Purches Order_'+nowtime+'_.pdf';
            attach.ParentId =oppRec.Id;
            attach.ContentType = 'application/pdf';
            attachList.add(attach);
        if(!attachList.isEmpty()){
            insert attachList;
            sendPurchesOrderToMultipleVendor(recordId);
           System.debug('PO Inserted SUCCESSFULLY ID =:'+attachList[0].Id);
        }
    }
    
    //===============================================================================================================================================================
   // Method to Sending Request to Quote PDF with Email Attachement
    public static void sendQuoteToMultipleVendor(String oppId){
        try{
            List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();
            EmailTemplate temp = [SELECT Id,Subject,Body,HTMLValue FROM EmailTemplate WHERE Name ='Email Temp for Request Quote'];
            List<String> ToaddressList = new List<String>();
            ToaddressList = new List<String>{'ajeet.kumar@utilitarianlab.com','kishan.p@utilitarianlab.com','dinesh.b@utilitarianlab.com'};
            String subject = temp.Subject;
            String plainTextBody = temp.body;
            String htmlBody = temp.HTMLValue;
            String  nowtime = String.valueOf(System.now());
            PageReference pdfPage = Page.NewDemoWithQuoteLineRecordIdPDF;
            pdfPage.getParameters().put('id',oppId);
            Blob Blobbody;
            Blobbody =  (!Test.isRunningTest() ? pdfPage.getContent() : Blob.valueOf('Fake content'));
            Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
            attach.setContentType('application/pdf');
            attach.setFileName('Request Quote_'+nowtime+'.pdf');
            attach.Body = Blobbody;
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setHtmlBody(htmlBody);
            mail.setSubject(subject);
            mail.setToAddresses(ToaddressList);
            mail.setFileAttachments(new Messaging.EmailFileAttachment[] { attach }); 
            mailList.add(mail);
            if(!mailList.isEmpty()){
                Messaging.sendEmail(mailList);
            }
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
        }
    }

    //======================================================================================================================================================
    // Method for Sending Email Attachement of Purches Order
     public static void sendPurchesOrderToMultipleVendor(String oppId){
        try{
            List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();
            EmailTemplate temp = [SELECT Id,Subject,Body,HTMLValue FROM EmailTemplate WHERE Name ='Email Temp for Request Quote'];
            List<String> ToaddressList = new List<String>();
            ToaddressList = new List<String>{'ajeet.kumar@utilitarianlab.com','kishan.p@utilitarianlab.com','dinesh.b@utilitarianlab.com'};
            String subject = temp.Subject;
            String plainTextBody = temp.body;
            String htmlBody = temp.HTMLValue;
            String  nowtime = String.valueOf(System.now());
            PageReference pdfPage = Page.NewDemoPDFFslQuotePdf;
            pdfPage.getParameters().put('id',oppId);
            Blob Blobbody;
            Blobbody =  (!Test.isRunningTest() ? pdfPage.getContent() : Blob.valueOf('Fake content'));
            Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
            attach.setContentType('application/pdf');
            attach.setFileName('Purches Order'+nowtime+'.pdf');
            attach.Body = Blobbody;
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setHtmlBody(htmlBody);
            mail.setSubject(subject);
            mail.setToAddresses(ToaddressList);
            mail.setFileAttachments(new Messaging.EmailFileAttachment[] { attach }); 
            mailList.add(mail);
            if(!mailList.isEmpty()){
                Messaging.sendEmail(mailList);
            }
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
        }
    }
}