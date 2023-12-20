public class SkillbaseRouting {
    
    public static void skillBasedRouting(List<case> caseList){
        List<Entitlement> et= [SELECT Id, AccountId FROM Entitlement WHERE Name = 'Case Support Process - V1'];
        string contactId = [Select Id from COntact where AccountId =:et[0].AccountId ].id;
        if(et.size()>0){
            for(case cs : caseList){
                cs.EntitlementId = et[0].Id;
                cs.AccountId = et[0].AccountId;
                cs.ContactId = contactId;
                cs.Case_New_Status__c = 'New';
            }
        }
    }
    public static void updateField(List<case> caseList){
        system.debug('Coming here');
        for(case cs : caseList){
            if(cs.Is_Damaged__c == true){
                // cs.Case_New_Status__c = 'Damaged';
            }
        }
    }
}