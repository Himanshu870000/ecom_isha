public class LeadTriggerHelper{
    
    static LeadTriggerHelper instanceHandler;
    public static LeadTriggerHelper getInstance(){
        if(instanceHandler==null)
            instanceHandler = new LeadTriggerHelper();
        return instanceHandler;
    }
    
    public void createVisitRecords(list<lead> leadList, map<id, lead> oldMap){
        list<Visit__c> visitListTobeCreate = new list<Visit__c>();
        system.debug('');
        set<Id> leadsIdToBeConverted = new Set<Id>();
        
        for ( lead ld : leadList ){
            system.debug('ld.Status::' + ld.Status);
            system.debug('oldMap.get(ld.Id).Status::' + oldMap.get(ld.Id).Status);
            if ( oldMap.get(ld.Id).Status != ld.Status && ld.Status == 'Field Visit & Demo' ){
                Visit__c visitRec = new Visit__c();
                visitRec.Lead__c = ld.Id;
                visitRec.Planned_visit_date__c = ld.Site_Visit_Date__c;
                visitrec.Assigned_User__c = ld.OwnerId;
                visitRec.City__c = ld.City;
                visitRec.Country__c = ld.Country;
                visitrec.State__c = ld.State;
                visitRec.Street__c = ld.Street;
                visitRec.Postal_Code__c = ld.PostalCode;
                visitListTobeCreate.add(visitRec);                
            }
            if ( oldMap.get(ld.Id).Status != ld.Status && ld.Status == 'Converted' ){
                leadsIdToBeConverted.add(ld.Id);
            }
            
        }
        
        if ( !visitListTobeCreate.isEmpty() ){
            insert visitListTobeCreate;
        }
         if ( !leadsIdToBeConverted.isEmpty() ){
            LeadConversion.convertLeadToOrder(leadsIdToBeConverted);//insert visitListTobeCreate;
        }
    }
    
    public void CreateDocumentCategories(List<Lead> leadList){
        String document_cat = [select Category_Names__c from Document_Categories__c WHERE Name = 'Lead'].Category_Names__c;
        List<String> document_cat_list = document_cat.split(',');
        List<Document_Category__c> DocCatListToBeInserted = new List<Document_Category__c>();
        for(Lead ld : leadList){
            for(String doccat:document_cat_list){
                Document_Category__c doc_cat = new Document_Category__c();
                doc_cat.Name = doccat;
                doc_cat.Lead__C = ld.Id;
                DocCatListToBeInserted.add(doc_cat);
            } 
        }
        insert DocCatListToBeInserted;
    }
    
    public void assignMembers(list<lead> leadList, map<id, lead> oldMap){
        Map<Id,Lead> leadRecByIdForUnderReq = new Map<Id, Lead>();
        Map<Id,Lead> leadRecByIdForVisitSche = new Map<Id, Lead>(); 
        Map<Id,Lead> leadRecByIdForDemo = new Map<Id, Lead>();
        List<task> taskListToInsert = new List<Task>();
        List<Visit__c> visitList = new List<Visit__c>();
        Map<Id,Lead> processingTeamIdByLeadRecMap = new Map<Id,Lead>();
        
        for ( lead ld : leadList ){
            system.debug('ld.Status::' + ld.Status);
            system.debug('oldMap.get(ld.Id).Status::' + oldMap.get(ld.Id).Status);
            if ( oldMap.get(ld.Id).Status != ld.Status && ld.Status == 'Field Visit & Demo' ){
                ld.Visit_Team_Member__c = '0052v00000i0g0cAAA';
            }
            if ( oldMap.get(ld.Id).Status != ld.Status && ld.Status == 'Qualified' ){
                ld.Sales_Ops_Team_Member__c = '005N000000AyhmwIAB';
            }
            if(oldMap.get(ld.Id).Status != ld.Status && ld.Status == 'Under Requirement' ){
                leadRecByIdForUnderReq.put(ld.Id, ld);
            }
            if(oldMap.get(ld.Id).Next_Follow_up_Date__c != ld.Next_Follow_up_Date__c && ld.Next_Follow_up_Date__c != null ){
                // ld.Status = 'Under Requirement';
            }
            if(oldMap.get(ld.Id).Demo_Date__c != ld.Demo_Date__c && ld.Demo_Date__c != null ){
                //   ld.Status = 'Demo';
            }
            if(oldMap.get(ld.Id).Visit_Date__c != ld.Visit_Date__c && ld.Visit_Date__c != null ){
                ld.Status = 'Visit Scheduled';
            }
            if(oldMap.get(ld.Id).Status != ld.Status && ld.Status == 'Demo' ){
                leadRecByIdForDemo.put(ld.Id, ld);
            }
            if(oldMap.get(ld.Id).Status != ld.Status && ld.Status == 'Visit Scheduled' ){
                leadRecByIdForVisitSche.put(ld.Id, ld);
            }
            if(oldMap.get(ld.Id).Processing_Team_Member__c != ld.Processing_Team_Member__c && ld.Processing_Team_Member__c != null ){
                processingTeamIdByLeadRecMap.put(ld.Processing_Team_Member__c, ld);
            }
        }
        if(!processingTeamIdByLeadRecMap.isEmpty()){
            for(Id processingTeamId : processingTeamIdByLeadRecMap.keySet()){
                Task taskRec = new task();
                taskRec.WhoId = processingTeamIdByLeadRecMap.get(processingTeamId).Id;
                taskRec.Subject = 'Arrange a Demo with the Candidate!!!';
                taskRec.OwnerId = processingTeamId;
                taskRec.ActivityDate = system.today().addDays(2);
                //taskListToInsert.add(taskRec);
            }
            List<Messaging.SingleEmailMessage> mails =  new List<Messaging.SingleEmailMessage>();  
            EmailTemplate emailTemplateRec = [Select id, Name, DeveloperName, Subject, Body, HtmlValue from EmailTemplate where Name = 'Graphy Product Team'];
            
            for(Lead leadrec : processingTeamIdByLeadRecMap.values()){
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                List<String> recipients = new List<String>();
                
                recipients.add('ajeet.kumar@utilitarianlab.com');
                //system.debug('recipients------'+recipients);
                mail.setToAddresses(recipients);
                mail.setSenderDisplayName('Graphy');
                
                String htmlBody = emailTemplateRec.Body;
                
                if( leadrec.Name != null ){
                    system.debug('lead.Name::'+lead.Name);
                    htmlBody = htmlBody.replace('{!Lead.Processing_Team_Member__c}', leadrec.Processing_Team_Mem_Name__c);
                    htmlBody = htmlBody.replace('{!Lead.Name}', leadrec.FirstName);
                    htmlBody = htmlBody.replace('{!Lead.Company}', leadrec.Company);
                    htmlBody = htmlBody.replace('{!Lead.Email}', leadrec.Email);
                    htmlBody = htmlBody.replace('{!Lead.Phone}', leadrec.Phone);
                }
                //system.debug('htmlBody==>'+htmlBody);
                mail.setSubject(emailTemplateRec.Subject);
                mail.setPlainTextBody(htmlBody);
                mails.add(mail);
                
            }
            if(!mails.isEmpty()){
                Messaging.sendEmail(mails);  
            } 
            if(!taskListToInsert.isEmpty()){
                insert taskListToInsert;
            }
        }
        if(!leadRecByIdForDemo.isEmpty()){
            for(Id leadId : leadRecByIdForDemo.keySet()){
                Task taskRec = new task();
                taskRec.WhoId = leadId;
                taskRec.Subject = 'Arrange a Demo with the Candidate!!!';
                taskRec.OwnerId = leadRecByIdForDemo.get(leadId).OwnerId;
                //taskListToInsert.add(taskRec);
            }
            if(!taskListToInsert.isEmpty()){
                insert taskListToInsert;
            }
        }
        if(!leadRecByIdForUnderReq.isEmpty()){
            for(Id leadId : leadRecByIdForUnderReq.keySet()){
                Task taskRec = new task();
                taskRec.WhoId = leadId;
                taskRec.Subject = 'Gather Requirement for Sports Teacher';
                taskRec.OwnerId = leadRecByIdForUnderReq.get(leadId).OwnerId;
                taskListToInsert.add(taskRec);
            }
            if(!taskListToInsert.isEmpty()){
                insert taskListToInsert;
            }
        }
        if(!leadRecByIdForVisitSche.isEmpty()){
            for(Id leadId : leadRecByIdForVisitSche.keySet()){
                Task taskRec = new task();
                taskRec.WhoId = leadId;
                taskRec.Subject = 'Plan a Visit to the Organisation';
                taskRec.OwnerId = leadRecByIdForVisitSche.get(leadId).OwnerId;
                taskListToInsert.add(taskRec);
                
                Visit__c visit = new Visit__c();
                visit.Lead__c = leadId;
                visit.Actual_visit_date__c = leadRecByIdForVisitSche.get(leadId).Visit_Date__c;
                visit.Assigned_User__c = userinfo.getUserId();
                visit.Planned_visit_date__c = leadRecByIdForVisitSche.get(leadId).Visit_Date__c;
                
                visitList.add(visit);
            }
            if(!taskListToInsert.isEmpty()){
                insert taskListToInsert;
            }
            if(!visitList.isEmpty()){
                insert visitList;
            }
        }
    }
    
    public void addValidation(map<id, lead> newMap, map<id, lead> oldMap){
        for ( Lead ld : newMap.values() ){
            if(ld.LMS_access__c != oldMap.get(ld.Id).LMS_access__c && ld.LMS_access__c == true && string.isBlank(ld.Current_LMS_Description__c)){
                // ld.Current_LMS_Description__c.addError('Please Provide Description for LMS used');
            }
            if(ld.Existing_Website__c != oldMap.get(ld.Id).Existing_Website__c && ld.Existing_Website__c == true && string.isBlank(ld.Website__c)){
                // ld.Website__c.addError('Please Provide Website');
            }
            if(ld.Founding_Year__c != null && ld.Type_of_Institution__c != null && ld.Current_Monthly_Subscription__c != null && ld.Monthly_Revenue__c != null){
                // ld.Status = 'Details Captured';
            }
            if(ld.Class__c != null && ld.Annual_Fee_Range__c != null && ld.Preferred_Age_Bracket__c != null && ld.Board__c != null){
                // ld.Status = 'Under Requirement';
            }
            if(ld.Status != oldMap.get(ld.Id).Status && ld.Status == 'Converted'){
                if(ld.Class__c == null)
                    //  ld.Class__c.addError('Please fill class details');
                    if(ld.Annual_Fee_Range__c == null)
                    //    ld.Annual_Fee_Range__c.addError('Please fill Annual Fee details');
                    if(ld.Preferred_Age_Bracket__c == null)
                    //   ld.Preferred_Age_Bracket__c.addError('Please fill Age Bracket details');
                    if(ld.Board__c == null){
                        
                    }
                //  ld.Board__c.addError('Please fill Board details');
            }
        }
    }
    
    public void createVisitLineItems(list<unit__c> unitsList, String leadId){
        
        List<visit__c> visitList = new list<visit__c>();
        list<Visit_Item__c> visitItemListTobeInsert = new list<Visit_Item__c>();
        
        visitList = [select id, Lead__c
                     from visit__c
                     where Lead__c = :leadId
                     limit 1];
        
        for ( visit__c vst : visitList ){
            for ( unit__c un : unitsList ){
                Visit_Item__c vstItem = new Visit_Item__c();
                vstItem.Visit_Type__c = un.Unit_Type__c;
                vstItem.Visit__c = vst.Id;
                vstItem.Unit__c = un.Id;
                vst.Project__c = un.slab__r.project__r.Id;
                visitItemListTobeInsert.add(vstItem);
            }
        }
        update visitList;
        if ( !visitItemListTobeInsert.isEmpty() ){
            insert visitItemListTobeInsert;
        }
    }
    
    public void Questiontagged(map<id, lead> newMap, map<id, lead> oldMap){
        
        try{
            set<Id> ProductQuestionareIds = new Set<Id>();
            List<Question_Line_Item__c> QLITagged = new List<Question_Line_Item__c>();
            Map<String, String> LeadWithProductQuestionnare = new Map<String, string>();
            List<Lead_Questionnaire__c> QLIListToBeInserted = new List<Lead_Questionnaire__c>();
            
            
            If ( !newMap.isEmpty() ){
                for ( Lead ld : newMap.values() ){
                    if ( ld.Product_Questionnaire__c != null && ld.Product_Questionnaire__c != oldmap.get(ld.id).Product_Questionnaire__c ){
                        ProductQuestionareIds.add(ld.Product_Questionnaire__c);
                        LeadWithProductQuestionnare.put(ld.Product_Questionnaire__c, Ld.Id);
                    }
                }
                System.debug('ProductQuestionareIds ======> ' + ProductQuestionareIds);
                System.debug('LeadWithProductQuestionnare ====> ' + LeadWithProductQuestionnare);
                if ( !ProductQuestionareIds.isEmpty() ){
                    QLITagged = [Select id, Name, Question__c, Question_Template__c
                                 From Question_Line_Item__c
                                 Where Question_Template__c IN:ProductQuestionareIds];
                }
                System.debug('QLITagged ======> ' + QLITagged);
                if ( !QLITagged.isEmpty() ){
                    for ( Question_Line_Item__c QLI : QLITagged ){
                        if ( LeadWithProductQuestionnare.containsKey(QLI.Question_Template__c) ){
                            Lead_Questionnaire__c LQ = new Lead_Questionnaire__c();
                            LQ.Lead__c = LeadWithProductQuestionnare.get(QLI.Question_Template__c);
                            LQ.QLI_Question__c = QLI.Question__c;
                            LQ.Question_Line_Item__c = QLI.Id;
                            QLIListToBeInserted.add(LQ);
                        }
                    }
                }
                System.debug('QLIListToBeInserted ======> ' + QLIListToBeInserted);
                if ( !QLIListToBeInserted.isEmpty() ){
                    insert QLIListToBeInserted;
                }
            }
            
        }
        catch(Exception e) {
            System.debug('The Error Has occured due to ======> ' + e.getMessage() + ' at line number ======> ' + e.getLineNumber());
            
        }
    }
    
    public void handleBeforeInsert(List<Lead> leadList){
        //List<User> usersList = [select Id,Username from User where isActive = true ANd ( Username Like '%utilitarianlab%' or Username Like '%gmail%' )];
        for(Lead ld : leadList){
            
            // ld.Processing_Team_Member__c = '005N000000AkhoZIAR';
            //ld.Status = 'New';
            //ld.Lead_Stage__c = 'New';
            
            /*if(!usersList.isEmpty())
ld.Sales_Team_Member__c = usersList[0].Id;
if(usersList.Size()>0)
ld.Visit_Team_Member__c = usersList[1].Id;
if(usersList.Size()>2)
ld.Sales_Ops_Team_Member__c = usersList[3].Id;
if(usersList.Size()>3)
ld.Processing_Team_Member__c = usersList[4].Id;
if(usersList.Size()>4)
ld.Visa_Processing_Team_Member__c = usersList[5].Id;*/
        }
    }
    
    public void createVisaInquiryRecord(List<Lead> newLeadList){
        List<Visa_Inquiry__c> visaInqListTobeInsert = new List<Visa_Inquiry__c>();
        for(Lead ld : newLeadList){
            Visa_Inquiry__c visaInq = new Visa_Inquiry__c();
            visaInq.Stage__c = 'New';
            visaInq.Name = ld.Visa_Type__c;
            visaInq.Visa_Type__c = ld.Visa_Type__c;
            visaInq.Visa_Purpose__c = ld.Visa_Purpose__c;
            visaInq.Sales_Team_Member__c = ld.Sales_Team_Member__c;
            visaInq.Lead__c = ld.Id;
            visaInqListTobeInsert.add(visaInq);
        }
        
        if(!visaInqListTobeInsert.isEmpty()){
            insert visaInqListTobeInsert;
        }
    }
    
    public void createFolders(Map<Id,Lead> leadMap){
        System.debug('RUN--'+leadMap);
        Explorer_Configuration__c  leDocConfig = Explorer_Configuration__c.getValues('Lead');
        String accFoldersString = leDocConfig.Folders__c;
        
        List<String> leadFolders = accFoldersString.split(';');
        System.debug('Folder Selected---'+leadFolders);
        
        List<Folder__c> folders = new List<Folder__c>();
        
        for(Lead le : leadMap.values()){
            for(String fName : leadFolders){
                Folder__c folder = new Folder__c(Name=fName,Lead__c = le.Id);
                folders.add(folder);
            }
        }
        
        if(!folders.isEmpty()){
            insert folders;   
        }
    }
    
    public void creatingTaskForLead(map<id, lead> newMap, map<id, lead> oldMap){
        system.debug('creatingTaskForLead-->');
        List<Task> tskList = new List<Task>();
        List<Lead> leadList = new List<Lead>();
        for(Lead ldRec : newMap.values()){
            if(ldRec.Demo_Date__c != oldMap.get(ldRec.id).Demo_Date__c && ldRec.Demo_Date__c != null){
                system.debug('inside task creation');
                Task tk = new Task();
                tk.Subject = 'Demo Scheduled With '+ldRec.FirstName+' '+ldRec.LastName;
                tk.Priority = 'High';
                //tk.Status = 'In Progress';
                tk.WhoId =  ldRec.Id;
                tskList.add(tk);   
                leadList.add(ldRec);
            }
            if(ldRec.Next_Follow_up_Date__c != oldMap.get(ldRec.id).Next_Follow_up_Date__c && ldRec.Next_Follow_up_Date__c != null){
                system.debug('inside task creation');
                Task tk = new Task();
                tk.Subject = 'Take Followup from Mentor';
                tk.Priority = 'High';
                //tk.Status = 'In Progress';
                tk.WhoId =  ldRec.Id;
                tskList.add(tk);   
            }
            
            if(ldRec.Demo_Date_Time__c != oldMap.get(ldRec.id).Demo_Date_Time__c && ldRec.Demo_Date_Time__c != null){
                system.debug('inside task creation');
                Task tk = new Task();
                tk.Subject = 'Demo Scheduled With '+ldRec.FirstName+' '+ldRec.LastName;
                tk.Priority = 'High';
                //tk.Status = 'In Progress';
                tk.WhoId =  ldRec.Id;
                tskList.add(tk);   
            }
        }
        system.debug('tskList--->'+tskList);
        if(!tskList.isEmpty()){
            insert tskList;
            system.debug('tskList--->'+tskList);
        }
        
        
        List<Messaging.SingleEmailMessage> mails =  new List<Messaging.SingleEmailMessage>();  
        EmailTemplate emailTemplateRec = [Select id, Name, DeveloperName, Subject, Body, HtmlValue from EmailTemplate where Name = 'Graphy Product Team'];
        if(!leadList.isEmpty()){
            for(Lead leadrec : leadList){
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                List<String> recipients = new List<String>();
                
                recipients.add('ajeet.kumar@utilitarianlab.com');
                mail.setToAddresses(recipients);
                mail.setSenderDisplayName('Graphy');
                
                String htmlBody = emailTemplateRec.HtmlValue;
                
                if( leadrec.Company != null ){
                    system.debug('lead.Name::'+lead.Name);
                    htmlBody = htmlBody.replace('{!Lead.Processing_Team_Member__c}', 'Aakash Jain');
                    if(leadrec.LastName != null)
                        htmlBody = htmlBody.replace('{!Lead.Name}', leadrec.LastName);
                    else
                        htmlBody = htmlBody.replace('{!Lead.Name}', '');
                    htmlBody = htmlBody.replace('{!Lead.Company}', leadrec.Company);
                    if(leadrec.Email != null)
                        htmlBody = htmlBody.replace('{!Lead.Email}', leadrec.Email);
                    else
                        htmlBody = htmlBody.replace('{!Lead.Email}', 'aakash@mailinator.com');
                    if(leadrec.Phone != null)
                        htmlBody = htmlBody.replace('{!Lead.Phone}', leadrec.Phone);
                    else
                        htmlBody = htmlBody.replace('{!Lead.Phone}', '7042458620');
                    htmlBody = htmlBody.replace('{!Lead.Demo_Date__c}', string.valueOf(leadrec.Demo_Date__c));
                    
                }
                //system.debug('htmlBody==>'+htmlBody);
                mail.setSubject(emailTemplateRec.Subject);
                mail.setHtmlBody(htmlBody);
                mails.add(mail);
                
            }
            if(!mails.isEmpty()){
                Messaging.sendEmail(mails);  
            } 
            EmailTemplate emailTemplateRecToCandidate = [Select id, Name, DeveloperName, Subject, Body, HtmlValue from EmailTemplate where Name = 'Graphy Demo Email To Candidate'];
            
            for(Lead leadrec : leadList){
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                List<String> recipients = new List<String>();
                
                recipients.add('aakash.jain@utilitarianlab.com');
                mail.setToAddresses(recipients);
                mail.setSenderDisplayName('Graphy');
                
                String htmlBody = emailTemplateRecToCandidate.HtmlValue;
                
                if( leadrec.Company != null ){
                    if(leadrec.LastName != null)
                        htmlBody = htmlBody.replace('{!Lead.LastName}', leadrec.LastName);
                    else
                        htmlBody = htmlBody.replace('{!Lead.LastName}', '');
                    
                    htmlBody = htmlBody.replace('{!Lead.Demo_Date__c}', string.valueOf(leadrec.Demo_Date__c));
                    
                }
                //system.debug('htmlBody==>'+htmlBody);
                mail.setSubject(emailTemplateRecToCandidate.Subject);
                mail.setHtmlBody(htmlBody);
                mails.add(mail);
                
            }
            if(!mails.isEmpty()){
                Messaging.sendEmail(mails);  
            } 
        }
    }
    public void createTask(List<Lead> newLeadList){
        List<Task> tskList = new List<Task>();
        for(Lead ldRec : newLeadList){
            if(ldRec.Demo_Date_Time__c != null){
                system.debug('inside task creation');
                Task tk = new Task();
                tk.Subject = 'Demo Scheduled With '+ldRec.FirstName+' '+ldRec.LastName;
                tk.Priority = 'High';
                //tk.Status = 'In Progress';
                tk.WhoId =  ldRec.Id;
                tskList.add(tk);   
            }
        }
    }
    public void sendemailAttachonstatusupdate(List<lead> LeadList){
        try{ 
            List<wrapperForEmailAndAttach> emailRecWrapList = new List<wrapperForEmailAndAttach>(); 
            set<Id> industryDemoIdList = new set<Id>(); 
            
            List<Industry_Demo__c> listOfIndustry = [Select id,Name,Email_Template_Name__c from Industry_Demo__c];
            
            for(Industry_Demo__c industryRec : listOfIndustry){
                industryDemoIdList.add(industryRec.Id);
            }
            System.debug('industryDemoIdList----------------'+industryDemoIdList);
            List<EmailTemplate> templateList =  [select Name,Id,Subject,Body,HtmlValue from EmailTemplate];
            Map<String,EmailTemplate> emailTempMap = new Map<String,EmailTemplate>();
            for(EmailTemplate email:templateList){
                emailTempMap.put(email.Name,email);
            }
            
            List<Attachment> attachmentList = [SELECT Id,Name,Body,ContentType FROM Attachment Where ParentId In: industryDemoIdList];
            Map<String,Attachment> attachmentMap = new Map<String,Attachment>();
            
            for(Attachment attach : attachmentList){
                attachmentMap.put(attach.Name, attach);
            }
            System.debug('attachmentMap--------------'+attachmentMap);
            for(Lead ldRec : LeadList){
                if(ldRec.Status == 'Contacted' ){
                    emailRecWrapList.add(new wrapperForEmailAndAttach(ldRec,emailTempMap.get(ldRec.Industry),attachmentMap.get(ldRec.Industry)));
                    
                }	
                if(!emailRecWrapList.isempty()){
                    addAttachmentToEmail.AddingAttachementsToEmail(emailRecWrapList); 
                }
            }
        }
        catch(exception ex){
            system.debug('Error==>'+ex.getMessage()+'Error@==>'+ex.getLineNumber());
        }
    }
    public void creatingActionPlanForLead(Map<Id, Lead> newLeadMap){
        List<Action_Plan__c> actionPlanList = new List<Action_Plan__c>();
        set<ID> leadIds = new Set<Id>();
        
        try{
            for(Lead ldRec : newLeadMap.values()){
                Action_Plan__c actionPlanRec = new Action_Plan__c(Lead__c=ldRec.Id);
                actionPlanList.add(actionPlanRec);
                leadIds.add(ldRec.Id);
            }
            if(!actionPlanList.isEmpty()){
                insert actionPlanList;
            }
            if(!leadIds.isEmpty()){
                SendEmailNotification.sendFollowUpNotification('AutoResponseLead', leadIds);
            }
        }
        catch(exception ex){
            system.debug('Error==>'+ex.getMessage()+'Error@==>'+ex.getLineNumber());
        }
    }
    public void notifyLead(Map<Id, Lead> newLeadMap, Map<Id, Lead> oldLeadMap){
        set<Id> discoveryLeadId = new Set<Id>();
        set<Id> followUpLeadId = new Set<Id>();
        set<Id> demoLeadId = new Set<Id>();
        List<Task> taskList = new List<Task>();
        Map<Id,Lead> processingTeamIdByLeadRecMap = new Map<Id,Lead>();
        List<Task> taskListToInsert = new List<Task>();
        
        
        try{
            for(Lead lead : newLeadMap.Values()){
                system.debug('lead.Status'+lead.Status);
                if(lead.Demo_Date__c != null && oldLeadMap.get(lead.Id).Demo_Date__c == null){
                    //Give Demo to Customer
                    Task task = new Task();
                    task.ActivityDate = lead.Demo_Date__c.addDays(2);
                    task.WhoId = lead.Id;
                    task.Priority = 'Normal';
                    task.Subject = 'Give Demo to Customer';
                    task.Status = 'Not Started';
                    //taskList.add(task);
                    //discoveryLeadId.add(lead.Id);
                }
                if(lead.Discovery_Demo_Date__c != null && oldLeadMap.get(lead.Id).Discovery_Demo_Date__c == null){
                    //Take Discovery Call with Customer
                    Task task = new Task();
                    task.ActivityDate = lead.Discovery_Demo_Date__c.addDays(2);
                    task.WhoId = lead.Id;
                    task.Priority = 'Normal';
                    task.Subject = 'Take Discovery Call with Customer';
                    task.Status = 'Not Started';
                    taskList.add(task);
                    //followUpLeadId.add(lead.Id);
                }
                if(lead.Next_Follow_up_Date__c != null && oldLeadMap.get(lead.Id).Next_Follow_up_Date__c == null){
                    //Take Follow-Up Call with Customer
                    Task task = new Task();
                    task.ActivityDate = lead.Next_Follow_up_Date__c.addDays(2);
                    task.WhoId = lead.Id;
                    task.Priority = 'Normal';
                    task.Subject = 'Take Follow-Up Call with Customer';
                    task.Status = 'Not Started';
                    //taskList.add(task);
                    //demoLeadId.add(lead.Id);
                }
                if(oldLeadMap.get(lead.Id).Processing_Team_Member__c != lead.Processing_Team_Member__c && lead.Processing_Team_Member__c != null ){
                    // processingTeamIdByLeadRecMap.put(lead.Processing_Team_Member__c, lead);
                }
            }
            if(!processingTeamIdByLeadRecMap.isEmpty()){
                for(Id processingTeamId : processingTeamIdByLeadRecMap.keySet()){
                    Task taskRec = new task();
                    taskRec.WhoId = processingTeamIdByLeadRecMap.get(processingTeamId).Id;
                    taskRec.Subject = 'Arrange a Demo with the Candidate!!!';
                    taskRec.OwnerId = processingTeamId;
                    taskRec.ActivityDate = system.today().addDays(2);
                    taskListToInsert.add(taskRec);
                }
                List<Messaging.SingleEmailMessage> mails =  new List<Messaging.SingleEmailMessage>();  
                EmailTemplate emailTemplateRec = [Select id, Name, DeveloperName, Subject, Body, HtmlValue from EmailTemplate where Name = 'Graphy Product Team'];
                
                for(Lead leadrec : processingTeamIdByLeadRecMap.values()){
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    List<String> recipients = new List<String>();
                    
                    recipients.add(leadrec.Processing_Team_Email__c);
                    //system.debug('recipients------'+recipients);
                    mail.setToAddresses(recipients);
                    mail.setSenderDisplayName('Graphy');
                    
                    String htmlBody = emailTemplateRec.Body;
                    
                    if( leadrec.Processing_Team_Mem_Name__c != null )
                        htmlBody = htmlBody.replace('{!Lead.Processing_Team_Member__c}', leadrec.Processing_Team_Mem_Name__c);
                    if( leadrec.LastName != null )
                        htmlBody = htmlBody.replace('{!Lead.Name}', leadrec.LastName);
                    if( leadrec.Company != null )
                        htmlBody = htmlBody.replace('{!Lead.Company}', leadrec.Company);
                    if( leadrec.Email != null )
                        htmlBody = htmlBody.replace('{!Lead.Email}', leadrec.Email);
                    if( leadrec.Phone != null )
                        htmlBody = htmlBody.replace('{!Lead.Phone}', leadrec.Phone);
                    //system.debug('htmlBody==>'+htmlBody);
                    mail.setSubject(emailTemplateRec.Subject);
                    mail.setPlainTextBody(htmlBody);
                    mails.add(mail);
                    
                }
                if(!mails.isEmpty()){
                    Messaging.sendEmail(mails);  
                } 
                if(!taskListToInsert.isEmpty()){
                    insert taskListToInsert;
                }
            }
            if(!taskList.isEmpty()){
                insert taskList;
            }
        }catch(exception ex){
            system.debug('Error==>'+ex.getMessage()+'Error@==>'+ex.getLineNumber());
        }
        /* if(!discoveryLeadId.isEmpty()){
//SendEmailNotification.sendDiscoveryNotification('Discovery Mail', discoveryLeadId);
}
if(!followUpLeadId.isEmpty()){Take Follow-Up Call with Customer
//SendEmailNotification.sendFollowUpNotification('Follow Up', followUpLeadId);
}
if(!demoLeadId.isEmpty()){Give Demo to Customer
//SendEmailNotification.sendDemoNotification('Demo Mail', demoLeadId);
}
*/     
    }
    
    public static void convertLeadAfterPayment(string leadId, Map<String, Object> paymentResponse){
        try{
            system.debug('leadId--->'+leadId);
            Map<String, string> priceBookIdByProductId = new Map<String, String>();
            if ( paymentResponse.get('captured') == true ){
                //covert lead
                LeadStatus convertStatus = [SELECT Id, MasterLabel
                                            FROM LeadStatus
                                            WHERE IsConverted = true
                                            LIMIT 1];
                Database.LeadConvert convert = new Database.LeadConvert(  );
                convert.setConvertedStatus(convertStatus.MasterLabel);
                //convert.setDoNotCreateOpportunity(True);
                convert.setLeadId(leadId);
                Database.LeadConvertResult convertedLead = Database.convertLead(convert);
                if ( convertedLead.isSuccess() ){
                    //invoice tag
                    //opp item tag
                    //opportunity to be updated
                    Lead convertedLeadRec = [Select Id
                                             From Lead
                                             Where Id = :convertedLead.getLeadId()];
                    Account covertedAccRec = [Select Id, (Select Id
                                                          From Opportunities)
                                              From Account
                                              where id = :convertedLead.getAccountId()];
                    Opportunity opportunityRec = new Opportunity();
                    opportunityRec.id = covertedAccRec.Opportunities[0].Id;
                    opportunityRec.StageName = 'Closed Won';
                    update opportunityRec;
                    //Opportunity opportunityRec = [Select Id From Opportunity where id =: ]
                    Invoice__c invoiceRecTaggedWithLead = [Select Id, Status__c
                                                           from Invoice__c
                                                           Where Lead__c = :convertedLeadRec.Id
                                                           order by createdDate Desc
                                                           limit 1];
                    
                    invoiceRecTaggedWithLead.Opportunity__c = covertedAccRec.Opportunities[0].Id;
                    invoiceRecTaggedWithLead.Status__c = 'Realized';
                    update invoiceRecTaggedWithLead;
                }
            }
            else{
                
                List<Invoice__c> invoiceList = [Select Id, Status__c, Opportunity__c
                                                From Invoice__c
                                                where Lead__c = :leadId
                                                order by CreatedDate DESC
                                                limit 1];
                invoiceList[0].Status__c = 'Not Realized';
                update invoiceList;
                
            }
        }
        catch ( exception ex ){
            system.debug('Error==>' + ex.getMessage());
            system.debug('Error==>@@' + ex.getLineNumber());
        }
    }
    
}