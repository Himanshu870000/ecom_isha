trigger TriggerOnOpportunityLineItem on OpportunityLineItem (after insert,after update,Before Insert) {
    //OpportunityLineItemTriggerHelper.afterInsert(Trigger.New);
    //
    if(trigger.isInsert && trigger.isAfter){
        OpportunityLineItemTriggerHelper.afterInsert(trigger.new);
    }
    if(trigger.isUpdate && trigger.isAfter){
        OpportunityLineItemTriggerHelper.createQCTask(trigger.new,trigger.oldMap);
    }
    if(Trigger.isInsert && Trigger.isBefore){
        OpportunityLineItemTriggerHelper.checkWarehouseInventory(trigger.new);
    }
}