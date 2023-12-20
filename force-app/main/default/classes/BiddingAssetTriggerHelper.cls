public class BiddingAssetTriggerHelper {
    
    public static void quantiytmanagement(List<Bid_Branding_Asset__c> brandingassetlist){
        for(Bid_Branding_Asset__c bd : brandingassetlist){
            bd.Asset_Belongs_To__c = '001N000002AIIV4IAP';
            bd.logo__C = '<p><img src="https://sales-production--fsldemo.sandbox.file.force.com/servlet/rtaImage?eid=001N000002AIIV4&amp;feoid=00NN000000Jefl1&amp;refid=0EMN00000009szX" alt="rtaImage.jpg"></img></p>';
        }
    }
    
    public static void markOpportunityCLosedWon(List<Bid_Branding_Asset__c> brandingassetlist){
        List<Bid_Branding_Asset__c> bidBrandAsset = new List<Bid_Branding_Asset__c>();
        for(Bid_Branding_Asset__c bd : brandingassetlist){
            if(bd.Available_Quantity__c == 0){
                bidBrandAsset.add(bd);
            }
        }
        
        if(!bidBrandAsset.isEmpty()){
            AssetManagement.closeExistingAssetOpportunity(bidBrandAsset);
        }
    }
    public static void beforeUpdate(Map<Id, Bid_Branding_Asset__c> newMap, Map<Id, Bid_Branding_Asset__c> oldMap){
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        List<Task> taskREcList = new List<task>();
        CustomNotificationType notificationType = [SELECT Id, DeveloperName FROM CustomNotificationType WHERE DeveloperName='AssestReminder'];
        EmailTemplate emailRecord = [Select Id ,HTMLValue,Subject From EmailTemplate where Name = 'Notify Sales Person'];
        
        for(Bid_Branding_Asset__c bidBrandingAssetRec : newMap.values()){
            if(bidBrandingAssetRec.Sales_Person__c != oldMap.get(bidBrandingAssetRec.Id).Sales_Person__c && bidBrandingAssetRec.Sales_Person__c != null){
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                String[] toAddresses = new String[] {bidBrandingAssetRec.Sales_Person_Email__c};
                    email.setToAddresses(toAddresses);
                email.setSenderDisplayName('ITW');
                email.setSubject(emailRecord.Subject);
                string emailBody = emailRecord.HtmlValue;
                
                emailBody = emailBody.replace('{Salesperson.Name}', bidBrandingAssetRec.Sales_Person_Name__c);
                emailBody = emailbody.replace('{BrandingAsset.Name}', bidBrandingAssetRec.Name);
                
                email.setHtmlBody(emailBody);
                emails.add(email);
                
                if(notificationType != null){
                    Messaging.CustomNotification notification = new Messaging.CustomNotification();
                    notification.setTitle('New Bid Branding Asset Assigned');
                    notification.setBody('A New Bid Branding Asset has been Assigned to you. Please review it');
                    notification.setNotificationTypeId(notificationType.Id);
                    notification.setTargetId(bidBrandingAssetRec.Id);
                    notification.send(new Set<String> {bidBrandingAssetRec.Sales_Person__c});
                }
                Task taskRec = new Task();
                taskRec.WhatId = bidBrandingAssetRec.Id;
                taskRec.Subject = 'Please Review the Assigned Bid Branding Asset';
                taskRec.OwnerId = bidBrandingAssetRec.Sales_Person__c;
                taskREcList.add(taskRec);
            }
        }
        if(!emails.isEmpty())
            Messaging.SendEmailResult[] results = Messaging.sendEmail(emails);
        if(!taskREcList.isEmpty()){
            insert taskREcList;
        }
    }
    
    public static void createAssetTargetOnSalesUserAssignment(List<Bid_Branding_Asset__c> brandingassetlist,Map<Id,Bid_Branding_Asset__c> oldMap){
        List<Asset_Target__c> assetTargetListTobeInsert = new List<Asset_Target__c>();
        for(Bid_Branding_Asset__c bba : brandingassetlist){
            if(bba.Sales_Person__c != null && oldMap.get(bba.Id).Sales_Person__c != bba.Sales_Person__c){
                Asset_Target__c assetTarget = new Asset_Target__c();
                assetTarget.Asset__c = bba.Id;
                assetTarget.Asset_Sales_Owner__c = bba.Sales_Person__c;
                assetTarget.Target_Date__c = bba.Selling_Target_Date__c;
                assetTarget.Target_Value__c = bba.Selling_Asset_Cost__c;
                assetTargetListTobeInsert.add(assetTarget);
            }
        }
        
        if(!assetTargetListTobeInsert.isEmpty()){
            insert assetTargetListTobeInsert;
        }
    }
    
    public static void closeAvailableAssetTask(List<Bid_Branding_Asset__c> brandingassetlist){
        Set<Id> eventSchedularIdSet = new Set<Id>();
        for(Bid_Branding_Asset__c bba : brandingassetlist){
            eventSchedularIdSet.add(bba.Event_Schedular__c);
        }
        
        if(!eventSchedularIdSet.isEmpty()){
            List<Task> taskListTobeUpdate = [select id from task where whatId in: eventSchedularIdSet and subject ='Please tag available asset'];
            
            if(!taskListTobeUpdate.isEmpty()){
                for(Task ts: taskListTobeUpdate){
                    ts.status = 'Completed';
                }
                update taskListTobeUpdate;
            }
        }
    }
    
    public static void closeAssignSalesuserTask(List<Bid_Branding_Asset__c> brandingassetlist,Map<Id,Bid_Branding_Asset__c> oldBBAMap){
        Set<Id> bbaIdSet = new Set<Id>();
        for(Bid_Branding_Asset__c bba : brandingassetlist){
            if(bba.Sales_Person__c != null && bba.Sales_Person__c != oldBBAMap.get(bba.Id).Sales_Person__c){
                bbaIdSet.add(bba.Id);
            }
        }
        
        if(!bbaIdSet.isEmpty()){
            List<Task> taskListTobeUpdate = [select id from task where whatid in: bbaIdSet and subject = 'Assign Sales Person'];
            if(!taskListTobeUpdate.isEmpty()){
                for(Task ts : taskListTobeUpdate){
                    ts.status = 'Completed';
                }
                update taskListTobeUpdate;
            }
        }
    }
}