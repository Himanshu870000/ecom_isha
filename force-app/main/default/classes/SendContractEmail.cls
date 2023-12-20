public without sharing class SendContractEmail {
    
    @AuraEnabled
    public Static String sendEmail(String schoolId)
    {
        String message = '';
        List<School__c>  schoolList = new List<School__c>();
        try{
           
            schoolList = [Select Id,Name,Status__c,Email__c from School__c where Id =:schoolId];
             
             schoolList[0].Status__c = 'Contract Sent ';

             update schoolList ;
            
            List <Messaging.SingleEmailMessage> emails = new List <Messaging.SingleEmailMessage> ();
            List<ContentVersion> cvList = [SELECT Id, Title, VersionData FROM ContentVersion where Title = 'Contract Pdf'];
           // for(Account acc : accList){
                if(schoolList[0].Email__c != null){
                    Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                    email.setToAddresses(new String[] {schoolList[0].Email__c});
                    email.setSubject('Contract Agreement'); 
                    string emailBody =  schoolList[0].Name + ', \n\nPlease find the attached Contract Agreement Pdf.\n\nThanks & Regards,\nEduStoke';
                    email.setPlainTextBody(emailBody);
                    Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                    efa.setFileName('Contract Pdf.pdf');
                    efa.setBody(cvList[0].VersionData);
                    efa.setContentType('application/pdf');
                    email.setFileAttachments(new Messaging.EmailFileAttachment[] { efa });
                    emails.add(email);   
                }             
          //  }
            Messaging.sendEmail(emails);
              message ='SUCCESS';
        }catch(Exception e)
        {
            System.debug('Exception Message-->'+e.getMessage());
            System.debug('Exception LineNumber---->'+e.getLineNumber());
        }
        return message ;
    }

}