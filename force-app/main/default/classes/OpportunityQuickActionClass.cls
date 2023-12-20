public class OpportunityQuickActionClass {
    @AuraEnabled
    public static void sendEmail(String recordId) {
        //recordId='006N000000JWLMXIA5';
        system.debug('oppid===>>'  +recordId);
        Opportunity myOpp =[Select id,AccountId From Opportunity where id=:recordId];  
        system.debug('myOpp===>>'  +myOpp);
        string accountId=myOpp.AccountId;
        List<Contact> conlist = [Select id ,Email,AccountId From Contact where AccountId =:myOpp.AccountId  AND Email != null order By createdDate DESC Limit 1 ];
         system.debug('conlist===>>'  +conlist);
        EmailTemplate emailTemp = [SELECT Id, Name,DeveloperName, Subject, Body, HtmlValue FROM EmailTemplate Where Name ='Request Form Template'];
        
        String subject = emailTemp.Subject;
        
        string HtmlBody=emailTemp.HtmlValue;
        htmlBody = htmlBody.replace('{AccountId}',accountId);
        
        List<String> recipients = new List<String>();
       
        recipients.add('ajeet.kumar@utilitarianlab.com');                            
        
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        
        Messaging.SingleEmailMessage email=new Messaging.SingleEmailMessage();
        
        email.setToAddresses(recipients);
        email.setSubject(subject);
        email.setHtmlBody(htmlBody);
        //Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email })
        mails.add(email);
        Messaging.sendEmail(mails);
        
        if(recordId != null){
          Task taskrec =[ SELECT Id, Subject,Status FROM Task where  WhatId =:recordId AND Subject = 'Send CRF To the Client' Limit 1 ];  
          taskrec.Status = 'Completed';
            Update taskrec;
            
        }
       
    }
    
}