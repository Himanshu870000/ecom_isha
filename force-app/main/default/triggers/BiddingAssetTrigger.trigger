trigger BiddingAssetTrigger on Bid_Branding_Asset__c (before insert,after update, before update,After insert) {
    
    if(trigger.isInsert && Trigger.isBefore){
        BiddingAssetTriggerHelper.quantiytmanagement(trigger.new);
    }
    if(trigger.isUpdate && Trigger.isafter){
        BiddingAssetTriggerHelper.markOpportunityCLosedWon(trigger.new);
        BidBrandingCustomNotification.afrertUpdae(trigger.newMAP);
        BiddingAssetTriggerHelper.createAssetTargetOnSalesUserAssignment(trigger.new,trigger.oldMap);
        BiddingAssetTriggerHelper.closeAssignSalesuserTask(trigger.new,trigger.oldMap);
    }
    if(trigger.isUpdate && Trigger.isBefore){
        BiddingAssetTriggerHelper.beforeUpdate(trigger.newMap, trigger.OldMap);
    }
    
    if(trigger.isInsert && Trigger.isAfter){
        BiddingAssetTriggerHelper.closeAvailableAssetTask(trigger.new);
    }
}