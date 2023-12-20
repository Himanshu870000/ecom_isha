public without sharing class OpportunityTriggerHelper {
    
    public static void assignDefautOppStage(List<Opportunity> oppList){
        for(Opportunity opp : oppList){
            opp.StageName = 'New';
        }
    }
    
    public static void changeStageToFinanceLegal(List<Opportunity> oppList,Map<Id,Opportunity> oldMapOpportunity){
        Map<Id, Opportunity> opportunityIdbyOpportunityRecMap  = new Map<Id,Opportunity>();
        Map<Id, Opportunity> oppIdbyOppRecForClosedWonMap  = new Map<Id,Opportunity>();
        List<Quote> newQuoteList = new List<Quote>();
        List<Task> taskListToInsert = new List<task>();
        List<WorkOrder> workOrderList = new List<WorkOrder>();
        List<Purchase_Order__c> poRecList = new List<Purchase_Order__c>();
        
        for(Opportunity opp : oppList){
            if((opp.Finance_Team__c != null && opp.Finance_Team__c != oldMapOpportunity.get(opp.Id).Finance_Team__c) || (opp.Legal_Team__c != null && opp.Legal_Team__c != oldMapOpportunity.get(opp.Id).Legal_Team__c)){
                opp.StageName = 'Under Finance  & Legal';
            }
            if(opp.StageName == 'Proposal Shared' && opp.StageName != oldMapOpportunity.get(opp.Id).StageName){
                opportunityIdbyOpportunityRecMap.put(opp.Id, opp);
            }
            system.debug('opp.StageName--->'+opp.StageName);
            if(opp.StageName == 'Closed Won' && opp.StageName != oldMapOpportunity.get(opp.Id).StageName){
                oppIdbyOppRecForClosedWonMap.put(opp.Id, opp);
            }
            if(opp.Amount != null && opp.Amount != oldMapOpportunity.get(opp.Id).Amount && opp.Amount < oldMapOpportunity.get(opp.Id).Amount  ){
                opp.StageName = 'Negotiation';
            }
        }
        system.debug('oppIdbyOppRecForClosedWonMap--->'+oppIdbyOppRecForClosedWonMap);
        if(!opportunityIdbyOpportunityRecMap.isEmpty()){
            for(Id oppId : opportunityIdbyOpportunityRecMap.keyset()){
                Quote newQuote = new Quote();
                newQuote.OpportunityId = oppId; // ID of the Opportunity associated with the quote
                newQuote.Pricebook2Id = '01s2v00000Mcv46'; // ID of the Pricebook2 associated with the quote
                newQuote.Name = opportunityIdbyOpportunityRecMap.get(oppId).Name+' - Quote'; // Name of the quote
                newQuote.ExpirationDate = Date.today().addDays(30); // Quote expiration date
                newQuoteList.add(newQuote);
            }
            if(!newQuoteList.isEmpty()){
                // insert newQuoteList;
            }
        }
        if(!oppIdbyOppRecForClosedWonMap.isEmpty()){
            for(Id oppId : oppIdbyOppRecForClosedWonMap.keyset()){
                Task taskRec = new task();
                taskRec.WhatId = oppId;
                taskRec.Subject = 'Proceed for LMS Access processes';
                taskRec.OwnerId = oppIdbyOppRecForClosedWonMap.get(oppId).OwnerId;
                taskListToInsert.add(taskRec);
                
                WorkOrder wo = new WorkOrder();
                wo.Description = 'Activate LMS';
                wo.Opportunity__c = oppId;
                wo.Status = 'New';
                wo.Subject = 'Activate LMS';                     
                workOrderList.add(wo);
                
                Purchase_Order__c poRec = new Purchase_Order__c();
                poRec.Payment_Amount__c = oppIdbyOppRecForClosedWonMap.get(oppId).Amount;
                poRec.Opportunity__c = oppId;
                poRec.Vendor__c = oppIdbyOppRecForClosedWonMap.get(oppId).AccountId;
                poRec.PO_Date__c = system.today();
                poRec.Order_Status__c = 'Open';
                poRec.Payment_Method__c = 'Online';
                poRec.Total_Amount__c = oppIdbyOppRecForClosedWonMap.get(oppId).Amount;
                poRecList.add(poRec);
                
            }
            if(!poRecList.isEmpty()){
                //insert poRecList;
            }
            if(!taskListToInsert.isEmpty()){
                insert taskListToInsert;
            }
            if(!workOrderList.isEmpty()){
                insert workOrderList;
            }
        }
    }
    
    public static void closeProposalSharedTaskOnStageChange(List<Opportunity> oppList,Map<Id,Opportunity> oldOppMap){
        Set<Id> oppIdSet = new Set<Id>();
        for(Opportunity opp : oppList){
            if(opp.StageName == 'Proposal Shared' && opp.StageName != oldOppMap.get(opp.Id).StageName){
                oppIdSet.add(opp.Id);
            }
        }
        
        List<Task> taskListTobeUpdate = [select id,Status from task where whatId in: oppIdSet and Subject ='Share Proposal Deck'];
        for(Task ts : taskListTobeUpdate){
            ts.Status = 'Completed';
        }
        update taskListTobeUpdate;
    }
    public static void closeClientRequirementTaskOnStageChange(List<Opportunity> oppList,Map<Id,Opportunity> oldOppMap){
        Set<Id> oppIdSet = new Set<Id>();
        for(Opportunity opp : oppList){
            if(opp.StageName == 'Under Client Requirement' && opp.StageName != oldOppMap.get(opp.Id).StageName){
                oppIdSet.add(opp.Id);
            }
        }
        
        List<Task> taskListTobeUpdate = [select id,Status from task where whatId in: oppIdSet and Subject ='Gether Client Requirements'];
        for(Task ts : taskListTobeUpdate){
            ts.Status = 'Completed';
        }
        update taskListTobeUpdate;
    }
    public static void closeFinalBrandDeckTaskOnStageChange(List<Opportunity> oppList,Map<Id,Opportunity> oldOppMap){
        Set<Id> oppIdSet = new Set<Id>();
        for(Opportunity opp : oppList){
            if(opp.StageName == 'Design Under Review' && opp.StageName != oldOppMap.get(opp.Id).StageName){
                oppIdSet.add(opp.Id);
            }
        }
        
        List<Task> taskListTobeUpdate = [select id,Status from task where whatId in: oppIdSet and Subject ='Finalised Brand Deck'];
        for(Task ts : taskListTobeUpdate){
            ts.Status = 'Completed';
        }
        update taskListTobeUpdate;
    }
    public static void closeFinanceLegalAssignmentTaskOnStageChange(List<Opportunity> oppList,Map<Id,Opportunity> oldOppMap){
        Set<Id> oppIdSet = new Set<Id>();
        for(Opportunity opp : oppList){
            if(opp.StageName == 'Under Finance  & Legal' && opp.StageName != oldOppMap.get(opp.Id).StageName){
                oppIdSet.add(opp.Id);
            }
        }
        
        List<Task> taskListTobeUpdate = [select id,Status from task where whatId in: oppIdSet and Subject ='Assign Legal & Finance Member'];
        for(Task ts : taskListTobeUpdate){
            ts.Status = 'Completed';
        }
        update taskListTobeUpdate;
    }
    
    public static void closeGenerateContractDocumentTaskOnStageChange(List<Opportunity> oppList,Map<Id,Opportunity> oldOppMap){
        Set<Id> oppIdSet = new Set<Id>();
        for(Opportunity opp : oppList){
            if(opp.StageName == 'Under Aggrement' && opp.StageName != oldOppMap.get(opp.Id).StageName){
                oppIdSet.add(opp.Id);
            }
        }	
        
        List<Task> taskListTobeUpdate = [select id,Status from task where whatId in: oppIdSet and Subject ='Generate Contract Document'];
        for(Task ts : taskListTobeUpdate){
            ts.Status = 'Completed';
        }
        update taskListTobeUpdate;
    }
    
    public static void calculateAchieveTargetOnClosedWon(List<Opportunity> oppList,Map<Id,Opportunity> oldOpportunityMap){
        Set<Id> oppIdSet = new Set<Id>();
        Map<Id,Decimal> mapofBBAIdByOppAmount 	= new Map<Id,Decimal>();
        Map<Id,Id> mapofBBAIdByOppId			= New Map<Id,Id>();
        for(Opportunity opp : oppList){
            if(opp.StageName == 'Closed Won' && opp.StageName != oldOpportunityMap.get(opp.Id).StageName){
                oppIdSet.add(opp.Id);
                if(mapofBBAIdByOppAmount.containskey(opp.Bid_Branding_Asset__c)){
                    Decimal tempSum = 0;
                    tempSum = mapofBBAIdByOppAmount.get(opp.Bid_Branding_Asset__c);
                    mapofBBAIdByOppAmount.put(opp.Bid_Branding_Asset__c, tempSum + opp.Amount);
                }else{
                    mapofBBAIdByOppAmount.put(opp.Bid_Branding_Asset__c,opp.Amount);
                }
            }
        }
        
        if(!mapofBBAIdByOppAmount.isEmpty() || mapofBBAIdByOppAmount != null){
            List<Asset_Target__c> BBABrandingList = [select id,Asset__c,Achieved_Target__c from Asset_Target__c where Asset__c in: mapofBBAIdByOppAmount.keySet()];
            
            if(BBABrandingList != null && !BBABrandingList.isEmpty()){
                for(Asset_Target__c AT : BBABrandingList){
                    if(mapofBBAIdByOppAmount.containsKey(AT.Asset__c)){
                        AT.Achieved_Target__c = mapofBBAIdByOppAmount.get(AT.Asset__c);
                    }
                }
                
                update BBABrandingList;
            }
        }
    }
    public static void updateInventoryItems(Map<Id,Opportunity> newMap, Map<Id,Opportunity> oldMap){
        system.debug('inside opportunity helper');
        set<Id> oppotunityIds = new Set<Id>();
        List<Opportunity> oppotunityList = new List<Opportunity>();
        List<Schema.Location> locationList = new List<Schema.Location>();
        Map<String, List<ProductItem>> productItemsByLocationName = new Map<String, List<ProductItem>>();
        List<ProductItem> itemListToBeUpdated = new List<ProductItem>();
        
        for(Opportunity opp : newMap.values()){
            if(opp.StageName != oldMap.get(opp.Id).StageName && opp.StageName == 'Closed Won'){
                oppotunityIds.add(opp.Id);
            }
        }
        system.debug('oppotunityIds::'+oppotunityIds);
        locationList = [SELECT Name,(SELECT Id,ProductItemNumber,ProductName,QuantityOnHand FROM ProductItems) FROM Location];
        system.debug('locationList::'+locationList);
        if(!locationList.isEmpty()){
            for(Schema.Location locationRec : locationList){
                productItemsByLocationName.put(locationRec.Name,locationRec.ProductItems);
            } 
        }
        system.debug('productItemsByLocationName::'+productItemsByLocationName);
        if(!oppotunityIds.isEmpty()){
            oppotunityList = [SELECT Account.State__c ,Amount,StageName,(SELECT Id,Discount,Name,Product2.name,OpportunityId,PricebookEntryId,Product2Id,ProductCode,Quantity FROM OpportunityLineItems) FROM Opportunity WHERE Id In : oppotunityIds];           
            system.debug('oppotunityList::'+oppotunityList);
            if(!oppotunityList.isEmpty()){
                for(Opportunity oppRec : oppotunityList){
                    system.debug('productItemsByLocationName.containsKey(oppRec.Account.State__c)::'+productItemsByLocationName.containsKey(oppRec.Account.State__c));
                    system.debug('productItemsByLocationName::'+productItemsByLocationName);
                    
                    if(productItemsByLocationName.containsKey(oppRec.Account.State__c)){
                        for(OpportunityLineItem lineItemRec : oppRec.OpportunityLineItems){
                            system.debug('lineItemRec::'+lineItemRec);
                            List<ProductItem> productItemList = productItemsByLocationName.get(oppRec.Account.State__c);
                            for( ProductItem product : productItemList){
                                system.debug('product::'+product);
                                system.debug('lineItemRec.Name::'+lineItemRec.Name);
                                if(lineItemRec.Product2.name == product.ProductName){
                                    ProductItem productItemToBeUpdated = new ProductItem();
                                    productItemToBeUpdated.Id = product.Id;
                                    productItemToBeUpdated.QuantityOnHand = product.QuantityOnHand - lineItemRec.Quantity;
                                    itemListToBeUpdated.add(productItemToBeUpdated);
                                }
                            }
                        }
                    }
                }
                system.debug('itemListToBeUpdated::'+itemListToBeUpdated);
                if(!itemListToBeUpdated.isEmpty()){
                    update itemListToBeUpdated;
                }
            }
        }
    }
    
    public static void tagInvoiceRecord(List<Opportunity> oppList){
        Set<Id> visaIdSet = new Set<Id>();
        Map<Id,Id> mapofVisaIdByOppId = new Map<Id,Id>();
        for(Opportunity opp : oppList){
            if(opp.Visa_Inquiry__c != null){
                visaIdSet.add(opp.Visa_Inquiry__c);
                mapofVisaIdByOppId.put(opp.Visa_Inquiry__c, opp.Id);
            }
            
        }
        
        if(!visaIdSet.isEmpty()){
            List<Invoice__c> invoiceList  = new List<Invoice__c>();
            invoiceList = [select id,Opportunity__c,Visa_Inquiry__c from Invoice__c where Visa_Inquiry__c in: visaIdSet];
            
            if(!invoiceList.isEmpty()){
                for(Invoice__c inc : invoiceList){
                    if(!mapofVisaIdByOppId.isEmpty() && mapofVisaIdByOppId.get(inc.Visa_Inquiry__c) != null){
                        inc.Opportunity__c = mapofVisaIdByOppId.get(inc.Visa_Inquiry__c);
                    }
                }
                update invoiceList;
            }
            
            
        }
    }
    
    public static void insertPricebook(List<Opportunity> oppList){
        for(Opportunity opp : oppList){
            opp.Pricebook2Id = '01s2v00000Mcv46';
        }
    }
    
    public static void closedWonOpportunity(List<Opportunity> oppList,Map<Id,Opportunity> oldMap){
        set<Id> oppIdSet = new Set<Id>();
        for(Opportunity opp : oppList){
            if(opp.stageName == 'Closed Won' && opp.stageName != oldMap.get(opp.Id).stageName){
                oppIdSet.add(opp.Id);
            }
            if(opp.Amount != null && opp.Amount != oldMap.get(opp.Id).Amount &&  opp.Amount < oldMap.get(opp.Id).Amount){
                Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();          
                req.setComments('Submitting approval request');        
                req.setObjectId(opp.Id);
                req.setProcessDefinitionNameOrId('DiscountApproval');
                req.setNextApproverIds(new List<Id> {opp.OwnerId});
                Approval.ProcessResult result = Approval.process(req);      
            }
        }
        
        if(!oppIdSet.isEmpty()){
            AssetManagement.handleAssetInventory(oppIdSet);
        }
    }
    
    @future(callout=true)
    public static void syncOppToVisitServer(Set<Id> oppIdSet,String type){
        List<Opportunity> oppList = [SELECT Id, Name, Account.Email__c,CloseDate,Account.ShippingStreet,Account.ShippingCity,Account.ShippingState,Account.ShippingCountry,Account.Geo_Location__Latitude__s,Account.Geo_Location__Longitude__s,StageName,Delivery_Agent__r.Email,Delivery_Agent__r.Phone,Franchise_Associated_To__r.Geo_Location__Latitude__s,Franchise_Associated_To__r.Geo_Location__Longitude__s from Opportunity where Id IN :oppIdSet AND Account.Geo_Location__Latitude__s!=null And Account.Geo_Location__Longitude__s!=null AND Franchise_Associated_To__c!=null AND Delivery_Agent__r.Email!=null];
        SyncOpportunityVisit.syncVisit(oppList,type);
    }
    
    public static void createTaskBasedOnOpportunityStageForITW(List<Opportunity> opportunityList,Map<Id,Opportunity> oldOppMap){
        List<Task> taskListTobeInsert = new List<Task>();
        if(oldOppMap == null){
            for(Opportunity opp : opportunityList){
                taskListTobeInsert.add(Utility.opportunityTaskCreationForITW('end Marketing brochure',opp.OwnerId,opp.Id));
                //taskListTobeInsert.add(Utility.opportunityTaskCreationForITW('Find Decision Maker',opp.OwnerId,opp.Id));
                //taskListTobeInsert.add(Utility.opportunityTaskCreationForITW('Reconfirm the requirement of Teachers',opp.OwnerId,opp.Id));
                //taskListTobeInsert.add(Utility.opportunityTaskCreationForITW('Send Marketing Brochure',opp.OwnerId,opp.Id));
            }
            
        }else if(!oldOppMap.isEmpty()){
            for(Opportunity opp : opportunityList){
                if(Opp.StageName == 'New' && Opp.StageName != oldOppMap.get(opp.Id).StageName){
                    taskListTobeInsert.add(Utility.opportunityTaskCreationForITW('Find Decision Maker',opp.OwnerId,opp.Id));
                }
                if(Opp.StageName == 'Prospect' && Opp.StageName != oldOppMap.get(opp.Id).StageName){
                    taskListTobeInsert.add(Utility.opportunityTaskCreationForITW('Share Proposal Deck',opp.OwnerId,opp.Id));
                }
                if(Opp.StageName == 'Proposal Accepted' && Opp.StageName != oldOppMap.get(opp.Id).StageName){
                    taskListTobeInsert.add(Utility.opportunityTaskCreationForITW('Gether Client Requirements',opp.OwnerId,opp.Id));
                }
                
                if(Opp.StageName == 'Under Design Team' && Opp.StageName != oldOppMap.get(opp.Id).StageName){
                    taskListTobeInsert.add(Utility.opportunityTaskCreationForITW('Finalised Brand Deck',opp.OwnerId,opp.Id));
                }
                
                if(opp.Sub_Stage__c == 'Design Approved' && Opp.Sub_Stage__c != oldOppMap.get(opp.Id).Sub_Stage__c){
                    taskListTobeInsert.add(Utility.opportunityTaskCreationForITW('Assign Legal & Finance Member',opp.OwnerId,opp.Id));
                }
                system.debug('Opp.StageName::'+Opp.StageName);
                if(Opp.StageName == 'Under Finance  & Legal' && Opp.StageName != oldOppMap.get(opp.Id).StageName){
                    system.debug('inside under finance');
                    taskListTobeInsert.add(Utility.opportunityTaskCreationForITW('Send CRF To the Client',opp.Finance_Team__c,opp.Id));
                    taskListTobeInsert.add(Utility.opportunityTaskCreationForITW('Generate Perfoma Invoice',opp.Verticle_Head__c,opp.Id));
                    taskListTobeInsert.add(Utility.opportunityTaskCreationForITW('Generate Perfoma Invoice',opp.Finance_Team__c,opp.Id));
                    taskListTobeInsert.add(Utility.opportunityTaskCreationForITW('Generate Contract Document',opp.Legal_Team__c,opp.Id));
                }
                
                if(Opp.StageName == 'Under Aggrement' && Opp.StageName != oldOppMap.get(opp.Id).StageName){
                    taskListTobeInsert.add(Utility.opportunityTaskCreationForITW('Send Contract for Docu Sign',opp.Legal_Team__c,opp.Id));
                }
                
                if(Opp.StageName == 'Closed Won' && Opp.StageName != oldOppMap.get(opp.Id).StageName){
                    //taskListTobeInsert.add(Utility.opportunityTaskCreationForITW('Task For Product Team',opp.Product_Team__c,opp.Id));
                }
                if(Opp.StageName == 'Closed Lost' && Opp.StageName != oldOppMap.get(opp.Id).StageName){
                    taskListTobeInsert.add(Utility.opportunityTaskCreationForITW('Future Plan For Client',opp.OwnerId,opp.Id));
                }
            }
        }
        
        if(!taskListTobeInsert.isEmpty()){
            insert taskListTobeInsert;
        }
    }
    public static void createFolders(Map<Id,opportunity> oppNewMap){
        System.debug('RUN--'+oppNewMap);
        Explorer_Configuration__c  leDocConfig = Explorer_Configuration__c.getValues('Opportunity');
        String accFoldersString = leDocConfig.Folders__c;
        
        List<String> leadFolders = accFoldersString.split(';');
        System.debug('Folder Selected---'+leadFolders);
        
        List<Folder__c> folders = new List<Folder__c>();
        
        for(Opportunity opp : oppNewMap.values()){
            for(String fName : leadFolders){
                Folder__c folder = new Folder__c(Name=fName,Opportunity__c	 = opp.Id);
                folders.add(folder);
            }
        }
        
        if(!folders.isEmpty()){
            insert folders;   
        }
    }
    
    public static void insertPitchDeckUpderOpportunity(Map<Id, Opportunity> newOpportunityMap){
        Map<string, string> opportunityIdBidBrandingIdmap = new Map<String, String>();
        
        for(Opportunity oppRec : newOpportunityMap.values()){
            if(oppRec.Bid_Branding_Asset__c != null){
                opportunityIdBidBrandingIdmap.put(oppRec.Id, oppRec.Bid_Branding_Asset__c);
            }
        }
        if(!opportunityIdBidBrandingIdmap.isEmpty()){          
            /* List<ContentDocumentLink> contentDocLinkList = [Select ]


Folder__c FolderRec=[Select Id,Name From Folder__c where Opportunity__C in : opportunityIdBidBrandingIdmap.keyset() and Name = 'Pitch Deck'];
system.debug('FolderRec--'+FolderRec.Id);
ContentVersion conVer = new ContentVersion();
conVer.ContentLocation = 'S'; 
conVer.PathOnClient = 'attachmentName'; 
conVer.Title = filename; 
conVer.VersionData = EncodingUtil.base64Decode(attachmentBody); 
conVer.isMajorVersion = false;
insert conVer;   

ContentDistribution cdl = new ContentDistribution();
cdl.ContentVersionId = conVer.Id;
cdl.Name = 'PublicShare';
cdl.RelatedRecordId = 'a5eN0000000FC7cIAG';//FolderRec.Id;
insert cdl;
system.debug('ContentDistribution----'+cdl);
Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id].ContentDocumentId;
ContentDocumentLink conDocLink = New ContentDocumentLink();
conDocLink.LinkedEntityId = 'a5eN0000000FC7cIAG';//FolderRec.Id; 
conDocLink.ContentDocumentId = conDoc; 
conDocLink.shareType = 'V';
insert conDocLink;*/
        }
    }
    
    Public static void sendEmailOnProposalReview(List<Opportunity> newOppList, Map<Id, Opportunity> oldOppMap){
        
        List<Id> oppIds = new List<Id>();
        
        for(Opportunity opp : newOppList){
            if(opp.StageName == 'Proposal review' && oldOppMap.get(opp.Id).StageName != opp.StageName){
                oppIds.add(opp.Id);
            }
            
        }
        
        List<Quote> qtList = [SELECT Id, OpportunityId FROM Quote WHERE OpportunityId IN: oppIds];        
        
        for(Opportunity opp : newOppList){
            if(opp.StageName == 'Proposal review' && oldOppMap.get(opp.Id).StageName != opp.StageName){
                generatePDF(opp.Id, qtList[0].Id);
            }
        }
        
    }
    
    @Future(callout=true)
    Public static void generatePDF(Id oppId, Id quoteId){
        EmailTemplate et = [Select id, Name, DeveloperName, Subject, Body, HtmlValue from EmailTemplate where Name='Proposal Deck'];
        Opportunity oppRec = [Select Id,AccountId From Opportunity where Id =: oppId];
        List<Contact> contactList = [Select Id,Name,Email from Contact where AccountId =:oppRec.AccountId and Email != null];
        
        String subject = et.Subject;
        String htmlBody = et.HtmlValue;
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        htmlBody = htmlBody.replace('{opportunity.id}',oppId);  
        List<String> recipients = new List<String>();
        for(Contact conRec : contactList){
            recipients.add(conRec.Email);
        }
        
        
        Messaging.SingleEmailMessage email=new Messaging.SingleEmailMessage();
        
        Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
        attachment.setContentType('application/pdf');
        attachment.setFileName('Quote PDF.pdf');
        String quoteUrl = '/quote/quoteTemplateDataViewer.apexp?';
        //Construct the quote URL to generate PDF
        quoteUrl += 'id=' + quoteId;
        quoteUrl += '&headerHeight=197&footerHeight=10';
        quoteUrl += '&summlid=0EHN0000001uVa5';
        
        //call the quote url
        PageReference pageRef = new PageReference(quoteUrl);
        
        //get the quotePdf
        Blob quoteBlob;
        
        quoteBlob = pageRef.getContentAsPDF();
        
        attachment.setBody(quoteBlob);
        
        email.setToAddresses(recipients);
        email.setSubject(subject);
        email.setHtmlBody(htmlBody);
        email.setFileAttachments(new Messaging.EmailFileAttachment[] {attachment});
        mails.add(email);
        Messaging.sendEmail(mails);
    }
    
    public static void createProjectOnClosedWon(List<Opportunity> opportunityList){
        List<Project__c> projectListTobeInsert = new List<Project__c>();
        List<Workorder> workOrderListTobeInsert = new List<Workorder>();
        List<Task> taskListToInsert = new List<Task>();
        List<Warranty__c> warrantyList = new List<Warranty__c>();
        
        for(Opportunity opp : opportunityList){
            if(opp.StageName == 'Closed Won'){
                
                Task taskRecToInsert = new Task();
                taskRecToInsert.WhatId = opp.Id;
                taskRecToInsert.Subject = 'Check the Invoicing part and Proceed for E-Way Bill - Finance/Account Team';
                taskRecToInsert.ActivityDate = system.today().addDays(1);
                
                taskListToInsert.add(taskRecToInsert);
                
                Task taskRecToInsertForLogistic = new Task();
                taskRecToInsertForLogistic.WhatId = opp.Id;
                taskRecToInsertForLogistic.Subject = 'Gather the E-Way Bill & Get started with Dispatch Process - Logistic Team';
                taskRecToInsertForLogistic.ActivityDate = system.today().addDays(1);
                
                taskListToInsert.add(taskRecToInsertForLogistic);
                
                Project__c proj = new Project__c();
                proj.Opportunity__c = opp.Id;
                //projectListTobeInsert.add(proj);
                
                Workorder wo  = new workorder();
                wo.Opportunity__c = opp.Id;
                wo.Subject = 'Installation Plan';
                workOrderListTobeInsert.add(wo);
                
                Warranty__c warrantyFromStanley = new Warranty__c();
                warrantyFromStanley.Opportunity__c = opp.Id;
                warrantyFromStanley.End_Date__c = system.today().addMonths(12);
                warrantyFromStanley.Start_Date__c = system.today();
                warrantyFromStanley.Warranty_Duration_in_Months__c = 12;
                warrantyFromStanley.Warranty_Type__c = 'Stanley';
                warrantyFromStanley.Terms_Conditions__c = 'Coverage: The brands warranty may offer additional coverage, such as protection against accidental damage, theft, or loss, depending on the terms and the type of product.Repair or Replacement: Similar to the manufacturers warranty, the brands warranty may cover repair or replacement of the product, but the process may be handled directly by the brand or retailer. Exclusions: The brands warranty may have its own set of exclusions, which can differ from those of the manufacturers warranty. Its essential to review these exclusions carefully. Voiding the Warranty: Just like with the manufacturers warranty, failing to follow care and maintenance instructions or damaging the product through misuse can void the brands warranty.';
                warrantyList.add(warrantyFromStanley);
                
                Warranty__c warrantyFromFactory = new Warranty__c();
                 warrantyFromFactory.Opportunity__c = opp.Id;
                warrantyFromFactory.End_Date__c = system.today().addMonths(12);
                warrantyFromFactory.Start_Date__c = system.today();
                warrantyFromFactory.Warranty_Duration_in_Months__c = 12;
                warrantyFromFactory.Warranty_Type__c = 'Factory';
                warrantyFromFactory.Terms_Conditions__c = 'Coverage: The manufacturers warranty generally covers defects in materials and workmanship. It ensures that the product will be free from such defects during the warranty period. Repair or Replacement: If a defect occurs within the warranty period, the manufacturer will typically offer to repair the product at no cost or replace it with a new or refurbished unit, depending on the terms. Exclusions: Manufacturer warranties often have specific exclusions. These may include damage caused by misuse, accidents, unauthorized repairs or modifications, or normal wear and tear. Voiding the Warranty: The warranty may become void if the customer fails to follow specific care and maintenance instructions or if the products serial number or identification label is tampered with or removed.';
                warrantyList.add(warrantyFromFactory);
            }
        }
        if(!taskListToInsert.isEmpty()){
            insert taskListToInsert;
        }
        if(!projectListTobeInsert.isEmpty()){
            //insert projectListTobeInsert;
        }
        if(!workOrderListTobeInsert.isEmpty()){
            insert workOrderListTobeInsert;
        }
        if(!warrantyList.isEmpty()){
            insert warrantyList;
        }
    }
    
    Public Static void SetWareHouseByDefault(List<Opportunity> OppList){ 
        for(Opportunity Opp:OppList){
            if(Opp.Clinic__c==null){
                Opp.Clinic__c='a7rN0000000DOu9IAG';
            }
        } 
    }
    
    Public static void createFolderforOpp(list<Opportunity> newOppList){
        
        //String folderName='Request for Proposal (RFP), Tender Documents,Technical Specifications,Environmental Impact Assessment (EIA) Reports,Site Information, Land Ownership Documentation,Government Approvals & Permits,Project Timeline and Milestones,Quality Certifications,Compliance Documents,Maintenance and Service Plans,Project Implementation Plan';
        String folderName = 'Request for Proposal (RFP), Tender Documents, Technical Specifications, Environmental Impact Assessment (EIA) Reports, Site Information, Land Ownership Documentation, Government Approvals & Permits, Project Timeline and Milestones, Quality Certifications, Compliance Documents, Maintenance and Service Plans, Project Implementation Plan';
        // Split the string into an array using commas as the delimiter
        List<String> folderNamesList = folderName.split(', ');
        List<Document_Category__c>  listTobeInserted = new  List<Document_Category__c> ();
        
        for(Opportunity createOppRec : newOppList){
            for (String folder : folderNamesList) {
                Document_Category__c  createfolder = new Document_Category__c();
                createfolder.Name=folder;
                system.debug(folder);
                createfolder.Opportunity__c=createOppRec.Id;
                listTobeInserted.add(createfolder);
            }
            
        }
        
         insert listTobeInserted;
           
        
        
    }
    
    
    
}