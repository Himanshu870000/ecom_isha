public with sharing class POLineItemHelper {
	@AuraEnabled
    public static List<Purchase_Order_Line_Item__c> getPOLineItemList(){
        return [Select Id,Product_Name__c,Product__c,Price__c,Purchase_Order__c	,Quantity__c From Purchase_Order_Line_Item__c];
    }
    
    @AuraEnabled
    public static List<Asset> saveAsset(List<Asset> AssetList){
        system.debug('AssetList_________>>>'+AssetList);
        if(!AssetList.IsEmpty()){
           insert AssetList;
        }
        return AssetList; 
    }
}