public without sharing class OpportunityLineItemTriggerHelper {
    
    public static void afterInsert(List<OpportunityLineItem> newOppProdList){
        Map<String, String> productIdByOPLIId = new Map<String, String>();
        List<Warranty__c> warrantyListtoUpdate = new List<Warranty__c>();
        
        for(OpportunityLineItem oppProd : newOppProdList){
            productIdByOPLIId.put(oppProd.Product2Id, oppProd.Id);
        }
        
        if(!productIdByOPLIId.isEmpty()){
            List<Warranty__c> warrantiesList = [Select Id,Product__c,Opportunity_Product__c,Terms_Conditions__c,Warranty_Duration_in_Months__c,Warranty_Type__c From Warranty__c where Product__c in:productIdByOPLIId.keyset()];
            if(!warrantiesList.isEmpty()){
                for(Warranty__c warrantyRec : warrantiesList){
                    Warranty__c warrantyRecToUpdate = new Warranty__c();
                    warrantyRecToUpdate.Opportunity_Product__c = productIdByOPLIId.get(warrantyRec.Product__c);
                    warrantyRecToUpdate.Product__c = warrantyRec.Product__c;
                    warrantyRecToUpdate.Terms_Conditions__c = warrantyRec.Terms_Conditions__c;
                    warrantyRecToUpdate.Warranty_Duration_in_Months__c = warrantyRec.Warranty_Duration_in_Months__c;
                    warrantyRecToUpdate.Warranty_Type__c  = warrantyRec.Warranty_Type__c;
                    warrantyListtoUpdate.add(warrantyRecToUpdate);
                }
                if(!warrantyListtoUpdate.isEmpty()){
                    insert warrantyListtoUpdate;
                }
            }
        }
    }
    
    
    /*public static void afterInsert(List<OpportunityLineItem> newOppProdList){
        List<Book__c> bookList = [SELECT Id, Name FROM Book__c];
        system.debug('bookList -- ' + bookList);
        Map<String, Book__c> bookByNameMap = new Map<String, Book__c>();
        
        for(Book__c bk : bookList){
            bookByNameMap.put(bk.Name, bk);
        }
        
        Set<Id> oppLineItemIdSet = new Set<Id>();
        for(OpportunityLineItem oppProd : newOppProdList){
            oppLineItemIdSet.add(oppProd.Id);
        }
        Map<Id, List<OpportunityLineItem>> getOppProdsListByOppId = new Map<Id, List<OpportunityLineItem>>();
        List<OpportunityLineItem> oppProdList = [SELECT Id, Email_Soft_Copy__c, Need_Hard_Copy__c, OpportunityId, Product2.Name, Opportunity.Account.Email__c FROM OpportunityLineItem WHERE Id IN: oppLineItemIdSet];
        Set<Id> bookIdSet = new Set<Id>();
        Boolean sendEmail = false;
        Boolean createTsk = false;
        
        for(OpportunityLineItem oppProd : oppProdList){
            system.debug('oppProd.Product2.Name -- ' + oppProd.Product2.Name);
            if(bookByNameMap.containsKey(oppProd.Product2.Name) && oppProd.Email_Soft_Copy__c && oppProd.Opportunity.Account.Email__c != null){
                bookIdSet.add(bookByNameMap.get(oppProd.Product2.Name).Id); 
                sendEmail = true;
            }
            if((oppProd.Email_Soft_Copy__c && oppProd.Opportunity.Account.Email__c != null) || oppProd.Need_Hard_Copy__c){
                if(getOppProdsListByOppId.containsKey(oppProd.OpportunityId)){
                    getOppProdsListByOppId.get(oppProd.OpportunityId).add(oppProd);
                }
                else{
                    getOppProdsListByOppId.put(oppProd.OpportunityId,new List<OpportunityLineItem>{oppProd});
                }
            }
            
            if(oppProd.Need_Hard_Copy__c){
                createTsk = true;
            }
        }
        
        if(!getOppProdsListByOppId.isEmpty()){
            Map<Id, Opportunity> getOppById = new Map<Id, Opportunity>([SELECT Id, OwnerId, Account.Name, Account.Email__c FROM Opportunity WHERE Id IN: getOppProdsListByOppId.keySet()]);
            
            Set<Id> docIdSet = new Set<Id>();
            List<String> recipients = new List<String>();
            List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
            List<Messaging.EmailFileAttachment> efaList = new List<Messaging.EmailFileAttachment>();
            
            if(!bookIdSet.isEmpty()){
                List<ContentDocumentLink> cdlList = [SELECT Id, ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId IN: bookIdSet];
                for(ContentDocumentLink cdl : cdlList){
                    docIdSet.add(cdl.ContentDocumentId);
                }
                
                List<ContentVersion> contentVerList = [SELECT Id, Title, VersionData, FileExtension FROM ContentVersion WHERE ContentDocumentId IN: docIdSet];        
                
                for(ContentVersion ver: contentVerList){
                    Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                    Blob fileData = ver.VersionData;
                    efa.setFilename(ver.Title + '.' + ver.FileExtension);
                    efa.setBody(fileData);
                    efaList.add(efa);
                }
            }
            
            List<Task> tskList = new List<Task>();
            for(Id oppId : getOppProdsListByOppId.keySet()){
                if(sendEmail && !efaList.isEmpty()){
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();                
                    recipients.add(getOppById.get(oppId).Account.Email__c);
                    system.debug('recipients------'+recipients);
                    mail.setToAddresses(recipients);
                    mail.setSenderDisplayName('Top Ranker');
                    String subject = 'Soft Copies';
                    String htmlBody = 'Dear ' + getOppById.get(oppId).Account.Name + ',';
                    htmlBody += ' <br> <br> As per your request, Soft Copies of the books has been sent to you.';
                    mail.setSubject(subject);
                    mail.setHtmlBody(htmlBody);
                    mail.setFileAttachments(efaList);
                    
                    mails.add(mail);
                    system.debug('mails-->'+mails.size());
                    if(!mails.isEmpty())
                        system.debug('mails-->'+mails.size());
                }
                
                if(createTsk){
                    
                    Task tsk = new Task();
                    tsk.OwnerId = '005N000000AkhoZIAR';
                    tsk.WhatId = oppId;
                    tsk.Subject = 'Sales Operation Team - Dispatch Books!';
                    tsk.ActivityDate = System.Today();
                    tskList.adD(tsk);
                }                    
            }
            
            Messaging.sendEmail(mails);
            insert tskList;
        }
    }
    */
    
    public static void createQCTask(List<OpportunityLineItem> oliList,Map<Id,OpportunityLineItem> oldMapOLI){
        List<Task> taskListTobeInsert = new List<Task>();
        for(OpportunityLineItem oli : oliList){
            if(oli.Status__c != null && oli.Status__c != oldMapOLI.get(oli.Id).Status__c && oli.Status__c == 'Received'){
                Task tsk = new Task();
                tsk.WhatId = oli.OpportunityId;
                tsk.Subject = 'QC : Quality check for '+ oli.Name;
                tsk.ActivityDate = system.today().addDays(5);
                taskListTobeInsert.add(tsk);
            }
        }
        
        if(!taskListTobeInsert.isEmpty()){
            insert taskListTobeInsert;
        }
    }
    
    
    public static void checkWarehouseInventory(List<OpportunityLineItem> oliList){
        Set<Id> oppIdSet = new Set<Id>();
        Map<Id,Decimal> ProdIdXQuantity=new Map<Id,Decimal>();
        
        for(OpportunityLineItem oli : oliList){
            oppIdSet.add(oli.OpportunityId);
        }
        
        if(!oppIdSet.isEmpty()){
            List<Opportunity> oppList = [select id,Clinic__c from opportunity where id in:oppIdSet];
            Set<Id> whareHouseIdSet = new Set<Id>();
            for(Opportunity opp : oppList){
                whareHouseIdSet.add(opp.Clinic__c);
            }
            
            if(!whareHouseIdSet.isEmpty()){
                List<Inventory__c> InventoryList=[Select Id,Product__c,Total_Inventory__c,Clinic__c,Remaining_Inventory__c From Inventory__c Where Clinic__c in:whareHouseIdSet]; 
                if(!InventoryList.isEmpty()){
                    for(Inventory__c Iv:InventoryList){
                        ProdIdXQuantity.put(Iv.Product__c,Iv.Remaining_Inventory__c); 
                    }
                }
            }
            
            for(OpportunityLineItem oli : oliList){
                if(oli.Product2Id!=null || String.isNotBlank(oli.Product2Id)){
                    if(ProdIdXQuantity.containsKey(oli.Product2Id)){
                        Decimal Quantity=ProdIdXQuantity.get(oli.Product2Id);
                        if(oli.Quantity!=null && oli.Quantity>Quantity){
                            oli.Need_To_Purchase__c=true;
                        }
                    }
                }
            }
        }
    }
}