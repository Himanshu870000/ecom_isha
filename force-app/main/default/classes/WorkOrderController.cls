public class WorkOrderController {
    
    @AuraEnabled
    public static string createWO(Id oppId){
        try{
            if(!string.isBlank(oppId)){
                
                Opportunity getOppRecord= [SELECT Id, Name, Factory__c, AccountId FROM Opportunity WHERE Id =: oppId];
                List<OpportunityContactRole> getContactRoleList = [SELECT Id, OpportunityId FROM OpportunityContactRole WHERE OpportunityId =: getOppRecord.Id];
                
                if(getOppRecord !=NULL){
                WorkOrder newWorkOrder = new WorkOrder();
                newWorkOrder.Opportunity__c  = getOppRecord.Id;
                newWorkOrder.WorkTypeId  = '08qN000000005ohIAA';
                newWorkOrder.ServiceTerritoryId  =  '0HhN000000009K3KAI';
                newWorkOrder.Work_Order_Stages__c  = 'SO';
                newWorkOrder.LocationId  = getOppRecord.Factory__c;
                newWorkOrder.AccountId  = getOppRecord.AccountId;
                //newWorkOrder.ContactId  = getContactRoleList[0].Id;
                insert newWorkOrder;
                return 'SUCCESS';
                }
            }
            return 'Id not specified';
        }
        catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }
}