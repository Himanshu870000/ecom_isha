public class BatchOnVistRecordSend implements Database.Batchable <SObject> {
	
    public Database.QueryLocator Start(Database.BatchableContext bc){
        String query = 'SELECT Id,Name,CreatedDate FROM Visit__c WHERE CreatedDate = TODAY ';
        return Database.getQueryLocator(query);
    }
    public void Execute(Database.BatchableContext bc,List<Visit__c> vsList){
        for(Visit__c vs : vsList){
            
        }
    }
    public void Finish(Database.BatchableContext bc){
        
    }
}