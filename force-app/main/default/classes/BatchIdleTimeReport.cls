global class BatchIdleTimeReport implements Database.Batchable<sObject>{
    public static Final String dataFilter = system.label.IdleTimeDateFilter;
    public Database.QueryLocator start(Database.BatchableContext bc){
        string QueryString = 'select id,Name,LastName, FirstName, ProfileId from User where Profile.Name = \'BDA\' AND isActive = true';
        return Database.getQueryLocator(QueryString);
    }
    
    public void execute(Database.BatchableContext bc, List<user> userlist){
        
        String query = 'Select id,Name,BDA__c from Idle_Time_Report__c where Createddate=' + dataFilter;
        List<Idle_Time_Report__c> alreadyCreatedRecords = Database.query(query);
        
        Set<String> allBDIds = new Set<String>();
        if (!alreadyCreatedRecords.isEmpty()){
            for (Idle_Time_Report__c itrRec : alreadyCreatedRecords){
                allBDIds.add(itrRec.BDA__c);
            }
        }
        
        for (user userRecord : userlist){
            //if(!allBDIds.contains(userRecord.Id))
            BDAFullViewHelper.BDAIdleTimeReport(userRecord.Id, system.today());
        }
    }
    
    public void finish(Database.BatchableContext bc){
    }
    
}