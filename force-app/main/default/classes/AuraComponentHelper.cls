public class AuraComponentHelper {
    
    @AuraEnabled
    Public Static List<Branding_Asset_Line_Item__c> getEventDetails(String recordId){
        try{
            if(!String.isBlank(recordId)){
                Event_Schedular__c events = [SELECT Id,Name,Stadium__c FROM Event_Schedular__c WHERE ID=:recordId];  
                if(!String.isBlank(events.Stadium__c)){
                    List<Branding_Asset_Line_Item__c> getBrandList = [SELECT Id,Name,Branding_Asset_Master__r.Product__r.Name,Branding_Asset_Master__c,Stadium__r.Name,Stadium__c,Stadium__r.Sport_Board__r.Name,Product_Available_Quantity__c FROM Branding_Asset_Line_Item__c WHERE Stadium__c =:events.Stadium__c LIMIT 15];
                    System.debug('getBrandList :::'+getBrandList);
                    if(!getBrandList.isEmpty()){
                        return getBrandList;
                    }
                }
            }
        }catch(Exception e){
            System.debug('Error Message ::'+e.getMessage() + ' && Error Line ::'+e.getLineNumber());
        }
        return null;
    }
    
    @AuraEnabled
    Public Static List<Bid_Branding_Asset__c> tagBAlIToEventMaster( List<String> BAITIds, String recordId,List<Integer> Qty ){ // List<Bid_Branding_Asset__c> SelectBBAsset
        
        //system.debug('SelectBBAsset ===> '+ SelectBBAsset);
        if(!BAITIds.isEmpty() && !String.isBlank(recordId)){
            System.debug('BAITIds ::'+BAITIds + ' && recordId :::'+recordId + ' && Qty :::'+Qty);
            Set<Id> BraAssMasterIdSet = new Set<Id>();
            List<Bid_Branding_Asset__c> BidAssetToInsertList = new List<Bid_Branding_Asset__c>();
            List<Branding_Asset_Line_Item__c> getBALITotag = [SELECT Id,Name,Branding_Asset_Master__c,Branding_Asset_Master__r.Product__r.Name,Product_Available_Quantity__c  FROM Branding_Asset_Line_Item__c WHERE ID IN:BAITIds LIMIT 10];
            System.debug('getBALITotag Records ===>'+getBALITotag);
            for(Branding_Asset_Line_Item__c bali : getBALITotag){
                System.debug('bali Product_Available_Quantity__c ===> '+bali.Product_Available_Quantity__c);
                BraAssMasterIdSet.add(bali.Branding_Asset_Master__c);
            }
            if(BraAssMasterIdSet.size() > 0){
                List<Branding_Asset_Master__c> BraAssetMasterList = [SELECT Id,Name,Product__r.Name FROM Branding_Asset_Master__c WHERE ID IN : BraAssMasterIdSet];
                for(Branding_Asset_Line_Item__c brdId : getBALITotag){
                    Bid_Branding_Asset__c brasset = new Bid_Branding_Asset__c();
                    brasset.Name = brdId.Branding_Asset_Master__r.Product__r.Name;
                    brasset.Event_Schedular__c = recordId;
                    System.debug(' brdId.id :::'+ brdId.id);
                    brasset.Branding_Asset_Line_Item__c = brdId.id;
                    for(Integer item : Qty){
                        System.debug('item ===> '+item);
                        brasset.Available_Quantity__c =item;
                        brasset.Total_Quantity__c = item; 
                    }
                    
                    brasset.Product__c = brdId.Branding_Asset_Master__r.Product__c;
                    BidAssetToInsertList.add(brasset);
                }
            }
            if(!BidAssetToInsertList.isEmpty()){
                insert BidAssetToInsertList;
            }
            System.debug('BidAssetToInsertList  Records :::'+BidAssetToInsertList);
            System.debug('Record Size :::'+BidAssetToInsertList.size());
            return BidAssetToInsertList;
        }
        return null;
    }
    
    @AuraEnabled
    Public Static List<Account> getAccountForBBA(){
        List<String> accIdString = new List<String>{'001N000002AUrUBIA1','001N000002AUrALIA1','001N000002AUrFaIAL','001N000002AUr4IIAT','001N000002AUr3AIAT'};
        List<Account> accList = [SELECT Id,Name,Industry,BillingCountry,Total_Revenue__c,Forecast_Revenue__c,OverDue_Amount__c,Participated_Events__c,UpComing_Event_Opportunity__c FROm Account WHERE ID IN: accIdString];
        System.debug('accList ::'+accList);
        if(!accList.isEmpty()){
            return accList;
        }
        return null;
    }
    
    @AuraEnabled
    public Static Bid_Branding_Asset__c getCurrentRecordDetails(String recordId){
        Bid_Branding_Asset__c getRecord = [SELECT Id,Name,Event_Schedular__c,Branding_Asset_Line_Item__c FROM Bid_Branding_Asset__c WHERE Id =:recordId LIMIT 1];
        System.debug('current Record ::'+getRecord);
        return getRecord;
    }
    
    @AuraEnabled
    public Static List<Opportunity> insertOpportunity(List<String> AccountIdList,String EveSchduleId,String BraAssLineItemId, String OppName,String BidBrandId){
        if(!String.isBlank(EveSchduleId) && !String.isBlank(BraAssLineItemId) && !String.isBlank(BidBrandId)){
            System.debug('AccountIdList ::'+AccountIdList);
            System.debug('EveSchduleId ::'+EveSchduleId);
            System.debug('BraAssLineItemId ::'+BraAssLineItemId);
            System.debug('OppName ::'+OppName);
            List<Opportunity> oppList = new List<Opportunity>();
            for(String accId : AccountIdList){
                Opportunity opp = new Opportunity();
                opp.AccountId = accId;
                opp.CloseDate = System.today();
                opp.Name = OppName;
                opp.StageName = 'Prospecting';
                opp.Event_Schedular__c = EveSchduleId;
                opp.Branding_Asset_Line_Item__c = BraAssLineItemId;
                opp.Bid_Branding_Asset__c = BidBrandId;
                oppList.add(opp);
            }
            insert oppList;
            System.debug('oppList :::'+oppList);
            return oppList;
        }
        return null;
        
    }
    
    @AuraEnabled
    public Static void updateQuantity(List<Id> BidBranAssetIdSet){
        List<Bid_Branding_Asset__c> getBBALIst = [SELECT Id,Name,Available_Quantity__c,Total_Quantity__c,Event_Schedular__c FROM Bid_Branding_Asset__c WHERE Id IN: BidBranAssetIdSet];
        update getBBALIst;
        
    }
    
    @AuraEnabled
    public Static void insertBidBrandingAssets(List<Bid_Branding_Asset__c> bidBrandingAssestsList, string eventSchedularId){
        system.debug('bidBrandingAssestsList--->'+bidBrandingAssestsList);
        system.debug('eventSchedularId--->'+eventSchedularId);
        /*
         * (Bid_Branding_Asset__c:{Selling_Asset_Cost__c=123.00, Selling_Target_Date__c=2023-04-27 00:00:00, Id=a61N0000000CwBAIA0, Actual_Asset_Cost__c=12.00, Name=BALI -0100})
         * */
        set<Id> lineItemIds = new Set<Id>();
        Map<Id, Branding_Asset_Line_Item__c> brandingAssestRecById = new Map<Id,Branding_Asset_Line_Item__c>();
        
        if(!bidBrandingAssestsList.isEmpty()){
            for(Bid_Branding_Asset__c bidBrandingRec: bidBrandingAssestsList){
                lineItemIds.add(bidBrandingRec.Id);
            }
            if(!lineItemIds.isEmpty()){
                brandingAssestRecById = new Map<Id,Branding_Asset_Line_Item__c>([Select Id,Branding_Asset_Master__r.Product__c,Branding_Asset_Master__r.Product__r.Name From Branding_Asset_Line_Item__c where Id in : lineItemIds]);
            }
            for(Bid_Branding_Asset__c bidBrandingRec: bidBrandingAssestsList){
                bidBrandingRec.Branding_Asset_Line_Item__c = bidBrandingRec.Id;
                bidBrandingRec.Event_Schedular__c = eventSchedularId;
                bidBrandingRec.Available_Quantity__c = bidBrandingRec.Total_Quantity__c;
                bidBrandingRec.Product__c = brandingAssestRecById.get(bidBrandingRec.Id).Branding_Asset_Master__r.Product__c;
                bidBrandingRec.Name = brandingAssestRecById.get(bidBrandingRec.Id).Branding_Asset_Master__r.Product__r.Name;
                bidBrandingRec.Id = null;
            }
            insert bidBrandingAssestsList;
        }        
    }
}