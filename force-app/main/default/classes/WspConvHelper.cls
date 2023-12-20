public without sharing class WspConvHelper {

    @Auraenabled
    public static Contact startConversation(String recordId){
        Contact con = [SELECT Id, Whatsapp__c,Predefined_Message__c FROM Contact WHERE Id =: recordId];
        system.debug('con.Whatsapp__c' + con.Whatsapp__c);
        return con;
    }
}