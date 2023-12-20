public class DealerProductController {
    @AuraEnabled
    public static List<Dealer_Product__c> getDealerProductList(Integer pageSize, Integer pageNumber, string accountId){
        system.debug('pageSize--->'+pageSize);
        system.debug('pageNumber--->'+pageNumber);
        system.debug('accountId--->'+accountId);
        
        if(string.isBlank(accountId)){
            accountId = '001N000002B87oxIAB';
        }
        
        Integer offset = (pageNumber - 1) * pageSize;
        
        List<Dealer_Product__c> dealerProdList = [SELECT Id, Name,Dealer__r.Name,Product__r.Name,Product_Code__c FROM Dealer_Product__c WHERE Dealer__c=: accountId LIMIT :pageSize OFFSET :offset];
        System.debug('dealerProdList::::'+dealerProdList);
        return dealerProdList;
    }
    
    @AuraEnabled
    public static Integer calculateProgress(Integer startValue, Integer stopValue, Integer currentValue) {
        Integer range = stopValue - startValue;
        if (range == 0) {
            return 0;
        }
        return (currentValue - startValue) * 100 / range;
    }
    
    
    @AuraEnabled
    public static PricebookEntry getProductPrice(String selectedProductId) {
        PricebookEntry pbrec;
        if(selectedProductId != NULL){
            pbrec = [Select Id, Product2Id, Pricebook2Id,UnitPrice,IsActive From PricebookEntry Where Product2Id =:selectedProductId AND IsActive = true AND UseStandardPrice = true LIMIT 1];
            System.debug('pbrec:::::'+pbrec); 
        }
        //  PricebookEntry pbrec = [Select Id,UnitPrice,IsActive From PricebookEntry Where Product2Id =:selectedProductId AND IsActive = true AND UseStandardPrice = true LIMIT 1];
        //  String productPrice = String.valueOf(pbrec.UnitPrice); 
        return pbrec;    
    }
}