public class EmailIUtility {
    public static void sendEmailForPaymentSuccess(string email, String templateName, String objName, string parentId){
        try{
            //Invoice__c invDetails = [select name,Due_Date__c from Invoice__c where Account__r.id =:accId ORDER BY lastmodifieddate DESC limit 1];
            List<Invoice__c> invoiceDetails = new List<Invoice__c>();
            List<Opportunity> OpportunityDetails = new List<Opportunity>();
            List<Lead> leadList = new List<Lead>();
            system.debug('email-->' + email);
            system.debug('parentId-->' + parentId);
            EmailTemplate et = [Select id, Name, DeveloperName, Subject, Body, HtmlValue
                                from EmailTemplate
                                where name = :templateName];
            Attachment files = [SELECT Name, Body, ContentType
                                FROM Attachment
                                WHERE ParentId = :parentId
                                ORDER BY lastmodifieddate DESC
                                limit 1];
            List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
            system.debug('mails' + mails);
           
            if (!String.isBlank(email)){
                // Step 1
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                efa.setFileName(files.Name);
                efa.setBody(files.Body);
                efa.setContentType(files.ContentType);
                
                List<String> recipients = new List<String>();
                recipients.add(email);
                system.debug('recipients------' + recipients);
                mail.setToAddresses(recipients);
                mail.setReplyTo('test@email.com');
                mail.setSenderDisplayName('GRAPHY');
                String subject = et.Subject;
                String htmlBody = et.HtmlValue; 
                
                mail.setSubject(subject);
                mail.setHtmlBody(htmlBody);
                mail.setFileAttachments(new Messaging.EmailFileAttachment[]{ efa });
                mails.add(mail);
                system.debug('mails :: ' + mails);
            }
            Messaging.sendEmail(mails);
        } catch (Exception e){
            System.debug('Error Line==>' + e.getLineNumber() + 'Error Message==>' + e.getMessage());
        }
    }
}