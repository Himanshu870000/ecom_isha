public with sharing class GoarTracking {
    public GoarTracking() {
        string currentRecordId  = ApexPages.CurrentPage().getparameters().get('id');
        system.debug('currentRecordId::'+currentRecordId);
    }
    @AuraEnabled
    public static void createGoalTracking(string goalId){
        system.debug('goalId::'+goalId);
        goal__c goalObj = new goal__c();
        list<Goal_Tracking__c> goalTrackingListTobeInsert = new list<Goal_Tracking__c>();
        list<opportunity> opportunityList = new list<opportunity>();
        list<Goal_Tracking__c> goalTrackingTobeDelete = new list<Goal_Tracking__c>();
        goalObj = [select id,Fiscal_Year__c,Fiscal_Year__r.Fiscal_Start_Date__c,Fiscal_Year__r.Fiscal_End_Date__c from goal__c where id =: goalId];
        goalTrackingTobeDelete = [select id,Goal__c from Goal_Tracking__c where Goal__c=: goalObj.id];
            if(!goalTrackingTobeDelete.isEmpty()){
                delete goalTrackingTobeDelete;
            }
            opportunityList = [select id,ownerId,Amount,StageName from opportunity where CreatedDate >=: goalObj.Fiscal_Year__r.Fiscal_Start_Date__c and CreatedDate <=: goalObj.Fiscal_Year__r.Fiscal_End_Date__c];

            system.debug('opportunityList::'+opportunityList);

            
                if(!opportunityList.isEmpty()){
                    for(opportunity opp : opportunityList){
                        Goal_Tracking__c gtRec = new Goal_Tracking__c();
                        gtRec.Opportunity__c = opp.id;
                        gtRec.Opportunity_Owner__c = opp.ownerId;
                        gtRec.Goal__c = goalObj.id;
                        gtRec.Opportunity_Amount__c = opp.Amount;
                        gtRec.Opportunity_Stage__c = opp.StageName;
                        goalTrackingListTobeInsert.add(gtRec);
                    }

                    if(!goalTrackingListTobeInsert.isEmpty()){
                        insert goalTrackingListTobeInsert;
                    }
                }

    }
    @AuraEnabled
    public static goal__c revenueTrack(string goalId){
        try {
            goal__c goalObj = new goal__c();
            goalObj = [select id,Target__c,Achieved_Target__c,Expected_Amount__c,Fiscal_Year__c,Fiscal_Year__r.Fiscal_Start_Date__c,Fiscal_Year__r.Fiscal_End_Date__c from goal__c where id =: goalId];
            return goalObj;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static list<Goal_Tracking__c> prospectOpprtunity(string goalId){
        try {
            list<Goal_Tracking__c> goalTrackingOpportunity = new list<Goal_Tracking__c>();
            goalTrackingOpportunity = [select id,Goal__c,Opportunity__c,Opportunity__r.Amount,Opportunity__r.Name,Opportunity__r.StageName,Opportunity__r.AccountId,Opportunity__r.Account.name from Goal_Tracking__c where Goal__c =: goalId and Opportunity__r.StageName ='Prospecting'];
            return goalTrackingOpportunity;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled
    public static list<Goal_Tracking__c> closedWonOpprtunity(string goalId){
        try {
            list<Goal_Tracking__c> goalTrackingOpportunity = new list<Goal_Tracking__c>();
            goalTrackingOpportunity = [select id,Goal__c,Opportunity__c,Opportunity__r.Amount,Opportunity__r.Name,Opportunity__r.StageName,Opportunity__r.AccountId,Opportunity__r.Account.name from Goal_Tracking__c where Goal__c =: goalId and Opportunity__r.StageName ='Closed Won'];
            return goalTrackingOpportunity;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled
    public static TargetWrapper userwiseRevenue(string goalId){
        try {
            list<Goal_Tracking__c> goalTrackingList = new list<Goal_Tracking__c>();
            map<string,decimal> opprtunityownerByAmount = new map<string,decimal>();
            map<string,string> opportunityOwnerName = new map<string,string>();
            TargetWrapper targetRec = new TargetWrapper();
            goalTrackingList = [select id,Goal__r.Target__c,Opportunity__c,Opportunity__r.ownerId,Opportunity__r.Owner.Name,Opportunity__r.Amount from Goal_Tracking__c where Goal__c=: goalId];

            if(!goalTrackingList.isEmpty()){
                for(Goal_Tracking__c gltrkRec : goalTrackingList){
                    if(opprtunityownerByAmount.containsKey(gltrkRec.Opportunity__r.ownerId)){
                        opprtunityownerByAmount.put(gltrkRec.Opportunity__r.ownerId,(opprtunityownerByAmount.get(gltrkRec.Opportunity__r.ownerId) + gltrkRec.Opportunity__r.Amount));
                    }else{
                        opprtunityownerByAmount.put(gltrkRec.Opportunity__r.ownerId,gltrkRec.Opportunity__r.Amount);
                        opportunityOwnerName.put(gltrkRec.Opportunity__r.ownerId,gltrkRec.Opportunity__r.Owner.Name);
                    }
                }
                system.debug('opprtunityownerByAmount::'+opprtunityownerByAmount);
                system.debug('opportunityOwnerName::'+opportunityOwnerName);
                system.debug('keyset::'+opprtunityownerByAmount.keySet());
                targetRec.opp_owner_amount = new map<string,TargetChild>();
                for(string key : opprtunityownerByAmount.keySet()){
                    system.debug('key::'+key);
                    TargetChild tc = new TargetChild();
                    tc.amount = opprtunityownerByAmount.get(key);
                    tc.name = opportunityOwnerName.get(key);
                    system.debug('tc:'+tc);
                    targetRec.opp_owner_amount.put(key,tc);
                    system.debug('targetRec::'+targetRec);
                }
                //targetRec.opp_owner_amount = opprtunityownerByAmount;
                targetRec.total_amount = goalTrackingList[0].Goal__r.Target__c;
                targetRec.opp_owner_name = opportunityOwnerName;
                system.debug('targetRec::'+targetRec);
                
            }
            return targetRec;
        } catch (Exception e) {
            system.debug('execption trace::'+e.getStackTraceString());
            throw new AuraHandledException(e.getMessage());
        }
    }

    public class TargetWrapper{
        @AuraEnabled
        public map<string,TargetChild> opp_owner_amount;
        @AuraEnabled
        public map<string,string> opp_owner_name;
        @AuraEnabled
        public decimal total_amount;

    }
    public class TargetChild{
        @AuraEnabled
        public decimal amount;
        @AuraEnabled
        public string name;
        
    } 
}