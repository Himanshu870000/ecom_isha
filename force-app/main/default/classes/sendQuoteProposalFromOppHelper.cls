public class sendQuoteProposalFromOppHelper {
    @auraEnabled
    public static string sendQuotePDF(string recordId){
        opportunity oppRec = [Select id,StageName,Account.Email__c,Name,Amount from Opportunity where id =:recordId ];
        system.debug('oppRec.Amount--->'+oppRec.Amount);
        if(oppRec.Amount == null || oppRec.Amount <= 0 ){
            return 'Amount';
        }else if (oppRec.Account.Email__c == null){
            return 'Email';
        }
        oppRec.StageName = 'Proposal/Quote Sent';
        update oppRec;
        
        EmailTemplate emailTemplateRec = [Select id, Name, DeveloperName, Subject, Body, HtmlValue from EmailTemplate where Name = 'Quote/Proposal'];

        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        Attachment att = [Select Id,Body,Name from Attachment where parentId = '001N0000027XVJbIAO'];
        
        Messaging.SingleEmailMessage email=new Messaging.SingleEmailMessage();
        Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
        attachment.setContentType('application/pdf');
        attachment.setFileName('Xseed Proposal.pdf');
        attachment.setBody(att.body); //(Blob.valueOf('ContectVersionRec.VersionData'));
        email.setToAddresses(new List<String> {oppRec.Account.Email__c});
        email.setSubject(emailTemplateRec.subject);
        string htmlBody = emailTemplateRec.HtmlValue;
        htmlBody = htmlBody.replace('{!Opportunity.Name}', oppRec.Name);

        email.setHtmlBody(htmlBody);
        email.setFileAttachments(new Messaging.EmailFileAttachment[] {attachment});
        mails.add(email);
        
        Messaging.sendEmail(mails);
        return 'Success';
    }
}