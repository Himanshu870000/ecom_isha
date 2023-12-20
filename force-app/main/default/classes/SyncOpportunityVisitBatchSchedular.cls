global class SyncOpportunityVisitBatchSchedular implements Schedulable{
	global void execute(SchedulableContext sc){
     	SyncOpportunityVisitBatch b = new SyncOpportunityVisitBatch(); // Your batch class
       	Database.executeBatch(b);
     }
}