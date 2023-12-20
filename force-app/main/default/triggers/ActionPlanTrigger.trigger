trigger ActionPlanTrigger on Action_Plan__c (after insert) {
    if(trigger.isInsert && trigger.isAfter){
       ActionPlanTriggerHelper.createtaskForActionPlan(trigger.newMap);
    }
}