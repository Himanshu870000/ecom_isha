public class DeliverChalanUtilPDFController {
    String recordId {get;set;}
    public Date todayDate {get;set;}
    public DateTime todayDateTime {get;set;}
    public List<OpportunityLineItem> oppLineItemList {get;set;}
    public DeliverChalanUtilPDFController(ApexPages.StandardController ctrl) {
        recordId= ctrl.getId();
        todayDate = System.today();
        todayDateTime = System.now();
        if(String.isNotBlank(recordId)){
            oppLineItemList = [SELECT Id,Name,OpportunityId,Product2.Name,Product2.HSN_Code__c,Quantity,UnitPrice FROM OpportunityLineItem WHERE OpportunityId=:recordId];
        }
    }
}