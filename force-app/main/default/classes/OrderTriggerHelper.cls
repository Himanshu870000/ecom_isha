public class OrderTriggerHelper {
    public static void afterUpdate(Map<Id, Order> newOrderMap, Map<Id, Order> oldOrderMap){
        for(Order orderRec : newOrderMap.values()){
            if(orderRec.Scheme_Discount__c != oldOrderMap.get(orderRec.id).Scheme_Discount__c && orderRec.Scheme_Discount__c != null){
                
            }
        }
    }
}