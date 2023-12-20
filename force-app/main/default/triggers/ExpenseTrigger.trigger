trigger ExpenseTrigger on ExpenseT__Expense__c (after update) {
    if(trigger.isAfter && trigger.isUpdate){
        ExpenseTriggerHelper.sendForFinanceApproval(trigger.newMap, trigger.oldMap);
    }
}