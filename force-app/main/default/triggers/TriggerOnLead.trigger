trigger TriggerOnLead on Lead (before insert,after Update,after insert, before update) {
	
    LeadTriggerHelper handler = LeadTriggerHelper.getInstance();
    
    if(trigger.isUpdate && trigger.isAfter){
        system.debug('Inside lead trigger::');
        handler.createVisitRecords(trigger.new,trigger.oldMap);
        //handler.creatingTaskForLead(Trigger.New);
        //handler.Questiontagged(trigger.newMap,  trigger.oldmap);
        //handler.sendemailAttachonstatusupdate(Trigger.New);
        handler.notifyLead(trigger.newMap, trigger.oldMap);
    }
    
    if(Trigger.isInsert  && Trigger.isbefore){
        handler.handleBeforeInsert(trigger.new);
    }
    
    if(Trigger.isUpdate  && Trigger.isbefore){
        handler.assignMembers(trigger.new,trigger.oldmap);
        handler.addValidation(trigger.newmap,trigger.oldmap);
        handler.creatingTaskForLead(trigger.newmap,trigger.oldmap);
    }
    
    if(Trigger.isInsert  && Trigger.isafter){
        //handler.creatingActionPlanForLead(trigger.newMap);
        //handler.createFolders(Trigger.newMap);
        //handler.createVisaInquiryRecord(Trigger.new);
        handler.createTask(trigger.new);
        Set<Id> ledIdSet = new Set<Id>();
        for(Lead led : trigger.new){
            ledIdSet.add(led.id);
        }
        VisitSchedulerController.updateLeadGeoLocation(ledIdSet);
    }
}