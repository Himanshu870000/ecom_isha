public class UnitSearchController {
    @AuraEnabled
    public static List<Unit__c> getUnits(String recordId) {
        List<Unit__c> UnitList = new  List<Unit__c>();
        
        try{
            Lead LeadValues =  [SELECT Carpet_Area__c,Facing__c,Parking_Needed__c,Preferred_City__c,Preferred_Country__c,Preferred_State__c,Property_Type__c,Street,Total_Area__c,Total_Score__c,Unit_Details__c FROM Lead where id=:recordId][0];
            
            Project__C prj = [SELECT Id FROM Project__c WHERE City__c = :LeadValues.Preferred_City__c OR State__c   = :LeadValues.Preferred_State__c OR Country__c  = :LeadValues.Preferred_Country__c ][0];
            
            List<Slabs__c> slablist = [SELECT Id FROM Slabs__c WHERE Project__c =: prj.Id];
            
            UnitList = [SELECT Id,Unit_Type__c,Project__c,Name,Project__r.name,Project__r.Construction_Status__c  FROM Unit__c WHERE Slab__c IN:slablist LIMIT 5]; 
            
        }catch(exception e){
            UnitList = [SELECT Id,Unit_Type__c,Project__c,Name,Project__r.name,Project__r.Construction_Status__c  FROM Unit__c LIMIT 5];
        }
        
        system.debug('UnitList'+UnitList);
        
        return UnitList;
        
    }    
    
    @AuraEnabled
    public static List<Unit__c> getUnitsforTransfer(String recordId) {
        
        String ProjectId =  [SELECT Unit__r.Project__c FROM Deal__c where id = :recordId].Unit__r.Project__c;
        try{
            List<Unit__c> UnitList = [SELECT Id,Unit_Type__c,Project__c,Name,Project__r.name,Project__r.Construction_Status__c  FROM Unit__c WHERE project__C = :ProjectId];
            return UnitList;
        }catch(exception e){
            system.debug('Exception =======>'+e.getMessage()+'at :'+e.getLineNumber());
            return null;
        }
        
        
    }
    @AuraEnabled
    public static Void TransferUnit(String unitId,String dealId) {
        system.debug('unitId'+unitId);
        Deal__c deal =  [SELECT Id,Transferred_Unit__c  FROM Deal__c where id = :dealId];
        try{
            deal.Transferred_Unit__c = unitId;
            Deal_Trigger_Helper.runTrigger = false;
            update deal;
        }catch(exception e){
            system.debug('Exception =======>'+e.getMessage()+'at :'+e.getLineNumber());
        }
    }
    
    @AuraEnabled
    public static void createVisitLineItems(list<unit__c> unitsList,String leadId,String projectID){
        system.debug('unitsList'+unitsList);
        system.debug('leadId'+leadId);
        List<String> projectIds = new List<String>();
        map<id,Project__c> projectmapByid = new map<id,Project__c> ();
        
        for(unit__c unit : unitsList){
            projectIds.add(unit.Project__c);
        }
        List<Project__c> projectlist = [select id , Project_Lat__c,Project_Lat__Latitude__s,Project_Lat__Longitude__s from Project__c];
        
        for(Project__c prj : projectlist){
            projectmapByid.put(prj.Id, prj);
        }
        
        List<visit__c> visitList = new list<visit__c>();
        //list<Visit_Item__c> visitItemListTobeInsert = new list<Visit_Item__c>();
        
        Lead ld = [SELECT Id,Budget_Score__c,Carpet_Area__c,Demo_Date__c FROM Lead where id = :leadId];
        
        for(unit__c unit : unitsList){
            Visit__c visit = new Visit__c();
            visit.Project__c  = unit.Project__c;
            visit.Lead__c = leadId;
            visit.Actual_visit_date__c = system.today();
            visit.CheckIn__Latitude__s = projectmapByid.get(unit.Project__c).Project_Lat__Latitude__s;
            visit.CheckIn__Longitude__s = projectmapByid.get(unit.Project__c).Project_Lat__Longitude__s;
            visit.Assigned_User__c = userinfo.getUserId();
            visit.Account__c = '001N0000028BM4xIAG';
            if(ld.Demo_Date__c != null){
                visit.Planned_visit_date__c = system.today();    
            }else{
                visit.Planned_visit_date__c = system.today();
            }
            visitList.add(visit);
        }
        
        if(visitList.size() > 0){
            insert  visitList;    
        }
        
        system.debug('visitList'+visitList);
    }
    
    public static void approveRecord(String dealId)
    {
        
        Approval.ProcessSubmitRequest  req = new Approval.ProcessSubmitRequest ();
        req.setComments('Kindly Approve this Request to update Unit Allocation.');
        req.setObjectId(dealId);
        req.setNextApproverIds(new Id[] {userinfo.getUserId()});
        //req.setWorkitemId(dealId);
        // Submit the request for approval
        Approval.ProcessResult result =  Approval.process(req);
        
    }
}