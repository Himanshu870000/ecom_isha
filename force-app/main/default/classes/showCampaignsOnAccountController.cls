public with sharing class showCampaignsOnAccountController {
    public showCampaignsOnAccountController() {

    }

    @AuraEnabled(cacheable=true)
    public static List<Campaign> getCampaigns(){
        try{
            List<Campaign> campaignList = [SELECT Id,Name From Campaign WHERE IsActive = true];
            return campaignList;
        }catch(Exception e){
            return null;
        }
    }

    @AuraEnabled(cacheable=true)
    public static void sendEmailToAccount(string campaignName, string accountId){
        try{
            system.debug('campName ==> '+campaignName);
            system.debug('accountId ==> '+accountId);
            Account accRecord = [SELECT Id,Name,Email__c,Phone FROM Account WHERE Id=:accountId];
            
           
            system.debug('accRecord ==> '+accRecord);
            List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
            Emailtemplate emailTempRec = New Emailtemplate();
            if(campaignName == 'Assured Admission Campaign'){
                emailTempRec =  [Select Id,Name,HtmlValue,Subject from EmailTemplate where Name ='Assured Admission Campaign Email to Account'];
            }else if(campaignName == 'Spotlight Campaign'){
                emailTempRec =  [Select Id,Name,HtmlValue,Subject from EmailTemplate where Name ='Spotlight Campaign Email to Account'];
            }else{
                emailTempRec =  [Select Id,Name,HtmlValue,Subject from EmailTemplate where Name ='Admission Campaign Email to Account']; 
            }
            system.debug('emailTempRec.Name ==> '+emailTempRec.Name);
            if(accRecord != null){
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setToAddresses(new String[] { accRecord.Email__c});
                mail.setSubject(emailTempRec.Subject);
               
                Attachment attRec = [SELECT Name, Body, ParentId,ContentType,createdDate FROM Attachment WHERE ParentId = '003N000001yEnj1IAC'];
                
                Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
                attachment.setFileName('Broucher.pdf'); 
                attachment.setBody(attRec.Body); // Replace with your attachment content as Blob
                mail.setFileAttachments(new List<Messaging.EmailFileAttachment>{attachment});

                string emailHtmlValue = emailTempRec.HtmlValue;
                if(!string.isBlank(accRecord.Name)){
                    emailHtmlValue = emailHtmlValue.replace('{!Account.Name}', accRecord.Name); 
                }
                if(!string.isBlank(accRecord.Phone)){
                    emailHtmlValue = emailHtmlValue.replace('{!Account.Phone}', accRecord.Phone); 
                }
                mail.setHtmlBody(emailHtmlValue);
                emailList.add(mail);
                if(!emailList.isEmpty()){
                    Messaging.sendEmail(emailList);
                }
            }
        }catch(Exception e){
            system.debug(e.getMessage()+e.getLineNumber());
        }
    }
}