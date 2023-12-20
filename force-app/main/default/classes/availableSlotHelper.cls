public class availableSlotHelper {
    @AuraEnabled
    public static void updateDemoDAte(string leadID){
        Lead leadRec = new Lead();
        leadRec.Id = leadID;
        leadRec.Demo_Date__c = system.today();
        update leadRec;
        
    }
}