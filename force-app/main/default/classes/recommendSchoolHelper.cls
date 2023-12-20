public without sharing class recommendSchoolHelper {

    @AuraEnabled
    public static sObject fetchDefaultRecord(string recordId , string myObject) {
        string sRecId = recordId;    
        string sQuery = 'Select Id, Name From ' + myObject + ' Where Id = : sRecId and show__c = true';
        for (sObject obj: database.query(sQuery)) {
            return obj;
        }
        return null;
    }
    
    @AuraEnabled(cacheable=true)
    public static List<sObject> search(String searchTerm, string myObject) {
        system.debug('searchTerm -- ' + searchTerm);
        system.debug('myObject -- ' + myObject);
        String myQuery = null;
        if(searchTerm == null || searchTerm == ''){
            myQuery = 'Select Id, Name from '+myObject + ' where show__c = true';
        }
        else {
            myQuery = 'Select Id, Name from '+myObject+' Where Name Like  \'%' + searchTerm + '%\' and show__c = true';
        }
        system.debug('myQuery -- ' + myQuery);
        List<sObject> lookUpList = database.query(myQuery);
        return lookUpList;
    }
    
    @AuraEnabled
    public static List<Visit__c> getAllVisits(string oppId){
        try {
            return [SELECT Id, Name, School__c, Description__c, Visit_Date_Time__c, Opportunity__c FROM Visit__c WHERE Opportunity__c =: oppId order by CreatedDate DESC LIMIT 2];
        }
        catch (Exception e) {
            system.debug('Error in Getting Visits --> ' + e.getMessage() + ' At Line Number -->' + e.getLineNumber());
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    @AuraEnabled
    public static string saveVisits(List<Visit__c> visitRecList, string parentObjId){
        try {
            system.debug('visitRecList -- ' + visitRecList);
            system.debug('designSpecList.size() -- ' + visitRecList.size());
            
            for(Visit__c vst : visitRecList){
                vst.Opportunity__c  = parentObjId;
            }
            
            if(!visitRecList.isEmpty()){
                Database.Upsert(visitRecList);  
                return 'Success';
            }
            return 'empty';
        }
        catch (Exception e) {
            system.debug('Error in Saving Visits --> ' + e.getMessage() + ' At Line Number -->' + e.getLineNumber());
            throw new AuraHandledException(e.getMessage());
        }
    }
}