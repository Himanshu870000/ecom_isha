trigger EventSchedular on Event_Schedular__c (after insert) {
    if(trigger.isAfter && trigger.isInsert){
    ContractCreateController.createTaskForEventSchedular(trigger.new);
    }
}