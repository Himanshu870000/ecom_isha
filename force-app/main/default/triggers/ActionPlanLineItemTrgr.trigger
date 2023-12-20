trigger ActionPlanLineItemTrgr on Action_Plan_Line_Item__c (after insert) {
    if(trigger.isInsert && trigger.isAfter){
        //ActionPlanLineItemTrgrHlpr.createTaskForLineItems(trigger.newMap);
    }
}