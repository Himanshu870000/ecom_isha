trigger TriggerOnPO on Purchase_Order__c (after insert) {
    POTriggerHandler helperInstance = POTriggerHandler.getInstance();
    if(Trigger.isAfter && Trigger.isInsert){
        helperInstance.afterInsert(Trigger.newMap);
    }
}