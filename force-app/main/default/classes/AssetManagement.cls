public class AssetManagement {
	
    public static void handleAssetInventory(Set<Id> opportunityIdList){
        List<OpportunityLineItem> oliList = [select id,product2Id,unitprice,quantity,opportunityId,opportunity.Event_Schedular__c from OpportunityLineItem where opportunityId in: opportunityIdList];
        
        map<Id,map<Id,decimal>> mapofProdIdByQuantity = new Map<Id,Map<Id,decimal>>();
        Set<Id> eventScheduleIdSet = new Set<Id>();
        for(OpportunityLineItem oli : oliList){
            eventScheduleIdSet.add(oli.opportunity.Event_Schedular__c);
            if(mapofProdIdByQuantity.containsKey(oli.opportunityId)){
                mapofProdIdByQuantity.get(oli.opportunityId).put(oli.product2Id,oli.quantity);
            }else{
                mapofProdIdByQuantity.put(oli.opportunityId,new map<Id,decimal>{oli.product2Id => oli.quantity});
            }
        }
        system.debug('eventScheduleIdSet::'+eventScheduleIdSet);
        List<Bid_Branding_Asset__c> bbaList = [select id,Available_Quantity__c,Product__c from Bid_Branding_Asset__c where Event_Schedular__c in: eventScheduleIdSet];
        
        for(Id mapKey : mapofProdIdByQuantity.keySet()){
            system.debug('mapKey::'+mapKey);
            system.debug('mapofProdIdByQuantity::'+mapofProdIdByQuantity.get(mapKey));
            //for(ID prodMap : mapofProdIdByQuantity.get(mapKey)){
                for(Bid_Branding_Asset__c bba : bbaList){
                    system.debug('mapofProdIdByQuantity.get(mapKey).containsKey(bba.Product__c)""'+mapofProdIdByQuantity.get(mapKey).containsKey(bba.Product__c));
                    system.debug('bba.Available_Quantity__c::'+bba.Available_Quantity__c);
                    if(mapofProdIdByQuantity.get(mapKey).containsKey(bba.Product__c) && bba.Available_Quantity__c != 0){
                        bba.Available_Quantity__c = Integer.valueOf(bba.Available_Quantity__c) - Integer.valueOf(mapofProdIdByQuantity.get(mapKey).get(bba.Product__c));
                    }
                }
            //}
        }
        system.debug('bbaList::'+bbaList);
        update bbaList;
        createFinalAsset(opportunityIdList);
        
    }
    
    public static void closeExistingAssetOpportunity(List<Bid_Branding_Asset__c> bidingAssetList){
        Set<Id> bbaIdSet = new Set<Id>();
        for(Bid_Branding_Asset__c bba : bidingAssetList){
            bbaIdSet.add(bba.Id);
        }
        
        list<Opportunity> opportunityList = [select id,stageName from opportunity where Bid_Branding_Asset__c in: bbaIdSet and stageName != 'Closed Won'];
        for(opportunity opp : opportunityList){
            opp.stageName = 'Closed Lost';
        }
        update opportunityList;
    }
    
    public static void createFinalAsset(Set<Id> opportunityIdList){
        List<OpportunityLineItem> oppLineItem = [select id,quantity,unitprice,product2Id,product2.name,opportunity.AccountId,opportunity.Event_Schedular__c from OpportunityLineItem  where opportunityId in: opportunityIdList];
        List<asset> assetListTobeInsert = new list<asset>();
        for(OpportunityLineItem opl : oppLineItem){
            asset assetObj = new asset();
            assetObj.Name = opl.product2.name;
            assetObj.AccountId = opl.opportunity.AccountId;
            assetObj.Event_Schedular__c = opl.opportunity.Event_Schedular__c;
            assetObj.Product2Id = opl.Product2Id;
            assetObj.Quantity = opl.quantity;
            assetObj.Price = opl.UnitPrice;
            assetObj.Status = 'Purchased';
            assetListTobeInsert.add(assetObj);
        }
        
        if(!assetListTobeInsert.isEmpty()){
           insert assetListTobeInsert; 
        }
    }
}