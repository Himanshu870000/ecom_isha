public class UploadDocumentViaEmailController{
    @AuraEnabled
    public Static void SendEmail(id accId){
        System.debug('accId ===> ' + accId);
        try{
            List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();
            String sObjName = accId.getSObjectType().getDescribe().getName();
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(  );
            Account acc = new Account();

            if ( sObjName == 'Account' ){
                acc = [Select id, Name, Email__c, (Select Id, Name, LastName, FirstName, email
                                                   From Contacts)
                       From Account
                       Where Id = :accid];
            }
            System.debug('acc ====> ' + acc);
            list<String> EmialAddresses = new list<String>();
            EmialAddresses.add(acc.contacts[0].email);
            mail.setToAddresses(EmialAddresses);
            mail.setSubject('Upload Document');

            String body = 'Dear ' + acc.Contacts[0].Name + ', ' + '<br/><br/>';
            body += 'Please find the link below to attach the document' + '<br/>';
            body +='<a href=https://sales-production--fsldemo--c.sandbox.vf.force.com/apex/AccountSummary?id=' + accid+'>Upload Document.</a>' + + '<br/>';
            body += 'Thank You';
            mail.setHtmlBody(body);

            mailList.add(mail);
            if ( !mailList.isEmpty() ){
                Messaging.sendEmail(mailList);

            }


        }
        catch ( Exception e ){
            System.debug('the error has occured due to ====> ' + e.getMessage() + 'at line numer =====> '+ e.getLineNumber());

        }
    }

}