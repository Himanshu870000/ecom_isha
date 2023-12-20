public without sharing class AttachPTTeacherController {

    @AuraEnabled
    Public Static String insertResource(String recId){
        
        List<WorkOrderLineItem> woLIList = [SELECT Id, WorkOrderId, WorkOrder.Opportunity__c FROM WorkOrderLineItem WHERE Id =: recId];
        system.debug('woLIList -- ' + woLIList);
        Id userId = [SELECT Id, Name FROM User WHERE Name = 'Mukesh Sharma'].Id;
        system.debug('userId -- ' + userId);
        
        Resource__c newRes = new Resource__c();
        newRes.User__c = userId;
        newRes.Opportunity__c = woLIList[0].WorkOrder.Opportunity__c;
        insert newRes;
        WorkOrder workOrderRec = new WorkOrder();
        workOrderRec.Id = woLIList[0].WorkOrderId;
        workOrderRec.Work_Order_Stages__c = 'Assign Resource';
        update workOrderRec;
        
        woLIList[0].Status = 'Completed';
        update woLIList[0];
        return 'Success';
    }
}