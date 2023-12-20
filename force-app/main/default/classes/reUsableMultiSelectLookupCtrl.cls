public class  reUsableMultiSelectLookupCtrl{
    @AuraEnabled
    public static List < sObject > fetchLookUpValues(String searchKeyWord, String ObjectName, List<sObject> ExcludeitemsList) {
        String searchKey = '%' + searchKeyWord + '%';
        List < sObject > returnList = new List < sObject > ();
        
        system.debug('ExcludeitemsList--->'+ExcludeitemsList);
        system.debug('ObjectName--->'+ObjectName);
        system.debug('searchKeyWord--->'+searchKeyWord);
        
        List<string> lstExcludeitems = new List<string>();
        for(sObject item : ExcludeitemsList ){
            lstExcludeitems.add(item.id);
        }
        String sQuery = '';
        // Create a Dynamic SOQL Query For Fetch Record List with LIMIT 5 and exclude already selected records  
        if(ObjectName == 'contact'){
            sQuery =  'select id, Name ,Email from ' +ObjectName + ' where Name LIKE: searchKey AND Id NOT IN : lstExcludeitems and Is_Alumni__c = true order by createdDate DESC limit 5';
            
        }else{
            sQuery =  'select id, Name ,Email from ' +ObjectName + ' where Name LIKE: searchKey AND Id NOT IN : lstExcludeitems order by createdDate DESC limit 5';
            
        }
        List < sObject > lstOfRecords = Database.query(sQuery);
        
        for (sObject obj: lstOfRecords) {
            returnList.add(obj);
        }
        return returnList;
    }
    
    
}