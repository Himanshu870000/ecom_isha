trigger TriggerOnContract on Contract (before insert) {
    if(trigger.isInsert && trigger.isAfter){
        Set<Id> QuoteId = new Set<Id>();
        Map<Id,Id> mapofQuoteIdbyConId = new Map<Id,Id>();
        Map<Id,Id> mapofquoteIdByTermId = new Map<Id,Id>();
        for(Contract con: trigger.new){
            if(con.Quote__c != null){
                QuoteId.add(con.Quote__c);
            }
            mapofQuoteIdbyConId.put(con.Quote__c,con.Id);
        }
        if(!QuoteId.isEmpty()){
            List<Terms_And_Conditions__c> tcList = new List<Terms_And_Conditions__c>();
            tcList = [Select Id,Name,Quote__c From Terms_And_Conditions__c Where Quote__c in: QuoteId];
            for(Terms_And_Conditions__c tc : tcList){
                tc.Contract__c = mapofQuoteIdbyConId.get(tc.Quote__c);
            }
            
            update tcList;
            
        }
        
    }
}