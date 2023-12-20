public without sharing class AuraHandler {
    
    @Auraenabled
    public static void taskForSalesTeam(Id leadId){
        Lead leadRec = new Lead();
        leadRec.Id = leadId;
        leadRec.Status='Nurturing';
        update leadRec;
        
        Date todayDate = Date.today();
        List<Task> taskListToBeInserted = New List<Task>();
        Lead ld = [SELECT Id, Sales_Team_Member__c FROM Lead WHERE Id =: leadId];
        if(ld.Sales_Team_Member__c == null){
            ld.Sales_Team_Member__c = '005N000000AkhoZIAR';
        }
        update ld;
        
        Task taskRec = new task();
        taskRec.WhoId = leadId;
        taskRec.Subject = 'Pre Sales Team - Provide Demo!!';
        taskRec.OwnerId = '005N000000AkhoZIAR';
        
        Task taskRec2 = new task();
        taskRec2.WhoId = leadId;
        taskRec2.Subject = 'Follow-up for Demo !!';
        taskRec2.ActivityDate = todayDate.addDays(3);
        taskRec2.OwnerId = '005N000000AkhoZIAR';
        
        
        taskListToBeInserted.add(taskRec);
        taskListToBeInserted.add(taskRec2);
        insert taskListToBeInserted;
        SendVideoLinkToCustomer(leadId);
        
    }
    
    @AuraEnabled
    public static string SendVideoLinkToCustomer(string leadId){
        try{
            List<Lead> leadList = New List<Lead>();
            Emailtemplate emailTempRec = New Emailtemplate();
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            if(leadId != null){
                leadList = [SELECT Id,Firstname,Email FROM Lead WHERE Id =: leadId Limit 1];
            }
            emailTempRec = [Select Id,HtmlValue,Subject from EmailTemplate where Name ='Sapa Video Link Email To Lead'];
            mail.setToAddresses(new String[] {leadList[0].Email});
            mail.setSubject(emailTempRec.Subject);
            string emailHtmlValue = emailTempRec.HtmlValue;
            if(!string.isBlank(leadList[0].FirstName)){
                emailHtmlValue = emailHtmlValue.replace('{!Lead.FirstName}', leadList[0].FirstName);
            }
            mail.setHtmlBody(emailHtmlValue);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            return 'Success';          
        }catch(Exception e){
            return e.getMessage()+e.getLineNumber();
        }
    }

}