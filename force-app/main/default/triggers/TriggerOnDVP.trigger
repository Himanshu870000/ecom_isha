trigger TriggerOnDVP on Day_Visit_Plan__c(before insert) {
    if(trigger.isInsert && trigger.isBefore){
        Scheduler_Insights_Handler.updateMonthname(trigger.new);
    }
}