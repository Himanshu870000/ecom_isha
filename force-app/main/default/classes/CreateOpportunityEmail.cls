public class CreateOpportunityEmail implements Messaging.InboundEmailHandler{
    public Messaging.InboundEmailResult handleInboundEmail(Messaging.inboundEmail email,Messaging.InboundEnvelope envelope){
        Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
        String senderEmail = email.fromAddress;
        String emailSubject = email.subject;
        system.debug('Email--->'+email);
        system.debug('Emailbody--->'+email.plainTextBody);
        List<Account> senderAccount=[SELECT Id,Name,Email__c from Account where Email__c=:senderEmail];
        if (!senderAccount.isEmpty()) {
            try{
                Opportunity opp = new Opportunity();
                opp.Name = emailSubject;
                opp.StageName = 'Prospecting'; // Set the appropriate StageName
                opp.CloseDate = System.today().addDays(30); // Set the Close Date
                opp.AccountId = senderAccount[0].Id; // Associate the Opportunity with the Account
                
                // Insert the Opportunity
                insert opp;
                result.success = true;
            } catch(Exception e){
                String errorMessage = e.getMessage();
                result.message = errorMessage;
                result.success = false;            
            }
        }
        
        return result;                                                               
    }
}