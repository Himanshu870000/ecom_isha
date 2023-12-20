global class EmailServiceInbound implements Messaging.InboundEmailHandler {
    
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
        String myPlainText= '';
        // Add the email plain text into the local variable 
        myPlainText = email.plainTextBody;        
        //Getting the Keywords from custom setting
        Email_config__c ec = [Select id,name, Case_Keyword__c , Opportunity_Creating_Keyword__c, Task_Creation_Keypoint__c from Email_config__c];
        List<Contact> Conlist = [Select id,AccountId from contact where email = :email.FromAddress];
        system.debug('email.email()'+email);
        system.debug('Conlist.size()'+Conlist.size());
        If (Conlist.size() > 0){
            //Add Inbound Email Message for contact
            EmailMessage conEmailMessage = new EmailMessage();
            conEmailMessage.ToAddress =  String.join(email.toAddresses, ',');
            conEmailMessage.FromAddress = email.FromAddress;
            conEmailMessage.FromName = email.FromName;
            conEmailMessage.Subject = email.subject;
            conEmailMessage.status = '2';
            conEmailMessage.HtmlBody = email.htmlBody;
            System.debug('htmlBody:>>>> ' + email.htmlBody );
            conEmailMessage.Incoming= True;
            conEmailMessage.TextBody = email.plainTextBody;
            System.debug('TextBody:>>>>> ' + email.plainTextBody);
            conEmailMessage.Contact__c =Conlist[0].Id;
            insert conEmailMessage;
            System.debug('Reply Email: ' + conEmailMessage ); 
            
            EmailMessageRelation emr = new EmailMessageRelation();
            emr.EmailMessageId = conEmailMessage.id;
            emr.RelationId = Conlist[0].Id;// user id of the sender
            emr.RelationAddress = email.FromAddress;
            emr.RelationType = 'FromAddress';
            insert emr; 
            
             //Creating the Case for new requuirement
             
            if(email.plainTextBody.contains(ec.Case_Keyword__c)){
                Case c1 = new Case (subject='Clarification Needed ASAP.',AccountId=Conlist[0].AccountId,Type = 'Problem');
                insert c1;
                system.debug('case is inserted'+c1.Id);
                
            }
            //Creating the Opportunity for new requuirement
            
            if(email.plainTextBody.contains(ec.Opportunity_Creating_Keyword__c)){
                Opportunity opp = new Opportunity();
                opp.CloseDate=date.today().addMonths(2);
                opp.Name='new requirement';
                opp.AccountId = Conlist[0].AccountId;
                opp.StageName = 'Prospecting';
                insert opp;
                system.debug('opp is inserted'+opp.Id);
            }
            //Creating the Task for an Opportunity
            if(email.plainTextBody.contains(ec.Task_Creation_Keypoint__c)){
                String oppID = email.plainTextBody.substringAfter('VIPA');
                oppID = oppID.substring(0,10);
                system.debug('oppID'+oppID);
                oppID = 'VIPA'+oppID;
                system.debug('oppID'+oppID);
                List<Opportunity> oppList = [Select id from opportunity where Opp_reference_Field__c = :oppID];
                if(oppList.Size() > 0){
                    Task tsk = new Task();
                    tsk.Subject = 'Negotiation Clarification';
                    tsk.Status = 'Open';
                    tsk.Priority = 'Normal';
                    tsk.ActivityDate = system.today(); 
                    tsk.WhatId = oppList[0].Id;
                    insert Tsk;
                    system.debug('Task is inserted'+Tsk.Id);
                }else{
                    Opportunity oppdata = [Select id from Opportunity where accountid =:Conlist[0].AccountId ][0];
                    
                    Task tsk = new Task();
                    tsk.Subject = 'Negotiation Clarification';
                    tsk.Status = 'Open';
                    tsk.Priority = 'Normal';
                    tsk.ActivityDate = system.today();
                    tsk.WhatId = oppdata.Id;
                    insert Tsk;
                    system.debug('Task is inserted'+Tsk.Id); 
                }
                
            }
        }else{
            //Creating the Lead if email is not in the system.
            system.debug('testing');
            Lead ld = new Lead();
            ld.Email = email.FromAddress;
            ld.FirstName =  '';
            ld.LastName = email.FromName;
            ld.company = email.subject;
            insert ld;
            
            system.debug(ld.Id);
        }
        return result; 
    }
}