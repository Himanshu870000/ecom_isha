trigger InvoiceTrigger on Invoice__c(after update,after Insert) {
    
    if(Trigger.isAfter && Trigger.isUpdate) {
        system.debug('Before insert Invoice');
        InvoiceTriggerHelper.paymentStatusUpdated(trigger.oldMap, trigger.newMap);
    }
    if(Trigger.isAfter && Trigger.isInsert){
        TaskUpdateAfterInvoiceCreateOnOpp.UpdateTaskOnInvCreate(Trigger.new);
    }
}