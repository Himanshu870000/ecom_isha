public class FetchCaseCOntroller {
    @AuraEnabled
    public static void getCaseData(String caseId) {
        //Map<String, Object> Params = new Map<String, Object>();
        //Params.put('recordId',caseId);
        // Do something with the caseId parameter
        // Flow.Interview.Send_Case_from_Email flow1 = new Flow.Interview.Send_Case_from_Email(Params);
        // flow1.start();
        Case c = new Case ();
        Case renewedCase = new Case ();
        
        c = [SELECT SuppliedEmail,Account.Name,Backened_Team__c,Account.Email__c,Case_New_Status__c,CaseNumber,CreatedDate,Description,IsClosed,IsDeleted,IsEscalated,Is_Damaged__c,Lead__c,Subject,Type FROM Case WHERE Id = :caseId];
        c.Backened_Team__c = '005N000000AkhoZIAR';
        c.Case_New_Status__c = 'On Recovery Team';
        EmailTemplate template = new EmailTemplate ();
        string templateName = '';
        if(c.Is_Damaged__c){
            templateName = 'SendCaseRelatedUpdatesForDamaged';
            
            // Create a new Case record
            Case newCase = c.clone(false, true);
            
            // Update any necessary fields on the new Case record
            newCase.Status = 'New';
            newCase.Subject = 'Clone of ' + c.Subject;
            newCase.Description = c.Description +' '+ c.CaseNumber;
            // Set the Parent Case ID field to link it to the parent Case
            newCase.ParentId = c.Id;
            newcase.Backened_Team__c = '005N000000AkhoZIAR';
            newcase.Case_New_Status__c = 'Damaged';
            // Insert the new Case record
            insert newCase;
            renewedCase = [SELECT SuppliedEmail,Account.Name,Account.Email__c,CaseNumber,Case_New_Status__c,CreatedDate,Description,IsClosed,IsDeleted,IsEscalated,Is_Damaged__c,Lead__c,Subject,Type FROM Case WHERE Id = :newCase.Id];
        }else{
            templateName = 'SendCaseRelatedUpdates';
        }
        // Retrieve the email template
        template = [SELECT Id, Subject,HtmlValue, Body FROM EmailTemplate WHERE DeveloperName =: templateName];
        
        // Create an instance of the SingleEmailMessage class
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        
        // Set the recipient of the email
        email.setToAddresses(new List<String>{c.SuppliedEmail});
        
        // Set the email template ID and specify that you want to use the template's HTML body
        email.setTemplateId(template.Id);
        
        // Replace the merge fields in the email body with actual values from the Case record
        String htmlBody = template.HtmlValue;
        
        if(c.Is_Damaged__c){
            
            htmlBody = htmlBody.replace('{!Case.CaseNumber}', renewedCase.CaseNumber);
            htmlBody = htmlBody.replace('{!Case.Account}', renewedCase.Account.Name);
            htmlBody = htmlBody.replace('{!Case.CreatedDate}', string.valueOf(renewedCase.CreatedDate));
        }else{
            htmlBody = htmlBody.replace('{!Case.CaseNumber}', c.CaseNumber);
            htmlBody = htmlBody.replace('{!Case.Account}', c.Account.Name);
            htmlBody = htmlBody.replace('{!Case.CreatedDate}', string.valueOf(c.CreatedDate));
            
        }
        email.setHtmlBody(htmlBody);
        // Send the email
        Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{email});
        update c;
        
        //Creating a task 
        Task tsk = new Task();
        tsk.Subject = 'Update Customer about Shipment!!';
        tsk.Status = 'Open';
        tsk.Priority = 'High';
        tsk.ActivityDate = system.today().addDays(1);
        tsk.WhatId = caseId;
        tsk.Description = 'We have received details from the integrated system Kindly update Customer ASAP.';
        tsk.Action_To_Be_taken__c = 'Send the email to the customer with the updated Details.';
        tsk.OwnerId = '005N000000AkhoZIAR';
        tsk.Activity_Type__c = 'Email Interaction';
        insert tsk;
        
    }
}