trigger TriggerOnFile on ContentDistribution (after insert,after delete) {
    TriggerOnFileHelper triggerOnHelperInstance = TriggerOnFileHelper.getInstance();

    if(Trigger.isAfter && Trigger.isInsert){
        triggerOnHelperInstance.afterInsert(Trigger.new);
    }

    if(Trigger.isAfter && Trigger.isDelete){
        triggerOnHelperInstance.afterDelete(Trigger.old);
    }
}