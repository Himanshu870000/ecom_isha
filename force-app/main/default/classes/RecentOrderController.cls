public without sharing class RecentOrderController {

    @AuraEnabled
    public static List <Order> fetchOrderList(String caseId ) {
        
        List<Case> caseList = [SELECT Id, AccountId FROM Case WHERE Id =: '500N000000JQ7s7IAD'];
        system.debug('caseList -- ' + caseList);
        List<Order> orderList = [SELECT Id, OrderNumber, AccountId,  Account.Name, EffectiveDate, TotalAmount, Status FROM Order WHERE AccountId =: caseList[0].AccountId limit 10];
        system.debug('orderList -- ' + orderList);
        
        return orderList;
    }
    
}