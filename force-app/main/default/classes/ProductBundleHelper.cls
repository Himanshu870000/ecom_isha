public class ProductBundleHelper {
    
    @AuraEnabled(cacheable=true)
    public static List<Product2> GetAllProduct() {
        try{
            return [SELECT Allowed_Discount__c,CreatedById,CreatedDate,Description,DisplayUrl,ExternalDataSourceId,ExternalId,Family,Id,IsActive,IsArchived,IsDeleted,LastModifiedById,LastModifiedDate,LastReferencedDate,LastViewedDate,Name,ProductCode,QuantityUnitOfMeasure,StockKeepingUnit,SystemModstamp FROM Product2 WHERE IsActive = true];
        }
        catch(Exception e){
            system.debug('The following exception has occurred: ' + e.getMessage() + 'at line Number : ' + e.getLineNumber());
            return null;
        }
    } 
    @auraEnabled
    public static List<Product_Bundle__c> GetAllProductBundle(string productId) {
        try{
            return [SELECT Bundle_Product__c,CreatedById,CreatedDate,Description__c,Quantity__c,Id,IsDeleted,LastModifiedById,LastModifiedDate,Name,OwnerId,Price__c,Product__c,Recommended__c,SystemModstamp FROM Product_Bundle__c WHERE Product__c =: productId];
        }
        catch(Exception e){
            system.debug('The following exception has occurred: ' + e.getMessage() + 'at line Number : ' + e.getLineNumber());
            return null;
        }
    } 
     @auraEnabled
    public static String submitProductBundle(string productId,String oppId,List<Product_Bundle__c> prodBundle) {
        try{
            Utility.createQuoteLineItems(productId,oppId,prodBundle);
            
            return 'Success';
           // return [SELECT Bundle_Product__c,CreatedById,CreatedDate,Description__c,Id,IsDeleted,LastModifiedById,LastModifiedDate,Name,OwnerId,Price__c,Product__c,Recommended__c,SystemModstamp FROM Product_Bundle__c WHERE Product__c =: productId];
        }
        catch(Exception e){
            system.debug('The following exception has occurred: ' + e.getMessage() + 'at line Number : ' + e.getLineNumber());
            return e.getMessage();
        }
    } 
}