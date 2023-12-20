public class CallBatchController {
    
    @AuraEnabled
    Public static void callMethod(){
        Database.executeBatch(new CreateInvestmentRecords());
    }

    @AuraEnabled(cacheable=true)
    Public static List<Investment__c> getInvestmentRecords(){
        return [SELECT Id, Name, Show_Record__c, Funding_Amount__c, Funding_Date__c, Account__r.Name, Account__r.Logo__c, Investment_Firms__c FROM Investment__c WHERE Show_Record__c = true LIMIT 5];
    }

    @AuraEnabled(cacheable=true)
    Public static List<News_Feed__c> getNewsFeed(){
        return [SELECT Id, Name, Actual_URL__c, Author__c, News_Type__c, Company_Name__c, Description__c, Headline__c, Industry__c, News_Agency__c, Published_Date__c FROM News_Feed__c ORDER BY Name LIMIT 5];
    }

    @AuraEnabled(cacheable=true)
    Public static List<Event> getTodayEvent(){
        return [SELECT Id, Subject, StartDateTime, EndDateTime, WhatId, WhoId, Event_Start_Time__c FROM Event order by createdDate DESC LIMIT 5];
    }

    @AuraEnabled(cacheable=true)
    Public static List<Task> getTodayTask(){
        return [SELECT Id, Subject, ActivityDate, WhatId, WhoId, Owner.Name, Show_Task__c FROM Task WHERE Show_Task__c = true LIMIT 5];
    }

    @AuraEnabled(cacheable=true)
    Public static List<Contact> getContacts(){
        return [SELECT Id, FirstName, LastName, Account.Name, Phone, Predefined_Message__c, Show_Contact__c, Whatsapp__c FROM Contact WHERE Show_Contact__c = true LIMIT 5];
    }
    
    @AuraEnabled(cacheable=true)
    Public static List<Internal_Updates__c> getInternalUpdatesRecords(){
        try{
            List<Internal_Updates__c> listOfInternalUpdates = [SELECT Id, Team_Name__c, Announcement_Description__c, Is_Expirable__c, Is_Expired__c,Announcement_Validity_Date__c FROM Internal_Updates__c LIMIT 5];
            return listOfInternalUpdates;
        }catch(Exception e){
            return null;
        }
    }

    @AuraEnabled(cacheable=true)
    Public static List<Account> getRecommendedAccounts(){
        return [SELECT Id, Name, Email__c FROM Account Where Email__c Like '%%salesquery.in'];
    }
}