trigger DealTrigger on Deal__c (after insert,after update) {
    
    if(Trigger.isinsert && Trigger.isafter){
        Deal_Trigger_Helper.CreateDocumentCategories(Trigger.new);
    }
    if(Trigger.isupdate && Trigger.isafter){
        //Deal_Trigger_Helper.updateUnitTransfer(Trigger.new);    
    }
    
}