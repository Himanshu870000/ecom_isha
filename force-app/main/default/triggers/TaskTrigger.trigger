trigger TaskTrigger on Task (after update,after insert) {
    if(trigger.isUpdate && trigger.isAfter){
        TaskTriggerHelper.createtaskforFinanceTeam(trigger.new,trigger.oldMap);
    }
    if(trigger.isAfter && trigger.isUpdate){
       // TaskTriggerHelper.updateLineItemStatus(trigger.newMap, trigger.oldMap);
    }
    if(trigger.isAfter && trigger.isInsert){
        //TaskTriggerHelper.afterinsert(trigger.new);
    }
}