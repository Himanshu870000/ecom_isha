trigger caseTriggerOCS on Case (after insert) {
    
    if(Trigger.isInsert && Trigger.isAfter){
       // caseTriggerOCSHelper.assignCaseToActiveUser(trigger.new);
    }

}