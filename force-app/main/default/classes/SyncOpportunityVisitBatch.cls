public without sharing class SyncOpportunityVisitBatch implements Database.Batchable<sObject>, Database.AllowsCallouts{
    

    
     public Database.QueryLocator start(Database.BatchableContext BC){
        String query = 'SELECT Id, Name, Account.Email__c,CloseDate,Account.ShippingStreet,Account.ShippingCity,Account.ShippingState,Account.ShippingCountry,Account.Geo_Location__Latitude__s,Account.Geo_Location__Longitude__s,StageName,Delivery_Agent__r.Email,Delivery_Agent__r.Phone,Franchise_Associated_To__r.Geo_Location__Latitude__s,Franchise_Associated_To__r.Geo_Location__Longitude__s from Opportunity where CloseDate = TODAY AND Account.Geo_Location__Latitude__s!=null And Account.Geo_Location__Longitude__s!=null AND Franchise_Associated_To__c!=null AND Delivery_Agent__r.Email!=null';
        System.debug('Query-----'+query);
        return Database.getQueryLocator(query);
   }

   public void execute(Database.BatchableContext BC, List<Opportunity> records){
     SyncOpportunityVisit.syncVisit(records);  
    }

   public void finish(Database.BatchableContext BC){
   }
}