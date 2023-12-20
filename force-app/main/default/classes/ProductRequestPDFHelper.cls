public class ProductRequestPDFHelper {
    String recordId {get;set;}
     public Date todayDate {get;set;}
    public List<ProductRequestLineItem> prodRequestLineItemList {get;set;}
    public ProductRequestPDFHelper(ApexPages.StandardController ctrl) {
         recordId= ctrl.getId();
         todayDate = System.today();
        if(String.isNotBlank(recordId)){
            prodRequestLineItemList = [SELECT Id,QuantityRequested,QuantityUnitOfMeasure,NeedByDate,Product2.Name,ParentId,ShipmentType FROM ProductRequestLineItem WHERE ParentId=:recordId];
        }
    }
}