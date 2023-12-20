public class SendFinalDeckDesign {
    @AuraEnabled
    Public static void sendEmailForFinalDeck(string recordId){
        system.debug('recordId--'+recordId);
        Opportunity Opprec=[Select Id,AccountId,StageName From Opportunity Where Id=:recordId];
        system.debug('Opprec--'+Opprec);
        
        List<Opportunity> OppList=new List<Opportunity>();
        Opportunity Opp=new Opportunity();
        Opp.Id=Opprec.Id;
        opp.StageName='Design Under Review';
        OppList.add(Opp);
        Update OppList;
        
        List<Contact> Conrec=[Select Id,AccountId,Email From Contact Where AccountId=:Opprec.AccountId AND Email!=NULL order By createdDate DESC Limit 1];
        system.debug('Conrec--'+Conrec);
        
        EmailTemplate et = [Select id, Name, DeveloperName, Subject, Body, HtmlValue from EmailTemplate where Name='Final Deck Acceptance'];
        
        String subject = et.Subject;
        String htmlBody = et.HtmlValue;
        htmlBody = htmlBody.replace('{opportunity.id}',recordId);  
        
        List<String> recipients = new List<String>();
                    /*for(Contact con:Conrec){
            recipients.add(con.Email);
            }*/
        recipients.add('ajeet.kumar@utilitarianlab.com');
        
        Folder__c FolderRec=[Select Id,Name From Folder__c where Opportunity__C =:recordId and Name ='Finalized Deck'];
        system.debug('FolderRec--->'+FolderRec);
        //ContentDistribution ContectRec = [Select ContentVersionId,Name From ContentDistribution Where RelatedRecordId = : FolderRec.Id];
        //system.debug('ContectRec--->'+ContectRec);
        ContentDocumentLink cdl = [SELECT Id, ContentDocumentId, LinkedEntityId,Visibility FROM ContentDocumentLink WHERE LinkedEntityId =: FolderRec.Id limit 1];
        system.debug('cdl--->'+cdl);
        ContentVersion cvRec = [Select Id,VersionData  from ContentVersion where ContentDocumentId =: cdl.ContentDocumentId];
        system.debug('cvRec-->'+cvRec);
       
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
       	Attachment attRec = [Select Id,Body,Name from Attachment where parentId = '001N0000027XVJbIAO'];
        
        Messaging.SingleEmailMessage email=new Messaging.SingleEmailMessage();
        Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
        attachment.setContentType('application/pdf');
        attachment.setFileName('Finalized Deck.pdf');
        attachment.setBody(cvRec.VersionData); //(Blob.valueOf('ContectVersionRec.VersionData'));
        email.setToAddresses(recipients);
        email.setSubject(subject);
        email.setHtmlBody(htmlBody);
        email.setFileAttachments(new Messaging.EmailFileAttachment[] {attachment});
        mails.add(email);
        
        Messaging.sendEmail(mails);
        
    } 
}