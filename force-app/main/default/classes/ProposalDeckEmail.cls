public class ProposalDeckEmail {
    
    @AuraEnabled
    Public static void sendEmailForConformation(string recordId){
        system.debug('recordId--'+recordId);
        Opportunity Opprec=[Select Id,AccountId From Opportunity Where Id=:recordId];
        
        List<Opportunity> OppList=new List<Opportunity>();
        Opportunity Opp=new Opportunity();
        Opp.Id=Opprec.Id;
        opp.StageName='Proposal Shared';
        OppList.add(Opp);
        Update OppList;
        
        List<Contact> Conrec=[Select Id,AccountId,Email From Contact Where AccountId=:Opprec.AccountId AND Email!=NULL order By createdDate DESC Limit 1];
        system.debug('Conrec--'+Conrec);
        EmailTemplate et = [Select id, Name, DeveloperName, Subject, Body, HtmlValue from EmailTemplate where Name='Proposal Deck'];
        
        String subject = et.Subject;
        String htmlBody = et.HtmlValue;
        htmlBody = htmlBody.replace('{opportunity.id}',recordId);  
        
        List<String> recipients = new List<String>();
       
        recipients.add('ajeet.kumar@utilitarianlab.com');
        Folder__c FolderRec=[Select Id,Name From Folder__c where Opportunity__C =:recordId and Name ='Pitch Deck'];
        system.debug('FolderRec--->'+FolderRec);
        ContentDocumentLink cdl = [SELECT Id, ContentDocumentId, LinkedEntityId,Visibility FROM ContentDocumentLink WHERE LinkedEntityId =: FolderRec.Id limit 1];
        system.debug('cdl--->'+cdl);
        ContentVersion cvRec = [Select Id,VersionData  from ContentVersion where ContentDocumentId =: cdl.ContentDocumentId];
        system.debug('cvRec-->'+cvRec);
        
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        
        
        Messaging.SingleEmailMessage email=new Messaging.SingleEmailMessage();
        Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
        attachment.setContentType('application/pdf');
        attachment.setFileName('Quote PDF.pdf');
        attachment.setBody(cvRec.VersionData); //(Blob.valueOf('ContectVersionRec.VersionData'));
        email.setToAddresses(recipients);
        email.setSubject(subject);
        email.setHtmlBody(htmlBody);
        email.setFileAttachments(new Messaging.EmailFileAttachment[] {attachment});
        mails.add(email);
        
        Messaging.sendEmail(mails);
    }
    
}