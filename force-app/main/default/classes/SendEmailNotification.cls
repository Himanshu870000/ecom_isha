public class SendEmailNotification {
    
    public static void sendDiscoveryNotification(string emailTemplate, set<id> leadId){
        try{
            List<Messaging.SingleEmailMessage> mails =  new List<Messaging.SingleEmailMessage>();  
            List<Lead> leadDetailsList = new  List<Lead>();
            if(!leadId.isEmpty()){
                leadDetailsList = [Select Name,Company,Email,Owner_Name__c From Lead Where id in : leadId ];  
            }
            
            EmailTemplate emailTemplateRec = [Select id, Name, DeveloperName, Subject, Body, HtmlValue from EmailTemplate where Name =: emailTemplate];
            
            if(!leadDetailsList.isEmpty()){
                for (Lead lead : leadDetailsList) {
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    List<String> recipients = new List<String>();
                    
                    recipients.add(lead.Email);
                    //system.debug('recipients------'+recipients);
                    mail.setToAddresses(recipients);
                    mail.setSenderDisplayName('Utilitarian Labs');
                    
                    String htmlBody = emailTemplateRec.Body;
                    
                    if( lead.Name != null ){
                        system.debug('lead.Name::'+lead.Name);
                        htmlBody = htmlBody.replace('{!Lead.Name}', lead.Name);
                        htmlBody = htmlBody.replace('{!User.FirstName}', lead.Owner_Name__c);
                    }
                    //system.debug('htmlBody==>'+htmlBody);
                    mail.setSubject(emailTemplateRec.Subject);
                    mail.setPlainTextBody(htmlBody);
                    mails.add(mail);
                    
                }
            }
            if(!mails.isEmpty()){
                Messaging.sendEmail(mails);  
            }
        }catch(exception ex){
            system.debug('Error==>'+ex.getMessage()+'Error@==>'+ex.getLineNumber());
        }
    }
    public static void sendFollowUpNotification(string emailTemplate, set<id> leadId){
        try{
            List<Messaging.SingleEmailMessage> mails =  new List<Messaging.SingleEmailMessage>();  
            List<Lead> leadDetailsList = new  List<Lead>();
            if(!leadId.isEmpty()){
                leadDetailsList = [Select Name,Company,Email,Owner_Name__c From Lead Where id in : leadId ];  
            }
            
            EmailTemplate emailTemplateRec = [Select id, Name, DeveloperName, Subject, Body, HtmlValue from EmailTemplate where Name =: emailTemplate];
            
            if(!leadDetailsList.isEmpty()){
                for (Lead lead : leadDetailsList) {
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    List<String> recipients = new List<String>();
                    
                    recipients.add(lead.Email);
                    //system.debug('recipients------'+recipients);
                    mail.setToAddresses(recipients);
                    mail.setSenderDisplayName('Utilitarian Labs');
                    
                    String htmlBody = emailTemplateRec.Body;
                    
                    if( lead.Name != null ){
                        htmlBody = htmlBody.replace('{!Lead.Name}', lead.Name);
                        htmlBody = htmlBody.replace('{!User.FirstName}', lead.Owner_Name__c);
                        htmlBody = htmlBody.replace('{!Lead.Company}', lead.Company);
                    }
                    //system.debug('htmlBody==>'+htmlBody);
                    mail.setSubject(emailTemplateRec.Subject);
                    mail.setPlainTextBody(htmlBody);
                    mails.add(mail);
                }
            }
            if(!mails.isEmpty()){
                Messaging.sendEmail(mails);  
            }
        }catch(exception ex){
            system.debug('Error==>'+ex.getMessage()+'Error@==>'+ex.getLineNumber());
        }
    }
    public static void sendDemoNotification(string emailTemplate, set<id> leadId){
        try{
            List<Messaging.SingleEmailMessage> mails =  new List<Messaging.SingleEmailMessage>();  
            List<Lead> leadDetailsList = new  List<Lead>();
            if(!leadId.isEmpty()){
                leadDetailsList = [Select Name,Company,Email,Owner_Name__c From Lead Where id in : leadId ];  
            }
            
            EmailTemplate emailTemplateRec = [Select id, Name, DeveloperName, Subject, Body, HtmlValue from EmailTemplate where Name =: emailTemplate];
            
            if(!leadDetailsList.isEmpty()){
                for (Lead lead : leadDetailsList) {
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    List<String> recipients = new List<String>();
                    
                    recipients.add(lead.Email);
                    //system.debug('recipients------'+recipients);
                    mail.setToAddresses(recipients);
                    mail.setSenderDisplayName('Utilitarian Labs');
                    
                    String htmlBody = emailTemplateRec.Body;
                    
                    if( lead.Name != null ){
                        htmlBody = htmlBody.replace('{!Lead.Name}', lead.Name);
                        htmlBody = htmlBody.replace('{!User.FirstName}', lead.Owner_Name__c);
                        htmlBody = htmlBody.replace('{!Lead.Company}', lead.Company);
                    }
                    //system.debug('htmlBody==>'+htmlBody);
                    mail.setSubject(emailTemplateRec.Subject);
                    mail.setPlainTextBody(htmlBody);
                    mails.add(mail);
                }
            }
            if(!mails.isEmpty()){
                Messaging.sendEmail(mails);  
            }
        }catch(exception ex){
            system.debug('Error==>'+ex.getMessage()+'Error@==>'+ex.getLineNumber());
        }
    }
}