public without sharing  class AfterInsertInvoicePDF {
    
    @Future (callout=true)
    public static void insertInvoiceAttachemt(List<Id> invListId){
        try{
            if(invListId.size() > 0){
                Set<Id> InvIdSet =new Set<Id>();
                for(Id inv : invListId){
                    InvIdSet.add(inv);
                }
                system.debug('InvIdSet::'+InvIdSet);
                if(invIdSet.size() > 0){
                    List<Invoices__c> invListToInsert = [SELECT id,Name,Amount__c,Account__c,Opportunity__c,CreatedDate FROM Invoices__c WHERE Id IN:InvIdSet];
                    system.debug('invListToInsert::'+invListToInsert);
                    List<Attachment> attachList = new List<Attachment>();
                    if(invListToInsert.size()>0){
                        for(Invoices__c inv : invListToInsert){
                            system.debug('inv::'+inv);
                            PageReference pdfPage = Page.InvoicePDF;   
                            pdfPage.getParameters().put('id',inv.Id);
                            blob pdfBody;
                            pdfBody = (!Test.isRunningTest() ? pdfPage.getContent() : Blob.valueOf('Fake content'));
                            Attachment attach = new Attachment(); 
                            attach.Body = pdfBody;
                            attach.Name = inv.Name+'_'+System.now()+'_.Pdf';
                            attach.IsPrivate = false;
                            system.debug('inv.Id::'+inv.Id);
                            attach.ParentId = inv.Id;
                            attach.ContentType = 'application/pdf';
                            attachList.add(attach);
                        }
                        system.debug('attachList::'+attachList);
                        if(!attachList.isEmpty()){
                            insert attachList;
                            AfterInsertInvoicePDF.SendEmailPDFToAccount(invListId);
                        }
                    } 
                }
            }
        }catch(Exception e){
            System.debug('Error Message ==> '+e.getMessage() + ' && Error Line == >'+e.getLineNumber());
        }
    }
    
    Public static void SendEmailPDFToAccount(List<Id> InvIdSet ){
        if(InvIdSet.size() > 0){
            EmailTemplate temp = [SELECT Id,Subject,Body,HTMLValue FROM EmailTemplate WHERE Name ='Invoice Paid'];
            List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>(); 
            List<Invoices__c> invListToInsert = [SELECT id,Name,Amount__c,School__r.Name,School__r.Email__c FROM Invoices__c WHERE Id IN:InvIdSet];
            if(invListToInsert.size() > 0){
                for(Invoices__c inv : invListToInsert){
                    PageReference pdfPage = Page.InvoicePDF;
                    pdfPage.getParameters().put('id',inv.id);
                    Blob Blobbody;
                    Blobbody =  (!Test.isRunningTest() ? pdfPage.getContent() : Blob.valueOf('Fake content'));
                    Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
                    attach.setContentType('application/pdf');
                    attach.setFileName(inv.name+'_Invoice.pdf');
                    attach.setInline(false);
                    attach.Body = Blobbody;
                    String htmlBody = temp.HTMLValue;
                    String subject = temp.Subject;
                    String plainTextBody = temp.body;
                    if(inv.Account__r.Name !=null && inv.Account__r.Email__c !=null){
                        htmlBody = htmlBody.replace('{!Invoices__c.Name}', inv.Name);
                        htmlBody = htmlBody.replace('{!Invoices__c.Account__r.Name}', String.valueOf(inv.School__r.Name));
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        mail.setHtmlBody(htmlBody);
                        mail.setSubject(subject);
                        mail.setPlainTextBody(plainTextBody);
                        mail.setToAddresses(new List<String> {inv.School__r.Email__c});
                        mail.setFileAttachments(new Messaging.EmailFileAttachment[] { attach }); 
                        mailList.add(mail);
                    }
                }
            }
            Messaging.sendEmail(mailList);
        }   
    }
}