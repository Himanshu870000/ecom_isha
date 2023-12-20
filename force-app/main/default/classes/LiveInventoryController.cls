public class LiveInventoryController {
	@AuraEnabled
    public static List<Store_Inventory__c> getStoreInventoryList(Integer pageSize, Integer pageNumber, string accountId){
        Integer offset = (pageNumber - 1) * pageSize;
        List<Store_Inventory__c> livInvList = new List<Store_Inventory__c>();
        //livInvList = [Select Id,Name,is_Item_Available__c,Store__r.Name, Dealer_Product__r.Name,Dealer_Product__r.Product__r.Id, Dealer_Product__r.Product__r.Name,Dealer_Product__r.Product_Code__c FROM Store_Inventory__c LIMIT :pageSize OFFSET :offset];
        livInvList = [Select Id,Name,is_Item_Available__c,Available_Quantity__c,Store__r.Name, Dealer_Product__r.Product__r.Name,Dealer_Product__r.Product_Code__c FROM Store_Inventory__c WHERE Store__r.Account__c=: accountId LIMIT :pageSize OFFSET :offset];
        system.debug('livInvList::::'+livInvList);
        return livInvList;
    }
}