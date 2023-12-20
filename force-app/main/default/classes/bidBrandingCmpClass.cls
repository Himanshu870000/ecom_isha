public class bidBrandingCmpClass {
    
    @AuraEnabled(Cacheable=True)
    Public static List<Bid_Branding_Asset__c> BidAssetList(){
        Id userId =UserInfo.getUserId();
        List<Bid_Branding_Asset__c> AssetRecList=[Select Id,Name,Logo__c, Asset_Belongs_To__r.Name,Selling_Target_Date__c,
                                                  Selling_Asset_Cost__c,Event_Schedular__r.Event_Start_Date__c
                                                  From Bid_Branding_Asset__c Where Sales_Person__c=:userId AND Available_Quantity__c > 0];
        return AssetRecList;
    }
    
    @AuraEnabled(cacheable=true)
    Public static List<Investment__c> getInvestmentRecords(){
        return [SELECT Id, Name, Show_Record__c, Funding_Amount__c, Funding_Date__c, Account__r.Name, Account__r.Type__c, Account__r.Logo__c, Investment_Firms__c FROM Investment__c WHERE 
        Show_Record__c = true AND Recommended_Record__c=true LIMIT 5];
    }

}