public class InsertLeadNurtureUnderLead {
    @AuraEnabled
    public static list<Lead_Nurture_Step__c> createLeadNurture( list<Lead_Nurture_Step__c> nurturelist,string leadid ){
        system.debug('leadid');
        for(Lead_Nurture_Step__c var : nurturelist){
            var.Lead__c = leadid;
        }
        system.debug('nurturelist' +leadid);
        upsert nurturelist;
        system.debug('nurturelist Insert' +nurturelist);
        return nurturelist;
        
    }
    @AuraEnabled
    public Static List<Lead_Nurture_Step__c> checkLeadNurStep(String leadId){
        List<Lead_Nurture_Step__c> NurterList = new List<Lead_Nurture_Step__c>();
        try{
           NurterList  = [SELECT Description__c,End_Date__c,Id,Lead__c,Name,Opportunity__c,Start_Date__c,Status__c,User__c FROM Lead_Nurture_Step__c Where Lead__C =:leadId];
            if(!NurterList.isEmpty()){
                
            }
        }
        catch(exception e){
            
        }
        return NurterList;
        
    }
}