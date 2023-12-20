trigger WorkOrderTrigger on WorkOrder (After insert) {
    if(trigger.isAfter && trigger.isInsert){
        //WorkOrderTriggerHelper.afterInsert(trigger.new);
    }
}