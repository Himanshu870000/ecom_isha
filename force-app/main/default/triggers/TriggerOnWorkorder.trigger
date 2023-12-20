trigger TriggerOnWorkorder on WorkOrder (before insert,After Insert) {
	
    if(Trigger.isInsert && Trigger.isAfter){
        WorkorderTriggerHandler.createWorkOrderLineItems(Trigger.New);
    }
}