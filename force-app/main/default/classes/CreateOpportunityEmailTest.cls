@isTest
public class CreateOpportunityEmailTest {
    @isTest
    static void testCreateOpportunityEmail() {
        // Create a test email
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        email.fromAddress = 'test.sender@example.com';
        email.subject = 'Test Opportunity';
        email.plainTextBody = 'This is a test email body.';
        
        // Create a test Account with a matching email
        Account testAccount = new Account(Name = 'Test Account', Email__c = 'test.sender@example.com');
        insert testAccount;
        
        // Start Test
        Test.startTest();
        
        // Call the handleInboundEmail method
        CreateOpportunityEmail handler = new CreateOpportunityEmail();
        Messaging.InboundEmailResult result = handler.handleInboundEmail(email, null);
        
        // End Test
        Test.stopTest();
        
        // Assert the results
        System.assertEquals(true, result.success, 'Expected success');
        
        // Query for the created Opportunity
        Opportunity createdOpportunity = [SELECT Id, Name, StageName, CloseDate, AccountId FROM Opportunity WHERE Name = 'Test Opportunity' LIMIT 1];
        
        // Assert Opportunity fields
        System.assertNotEquals(null, createdOpportunity, 'Opportunity should be created');
        System.assertEquals('Test Opportunity', createdOpportunity.Name);
        System.assertEquals('Prospecting', createdOpportunity.StageName);
        System.assertEquals(System.today().addDays(30), createdOpportunity.CloseDate);
        System.assertEquals(testAccount.Id, createdOpportunity.AccountId);
    }
}