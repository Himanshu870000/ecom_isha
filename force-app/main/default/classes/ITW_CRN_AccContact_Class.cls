public without sharing class ITW_CRN_AccContact_Class {
    
    @AuraEnabled
    Public Static Account getCurrentAccountDetails(String recordId){
        try{
            Account acc = [SELECT Id,Name,Company_Legal_Name__c,Inception_Of_Company__c,Industry,Website FROM Account WHERE Id=:recordId LIMIT 1];
            return acc;
        }catch(Exception e){
            System.debug('Error  '+e.getMessage() + ' && Line '+e.getLineNumber());
        }
        return null;
    }
    
    @AuraEnabled
    public static void saveRequestForm( string AccountId, Account accRec, Contact ConRec) {
        system.debug('AccountId===>' +AccountId);
        system.debug('accRec===>' +accRec);
        system.debug('ConRec===>' +ConRec);
        try{
             update accRec;
              ConRec.AccountId = accRec.id;
              insert ConRec;
            
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
        }
         
    }
    
    @AuraEnabled
    public Static List<String> getPickListValuesMethod(String ObjectApi_name, String Field_Name){
        try{
            List<String> lstPickvals                        = new List<String>();
            Schema.SObjectType targetType                   = Schema.getGlobalDescribe().get(ObjectApi_name);
            Sobject Object_name                             = targetType.newSObject();
            Schema.sObjectType sobject_type                 = Object_name.getSObjectType(); 
            Schema.DescribeSObjectResult sobject_describe   = sobject_type.getDescribe();
            Map<String, Schema.SObjectField> field_map      = sobject_describe.fields.getMap();
            List<Schema.PicklistEntry> pick_list_values     = field_map.get(Field_Name).getDescribe().getPickListValues();
            
            for (Schema.PicklistEntry a : pick_list_values) {
                lstPickvals.add(String.ValueOf(a.getLabel()).trim());  
            }
            System.debug('lstPickvals>>>> ::'+lstPickvals);
            return lstPickvals;
        }Catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
        }
        return null;
    }
     
  }