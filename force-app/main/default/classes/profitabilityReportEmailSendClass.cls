public class profitabilityReportEmailSendClass {
    @auraEnabled
    public static String sendProfitabilityReport(String recordId){
        List<Messaging.SingleEmailMessage> mails =  new List<Messaging.SingleEmailMessage>(); 
        Account accRec = [SELECT Id, Name, Email__c FROM Account WHERE Id=: recordId LIMIT 1];
        EmailTemplate et= [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where name = 'profitability Email Template' LIMIT 1];
        Attachment files = [SELECT Name, Body, ContentType FROM Attachment WHERE ParentId = '00QN000000B8SN7MAN' limit 1];

        
        System.debug('et-->' + et);
        System.debug('accRec-->' + accRec);
        String htmlBody = et.Body;
        if( accRec.Name != null ){
            system.debug('lead.Name::'+lead.Name);
            htmlBody = htmlBody.replace('{!Account.Name}', accRec.Name);
        }
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
        efa.setFileName(files.Name);
        efa.setBody(files.Body);
        efa.setContentType(files.ContentType);
        
        
        List<String> recipients = new List<String>();
        
        recipients.add('ajeet.kumar@utilitarianlab.com');
        message.setToAddresses(recipients);
        message.setSenderDisplayName('ShopDeck Team');
        
        message.setSubject(et.Subject);
        message.setPlainTextBody(htmlBody);
        //message.setTargetObjectId(accRec.id); 
        message.setReplyTo('no-reply@shopDeck.com');
        message.setWhatId(accRec.Id); //This is important for the merge fields in template to work
        message.setFileAttachments(new Messaging.EmailFileAttachment[]{ efa });
        
        mails.add(message);
        
        if (!mails.isEmpty()) 
        {
            Messaging.sendEmail(mails); 
            System.debug('The email was sent successfully.');
            Return('Success');
        } else {
            System.debug('The email failed to send: ');
            Return('Error');
        }
    }
}