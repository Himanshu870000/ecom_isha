public class GraphySendContractHelper {
    @AuraEnabled
    public static void sendEmail(Id opportunityId) {
        // Retrieve the content from a Visualforce page
        PageReference vfPage = new PageReference('/apex/YourVisualforcePage');
        String content = vfPage.getContent().toString();
        
        // Retrieve the Email__c field value from the Opportunity record
        Opportunity opportunity = [SELECT Id, Account.Email__c FROM Opportunity WHERE Id = :opportunityId LIMIT 1];
        String recipientEmail = opportunity.Account.Email__c;
        
        // Send the email
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setToAddresses(new String[]{recipientEmail});
        email.setSubject('Your email subject');
        email.setPlainTextBody('Your email content');
        email.setHtmlBody(content);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[]{email});
    }
}