public class TaskTriggerHelper {
    public static void updateLineItemStatus(Map<Id, Task> newTaskMap, map<Id, Task> oldTaskMap){
        try{
            Set<Id> actionLineItemIdCompleted = new Set<Id>();
            Set<Id> actionLineItemIdInProgress = new Set<Id>();
            List<Action_Plan_Line_Item__c> lineItemListToBeUpdated = new List<Action_Plan_Line_Item__c>();
            Map<ID, List<Action_Plan_Line_Item__c>> allActionPlanItemsByLead = new Map<ID, List<Action_Plan_Line_Item__c>>(); 
            Set<Id> allLeadIds = new Set<Id>();
            Set<Id> graphyLeadIds = new Set<Id>();
            set<id> opportunityIds = new Set<id>();
            List<Opportunity> oppListToUPdate = new List<Opportunity>();
            List<Lead> leadListToUPdate = new List<Lead>();
            
            for(Task taskRec : newTaskMap.values()){
                if(taskRec.subject == 'Send Marketing Brochure' && taskRec.Status != oldTaskMap.get(taskRec.Id).Status &&  taskRec.Status == 'Completed'){
                    opportunityIds.add(taskRec.WhatId);
                }
                 if(taskRec.subject.contains('Demo Scheduled With') && taskRec.Status != oldTaskMap.get(taskRec.Id).Status &&  taskRec.Status == 'Completed'){
                    graphyLeadIds.add(taskRec.WHOID);
                }
                allLeadIds.add(taskRec.WhoId);
            }
            //Graphy
            if(!graphyLeadIds.isEmpty()){
                for(id leadId : graphyLeadIds){
                    Lead leadRec = new Lead();
                    leadRec.Id = leadId;
                    leadRec.Status = 'Product Demo Conducted';
                    leadListToUPdate.add(leadRec);
                }
                if(!leadListToUPdate.isEmpty()){
                    update leadListToUPdate;
                }
            }
            //Xseed
            if(!opportunityIds.isEmpty()){
                for(Id oppId : opportunityIds){
                    Opportunity oppRec = new Opportunity();
                    oppRec.id = oppId;
                    oppRec.StageName = 'Value Proposition';
                    oppListToUPdate.add(oppRec);                    
                }
                if(!oppListToUPdate.isEmpty()){
                    update oppListToUPdate;
                }
            }
            system.debug('allLeadIds::'+allLeadIds);
            if(!allLeadIds.isEmpty()){
                Map<ID, Action_Plan__c> allActionPlan = new Map<ID, Action_Plan__c>([SELECT Id, Name,Lead__c,(Select id,Name,Subject__c,Status__c from Action_Plan_Line_Items__r) FROM Action_Plan__c where Lead__c IN:allLeadIds]);
                system.debug('allActionPlan::'+allActionPlan);
                for(Action_Plan__c ap:allActionPlan.values()){
                    allActionPlanItemsByLead.put(ap.Lead__c,ap.Action_Plan_Line_Items__r);
                }
            }
            system.debug('allActionPlanItemsByLead::'+allActionPlanItemsByLead);
            system.debug('newTaskMap::'+newTaskMap);
            for(Task taskRec : newTaskMap.values()){
                if(taskRec.Status == 'Completed'){
                    system.debug('allActionPlanItemsByLead.containsKey(taskRec.WhoId)::'+allActionPlanItemsByLead.containsKey(taskRec.WhoId));
                    if(allActionPlanItemsByLead.containsKey(taskRec.WhoId)){
                        List<Action_Plan_Line_Item__c> allActionPlanforLead = allActionPlanItemsByLead.get(taskRec.WhoId);
                        system.debug('allActionPlanforLead::'+allActionPlanforLead);
                        if(!allActionPlanforLead.isEmpty()){
                            for(Action_Plan_Line_Item__c apl : allActionPlanforLead){
                                system.debug('taskRec.Subject::'+taskRec.Subject);
                                system.debug('apl.Subject__c::'+apl.Subject__c);
                                if(taskRec.Subject == apl.Subject__c){
                                    lineItemListToBeUpdated.add(apl);
                                }
                            } 
                        }
                    }                    
                }
            }
          	system.debug('lineItemListToBeUpdated::'+lineItemListToBeUpdated);
            if(!lineItemListToBeUpdated.isEmpty()){
                for(Action_Plan_Line_Item__c aplRec : lineItemListToBeUpdated){
                    aplRec.Status__c = 'Completed';
                }
                update lineItemListToBeUpdated;
            }
        }catch(exception ex){
            system.debug('Error==>'+ex.getMessage()+'Error@==>'+ex.getLineNumber());
        }
    }
     public static void afterinsert(List<Task> newTaskList){
        try{
            //Update Lead status as contacted after call is made and lead status is New
            
            Set<Id> leadIdsToBeMarkedAsContacted = new Set<Id>();
             List<Lead> existingLead = new List<Lead>();
            List<Lead> leadListoTUpdate = new List<Lead>();
            
            for(Task taskRec : newTaskList){
                if(taskRec.Subject == 'Outgoing' || taskRec.Subject == 'Call'){
                    leadIdsToBeMarkedAsContacted.add(taskRec.WhoId);
                }
            }
            if(!leadIdsToBeMarkedAsContacted.isEmpty()){
                existingLead = [Select Id,Status from Lead where Id in: leadIdsToBeMarkedAsContacted and Status = 'New'];
                if(!existingLead.isEmpty()){
                    for(Lead leadRec : existingLead){
                        Lead leadRecToUpdate = new Lead();
                        leadRecToUpdate.Id = leadRec.id;
                        leadRecToUpdate.Status = 'Contacted';
                        leadListoTUpdate.add(leadRecToUpdate);
                    }
                    if(!leadListoTUpdate.isEmpty()){
                        update leadListoTUpdate;
                    }
                }
            }
            
                
        }catch(exception ex){
            system.debug('Error==>'+ex.getMessage()+'Error@==>'+ex.getLineNumber());
        }
    }
    
    public static void createtaskforFinanceTeam(List<Task> TaskList,Map<Id,Task> mapofoldTaskList){
        List<Task> taskListTobeInsert = new List<Task>();
        for(Task tsk : TaskList){
            if(tsk.subject != null && tsk.subject.contains('quality check') && tsk.Status != mapofoldTaskList.get(tsk.Id).Status && tsk.Status == 'Completed'){
                Task ts = new task();
                ts.whatId = tsk.WhatId;
                ts.ActivityDate = system.today().addDays(5);
                ts.subject = 'Finance : Release Due Amount';
                taskListTobeInsert.add(ts);
            }
        }
        
        if(!taskListTobeInsert.isEmpty()){
            insert taskListTobeInsert;        }
    }
}