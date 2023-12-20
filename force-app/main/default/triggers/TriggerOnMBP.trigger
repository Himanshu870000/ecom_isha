trigger TriggerOnMBP on Monthly_Beat_Plan__c (before insert, before delete) {
    if(trigger.isInsert && trigger.isBefore){
        BeatPlannerHelper.updateMonthname(trigger.new);
    }
    
    if(trigger.isDelete && trigger.isBefore){
        TriggerOnMBPHelper.beforeDelete(trigger.old);
    }
}