public class GraphyUpdateOpportunityHelper {
    @AuraEnabled
    public static void updateOpportunityStage(String opportunityId){
        Opportunity oppRec= new opportunity();
        oppRec.Id = opportunityId;
        oppRec.StageName = 'Contract Signed';
        update oppRec;	
    }
}