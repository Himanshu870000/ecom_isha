public class ECommApprovalController {
    
    @AuraEnabled
    public static String submitForApproval(string caseId){
        try{
            
            system.debug('---'+caseId);
            
            if(!String.isBlank(caseId)) {
                ProcessInstance[] recordUnderApproval = [Select ID, Status,TargetObjectID, TargetObject.Name From ProcessInstance Where Status =: 'Pending' AND TargetObjectID =:caseId];
                if(!recordUnderApproval.isEmpty()){
                    return 'Pending';
                }
                Id approverId = [SELECT Id, UserRole.name FROM User WHERE userrole.name =: 'E-Comm Head'].Id;
                if(approverId != null) {
                    Approval.ProcessSubmitRequest approvalRequest = new Approval.ProcessSubmitRequest();
                    approvalRequest.setComments('Submitting project request for an approval.');
                    approvalRequest.setObjectId(caseId);
                    approvalRequest.setSubmitterId(UserInfo.getUserId());
                    approvalRequest.setProcessDefinitionNameOrId('E_Comm_Head_Approval');
                    approvalRequest.setSkipEntryCriteria(true);
                    approvalRequest.setNextApproverIds(new List<Id>{ approverId }); 
                    Approval.ProcessResult result = Approval.process(approvalRequest);
                    return 'SUCCESS';
                }
            }
        }catch(exception ex){
            system.debug('Error==>'+ex.getMessage());
            system.debug('Error>>><<'+ex.getLineNumber());
        }
        return 'Couldn\'t find approver on your role, please contact administrator.';
    }
    
}