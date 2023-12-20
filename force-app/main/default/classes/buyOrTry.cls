public class buyOrTry {
    @auraEnabled
    public static void processRecordId(string recId){
        
        EmailTemplate emailTemplateRec = [Select id, Name, DeveloperName, Subject, Body, HtmlValue from EmailTemplate where Name = 'SleepCompanytryBuy'];

        string leadEmail = 'ajeet.kumar@utilitarianlabs.com';//[Select id,Email from Lead where Id =: recId].Email;
        if(!string.isEmpty(leadEmail)){
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.setToAddresses(new String[] { leadEmail });
            System.debug(UserInfo.getUserEmail());
            List<Attachment> files = [SELECT Name, Body, ContentType FROM Attachment WHERE ParentId = '0060k00000Fvza9AAB'];
            List<Messaging.EmailFileAttachment> attachments = new List<Messaging.EmailFileAttachment>();
            for (Attachment file: files) {
                Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                if(file.Name.contains('.pdf')){
                    efa.setFileName(file.Name);   
                }
                else{
                    efa.setFileName(file.Name+'.pdf');
                }
                efa.setBody(file.Body);
                efa.setContentType(file.ContentType);
                attachments.add(efa);
            }
            message.setFileAttachments(attachments);
            message.setSubject(emailTemplateRec.SUbject);
            string htmlBody = emailTemplateRec.HtmlValue;
            htmlBody = htmlBody.replace('{!Lead.Name}', 'Ajeet');
            htmlBody = htmlBody.replace('{!Lead.Id}', recId);
            
            message.setHtmlBody(htmlBody);
            system.debug('Succesfully Fired');
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { message });
        }
        
    }
}