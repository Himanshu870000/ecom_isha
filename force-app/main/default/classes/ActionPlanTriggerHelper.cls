public class ActionPlanTriggerHelper {
    public static void createtaskForActionPlan(Map<Id, Action_Plan__c> newActionPlanMap){
        try{
            List<Action_Plan_Line_Item__c> lineItemList = new List<Action_Plan_Line_Item__c>();
            List<Task> taskList = new List<Task>();
            integer noOfActionPlans = 5;
            
            for(Action_Plan__c actionPlanRec : newActionPlanMap.values()){
                Action_Plan_Line_Item__c followUpItem = new Action_Plan_Line_Item__c(Due_Date__c = system.today().addDays(2),Lead__c = actionPlanRec.Lead__c,Priority__c = 'Normal',Action_Plan__c = actionPlanRec.Id,Status__c = 'Not Started',Subject__c = 'First Discussion with Customer');
                lineItemList.add(followUpItem);
                Action_Plan_Line_Item__c demoItem = new Action_Plan_Line_Item__c(Due_Date__c = system.today().addDays(10),Lead__c = actionPlanRec.Lead__c,Priority__c = 'Normal',Action_Plan__c = actionPlanRec.Id,Status__c = 'Not Started',Subject__c = 'Take Discovery Call with Customer');
                lineItemList.add(demoItem);
                Action_Plan_Line_Item__c proposalItem = new Action_Plan_Line_Item__c(Due_Date__c = system.today().addDays(15),Lead__c = actionPlanRec.Lead__c,Priority__c = 'Normal',Action_Plan__c = actionPlanRec.Id,Status__c = 'Not Started',Subject__c = 'Take Follow-Up Call with Customer');
                lineItemList.add(proposalItem);
                Action_Plan_Line_Item__c completionItem = new Action_Plan_Line_Item__c(Due_Date__c = system.today().addDays(21),Lead__c = actionPlanRec.Lead__c,Priority__c = 'Normal',Action_Plan__c = actionPlanRec.Id,Status__c = 'Not Started',Subject__c = 'Give Demo to Customer');
                lineItemList.add(completionItem);
                Action_Plan_Line_Item__c negotiateOverProposalItem = new Action_Plan_Line_Item__c(Due_Date__c = system.today().addDays(30),Lead__c = actionPlanRec.Lead__c,Priority__c = 'Normal',Action_Plan__c = actionPlanRec.Id,Status__c = 'Not Started',Subject__c = 'Create Opportunity and Negotiate if Required and send Quote');
                lineItemList.add(negotiateOverProposalItem);
                
                Task task = new Task();
                task.ActivityDate = system.today().addDays(2);
                task.WhoId = actionPlanRec.Lead__c;
                task.Priority = 'Normal';
                task.Subject = 'First discussion with customer';
                task.Status = 'Not Started';
                taskList.add(task);
            }
            if(!lineItemList.isEmpty()){
                insert lineItemList;
            }
            if(!taskList.isEmpty()){
                insert taskList;
            }
            
        }catch(exception ex){
            system.debug('Error==>'+ex.getMessage()+'Error@==>'+ex.getLineNumber());
        }
    }
}