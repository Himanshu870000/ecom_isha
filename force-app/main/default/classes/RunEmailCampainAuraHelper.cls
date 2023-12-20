public class RunEmailCampainAuraHelper {
    
    @AuraEnabled
    Public Static List<Vendor__c> getAllVendorRecord(){
        // List<String> accIdString = new List<String>{'001N000002AUrUBIA1','001N000002AUrALIA1','001N000002AUrFaIAL','001N000002AUr4IIAT','001N000002AUr3AIAT'};
        List<Vendor__c> accList = [SELECT Id,Name,Vendor_Email__c,Vendor_category__c,
                                          Vendor_Phone__c,Bussiness_Structure__c,Onboarding_Stage__c,Vendor_Type__c FROm Vendor__c LIMIT 8];
        System.debug('accList ::'+accList);
        if(!accList.isEmpty()){
            return accList;
        }
        return null;
    }
    
    @AuraEnabled
    public Static List<Vendor_Request__c> insertSelectedVendorRequest(List<String> AccountIdList,String ProductRequestId){
        List<Vendor_Request__c> VendorRequestList = new List<Vendor_Request__c>();
        try{
            if(!String.isBlank(ProductRequestId)){
                System.debug('AccountIdList ::'+AccountIdList);
                System.debug('ProductRequestId ::'+ProductRequestId);
                for(String accId : AccountIdList){
                    Vendor_Request__c opp = new Vendor_Request__c();
                    opp.Vendor__c = accId;
                    opp.Product_Request__c = ProductRequestId;
                    VendorRequestList.add(opp);
                }
                if(VendorRequestList.size()>0){
                    insert VendorRequestList;
                    System.debug('VendorRequestList Record Created ====>'+VendorRequestList);
                    sendEmailAttachemenToVendor(AccountIdList,ProductRequestId);
                    return VendorRequestList;
                }
            }
        }catch(Exception e){
            System.debug('The Error ==>'+e.getMessage() +' AND Error Line No ===>'+e.getLineNumber());
        }
        return null;
    }
    
    @AuraEnabled
    public static string sendEmailAttachemenToVendor(List<String> vendorIdList,String ProductRequestId){
        EmailTemplate emailTempRec = [SELECT Id,Subject,Body,HTMLValue FROM EmailTemplate WHERE Name ='Vendor Email Temp'];
        List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();
        
       // List<Messaging.EmailFileAttachment> attachmentList = new List<Messaging.EmailFileAttachment>();        List<Vendor__c> venderList = new List<Vendor__c>();
        PageReference pdfPage = Page.ProductRequestPDF;
        try{
            if(vendorIdList.size()>0){
                for(Vendor__c str : [SELECT Id,Name,Vendor_Email__c FROM Vendor__c WHERE Id IN:vendorIdList]){
                    String subject = emailTempRec.Subject;
                    String htmlBody = emailTempRec.HtmlValue;
                    htmlBody = htmlBody.replace('{!Vendor__c.Name}', str.Name);
                    Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
                    pdfPage.getParameters().put('id',ProductRequestId);
                    Blob pdfBlob = pdfPage.getContent(); 
                    attach.setContentType('application/pdf');
                    attach.setFileName('RequestRequestLineItem.pdf');
                    attach.setBody(pdfBlob);
                   // attachmentList.add(attach);
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.setSubject(subject);
                    mail.setHtmlBody(htmlBody);
                    mail.setToAddresses(new String[]{str.Vendor_Email__c});
                   // mail.setFileAttachments(attach);
                    mail.setFileAttachments(new Messaging.EmailFileAttachment[] {attach});
                    mailList.add(mail);
                }
                if(!mailList.isEmpty()){
                    Messaging.sendEmail(mailList);
                    system.debug('Email Send Successfully');
                    return 'Success';
                }
            }
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
        }
        return null;
    }
    
}