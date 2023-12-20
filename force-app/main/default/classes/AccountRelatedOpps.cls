public class AccountRelatedOpps {
    @AuraEnabled
    public static wrapper getOppData(Id recId){
        Integer newCount = 0;
        Integer underCount = 0;
        Integer closedCount = 0;
        Integer caseCount = 0;
        
        List<opportunity> oppList = [Select id,AccountId,StageName From Opportunity Where AccountId=:recId ];
        
        for(Opportunity opp:oppList){
            if(opp.StageName  == 'New'){
                newCount = newCount + 1;
            }
            if(opp.StageName == 'UNDER-PAYMENT'){
                underCount = underCount + 1;
            }
            if(opp.StageName == 'Closed Won'){
                closedCount = closedCount + 1;
            }
        }
        
        
        List<Case> csList = [Select id, AccountId From Case Where AccountId=:recId ];
        for(Case cs : csList){
            caseCount += 1;
        }
        system.debug('newCount:::'+newCount);
        system.debug('underCount:::'+underCount);
        system.debug('closedCount:::'+closedCount);
        
        
        Wrapper wrap = new Wrapper();
        wrap.TotalOpportunityCount = oppList.size();
        wrap.NewStageOpportunityCount = newCount;
        wrap.UnderPaymentOpportunityCount = underCount;
        wrap.ClosedWonOpportunityCount = closedCount;
        wrap.TotalCaseCount = caseCount;
        system.debug('wrap:::'+wrap);
        return wrap;       
    }
    
    public class wrapper{
        @AuraEnabled
        public Integer TotalOpportunityCount {get;set;}
        @AuraEnabled
        public Integer NewStageOpportunityCount {get;set;}
        @AuraEnabled
        public Integer UnderPaymentOpportunityCount {get;set;}
        @AuraEnabled
        public Integer ClosedWonOpportunityCount {get;set;}
         @AuraEnabled
        public Integer TotalCaseCount {get;set;}
    }
	
}