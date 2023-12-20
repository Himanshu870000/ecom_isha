public class FormRequestEmail {

    @AuraEnabled
    Public static void sendEmailForCustomerRequest(string recordId){
        system.debug('recordId--'+recordId);
        Opportunity Opprec=[Select Id,AccountId From Opportunity Where Id=:recordId];
        
        List<Opportunity> OppList=new List<Opportunity>();
        Opportunity Opp=new Opportunity();
        Opp.Id=Opprec.Id;
        opp.StageName='Under Client Requirement';
        OppList.add(Opp);
        Update OppList;
        
        List<Contact> Conrec=[Select Id,AccountId,Email From Contact Where AccountId=:Opprec.AccountId AND Email!=NULL order By createdDate DESC Limit 1];
        system.debug('Conrec--'+Conrec);
        
        EmailTemplate et = [Select id, Name, DeveloperName, Subject, Body, HtmlValue from EmailTemplate where Name='Customer Requirement Request'];
        
        String subject = et.Subject;
        String htmlBody = et.HtmlValue;
        htmlBody = htmlBody.replace('{opportunity.id}',recordId);  
        
        List<String> recipients = new List<String>();
        //for(Contact con:Conrec){
           // recipients.add(con.Email);
        //}
        recipients.add('ajeet.kumar@utilitarianlab.com');
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        
       Messaging.SingleEmailMessage email=new Messaging.SingleEmailMessage();
        
       email.setToAddresses(recipients);
       email.setSubject(subject);
       email.setHtmlBody(htmlBody);
       mails.add(email);
        
        Messaging.sendEmail(mails);
    }
}