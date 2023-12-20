public class SendLeadtoHOForApprovalHandler {
    @AuraEnabled
    public static void sendforApproval(string recordId){
        Id approverId = '005N000000AkhoZ';
        Approval.ProcessSubmitRequest approvalRequest = new Approval.ProcessSubmitRequest();
        approvalRequest.setComments('Submitting to Head Office For OnBoarding.');
        approvalRequest.setObjectId(recordId);
        approvalRequest.setSubmitterId(UserInfo.getUserId());
        approvalRequest.setProcessDefinitionNameOrId('Submit_to_HO');
        approvalRequest.setSkipEntryCriteria(true);
        approvalRequest.setNextApproverIds(new List<Id>{ approverId }); 
        Approval.ProcessResult result = Approval.process(approvalRequest);
    }
}