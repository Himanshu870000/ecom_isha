public without sharing class DecisionMakerCompHandler {
    
    @AuraEnabled
    public static void insertEmployees(String jsonOfListOfAccounts,Id recordId){
        system.debug('jsonOfListOfAccounts--->'+jsonOfListOfAccounts);
        system.debug('recordId--->'+recordId);
        
        Opportunity opp = [select id,AccountId from Opportunity where id =: recordId];
        List<contact> listOfAccounts = (List<contact>) JSON.deserialize(jsonOfListOfAccounts, List<contact>.class);
        
        system.debug('listOfAccounts--->'+listOfAccounts);
        system.debug('opp--->'+opp);
        
        for(Contact con : listOfAccounts){
            con.AccountId = opp.AccountId;
        }
        insert listOfAccounts;

        opportunity oppUpdate = new Opportunity();
        oppUpdate.Id = recordId;
        oppUpdate.StageName = '	Prospect';
        update oppUpdate;

        Task ts = [select id,status from task where whatId =: recordId and subject = 'Find Decision Maker'];

        ts.status = 'Completed';
        update ts;
    }
}