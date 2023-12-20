public class ExpenseTriggerHelper {
    public static void sendForFinanceApproval(Map<Id, ExpenseT__Expense__c> newMap, Map<Id, ExpenseT__Expense__c> oldMap){
        for(ExpenseT__Expense__c expenseRec : newMap.values()){
            if(expenseRec.ExpenseT__Expense_Total_Amount__c	 != oldMap.get(expenseRec.Id).ExpenseT__Expense_Total_Amount__c && expenseRec.ExpenseT__Expense_Total_Amount__c >100000){
                Id approverId = '005N000000AkhoZ';
                Approval.ProcessSubmitRequest approvalRequest = new Approval.ProcessSubmitRequest();
                approvalRequest.setComments('Submitting to Finance Head For Approval.');
                approvalRequest.setObjectId(expenseRec.Id);
                approvalRequest.setSubmitterId(UserInfo.getUserId());
                approvalRequest.setProcessDefinitionNameOrId('Expense_Manager_Approval_Process');
                approvalRequest.setSkipEntryCriteria(true);
                approvalRequest.setNextApproverIds(new List<Id>{ approverId }); 
                Approval.ProcessResult result = Approval.process(approvalRequest);
            }
        }        
    }
}