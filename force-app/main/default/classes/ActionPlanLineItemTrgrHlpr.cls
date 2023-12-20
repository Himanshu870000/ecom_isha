public class ActionPlanLineItemTrgrHlpr {
    public static void createTaskForLineItems(Map<Id, Action_Plan_Line_Item__c> newLineItemMap){
        List<Task> taskList = new List<Task>();
        try{
            for(Action_Plan_Line_Item__c actionPlanItemRec : newLineItemMap.values()){
                Task task = new Task();
                task.ActivityDate = actionPlanItemRec.Due_Date__c;
                task.WhoId = actionPlanItemRec.Lead__c;
                task.Priority = 'Normal';
                //task.WhatId = actionPlanItemRec.Id;
                task.Subject = actionPlanItemRec.Subject__c;
                task.Status = 'Not Started';
                taskList.add(task);
            }
            if(!taskList.isEmpty()){
                system.debug('taskList:::'+taskList);
                insert taskList;
            }
        }catch(exception ex){
            system.debug('Error==>'+ex.getMessage()+'Error@==>'+ex.getLineNumber());
        }
        
    }
}