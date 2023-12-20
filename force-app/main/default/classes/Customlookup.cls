public class Customlookup {
      
     @AuraEnabled
    public static List<SObJectResult> getResults(String ObjectName, String fieldName, String value) {
        List<SObJectResult> sObjectResultList = new List<SObJectResult>();
        for(sObject so : Database.Query('Select Id,'+fieldName+' FROM '+ObjectName+' WHERE '+fieldName+' LIKE \'%' + value + '%\'')) {
            String fieldvalue = (String)so.get(fieldName);
            sObjectResultList.add(new SObjectResult(fieldvalue, so.Id));
        }
        
        return sObjectResultList;
    }
    
    @auraEnabled
    public static user getSelectedUserRecord(String ObjectName, String fieldName, String userId){
        system.debug('ObjectName ====>   ' + ObjectName);
        system.debug('fieldName ====>   ' + fieldName);
        system.debug('userId ====>   ' + userId);
        user us = [SELECT Id,Name FROM User where Id=: userId];
        system.debug('us ====>   ' + us);
        return us;
    }
    
    public class SObJectResult {
        @AuraEnabled
        public String recName;
        @AuraEnabled
        public Id recId;
        
        public SObJectResult(String recNameTemp, Id recIdTemp) {
            recName = recNameTemp;
            recId = recIdTemp;
        }
    }

}