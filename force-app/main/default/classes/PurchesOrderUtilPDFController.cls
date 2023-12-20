public class PurchesOrderUtilPDFController {
    String recordId {get;set;}
    public Date todayDate {get;set;}
    public List<OpportunityLineItem> oppLineItemList {get;set;}
    Public Decimal SubTotalPrice {get;set;}
    public Decimal subtotalwithDiscount {get;set;}
    public Decimal Discount {get;set;} 
    public PurchesOrderUtilPDFController(ApexPages.StandardController ctrl) {
        recordId= ctrl.getId();
        todayDate = System.today();
        Discount = 15;
        if(String.isNotBlank(recordId)){
            oppLineItemList = [SELECT Id,Name,OpportunityId,Product2.Name,Product2.HSN_Code__c,Quantity,UnitPrice FROM OpportunityLineItem WHERE OpportunityId=:recordId];
            Decimal subTotal=0;
            if(oppLineItemList.size()>0){
                for(OpportunityLineItem oppline : oppLineItemList){
                    subTotal = oppline.UnitPrice+subTotal;
                }
                if(subTotal !=null){
                    SubTotalPrice = subTotal;
                }
                System.debug('subTotal == >'+subTotal);
                subtotalwithDiscount = SubTotalPrice * Discount / 100;
                System.debug('subtotalwithDiscount == >'+subtotalwithDiscount);
            }
        }
    }
}