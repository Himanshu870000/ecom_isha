trigger OpportunityTrigger on Opportunity (before insert,after insert,after update,before update) {
    system.debug('Opportunity trigger');
    
    if(Trigger.isInsert && Trigger.isBefore){
        OpportunityTriggerHelper.SetWareHouseByDefault(Trigger.new);
    }
    if(trigger.isUpdate && Trigger.isAfter){
        OpportunityTriggerHelper.createProjectOnClosedWon(trigger.new);
      
    }
    if(trigger.isInsert && Trigger.isAfter){
         OpportunityTriggerHelper.createFolderforOpp(trigger.new);
    }
    
    /*if(trigger.isInsert && Trigger.isAfter){
        OpportunityTriggerHelper.createTaskBasedOnOpportunityStageForITW(Trigger.new,Trigger.oldMap);
        OpportunityTriggerHelper.createFolders(Trigger.newMap);
        AttachPitchDeck.updateContentDoc(trigger.newMap);
    }
    if(trigger.isUpdate && trigger.isBefore){
       OpportunityTriggerHelper.changeStageToFinanceLegal(Trigger.new,Trigger.OldMap); 
    }
    if(trigger.isUpdate && Trigger.isAfter){
        OpportunityTriggerHelper.createTaskBasedOnOpportunityStageForITW(Trigger.new,Trigger.oldMap);
        OpportunityTriggerHelper.closeProposalSharedTaskOnStageChange(Trigger.new,Trigger.oldMap);
        OpportunityTriggerHelper.closeClientRequirementTaskOnStageChange(Trigger.new,Trigger.oldMap);
        OpportunityTriggerHelper.closeFinalBrandDeckTaskOnStageChange(Trigger.new,Trigger.oldMap);
        OpportunityTriggerHelper.closeFinanceLegalAssignmentTaskOnStageChange(Trigger.new,Trigger.oldMap);
        OpportunityTriggerHelper.calculateAchieveTargetOnClosedWon(Trigger.new,Trigger.oldMap);
        OpportunityTriggerHelper.sendEmailOnProposalReview(Trigger.new,Trigger.oldMap);
    }
    
    if(trigger.isInsert && trigger.isAfter){
        //OpportunityTriggerHelper.tagInvoiceRecord(trigger.new);
    }
   /* if(trigger.isUpdate && trigger.isAfter){
        system.debug('Afyter Update');
        OpportunityTriggerHelper.closedWonOpportunity(trigger.new,trigger.oldMap);
        
        Set<Id> pickupOrder = new Set<Id>();
        Set<Id> dropOrder = new Set<Id>();
        for(Opportunity opp : Trigger.newMap.values()){
            if(opp.StageName == 'Awaiting Pickup' && Trigger.oldMap.get(opp.Id).StageName!='Awaiting Pickup'){
                pickupOrder.add(opp.Id);
            }
            if(opp.StageName == 'DISPATCHED' && Trigger.oldMap.get(opp.Id).StageName!='DISPATCHED'){
                dropOrder.add(opp.Id);
            }
        }
        
        if(!pickupOrder.isEmpty()){
            OpportunityTriggerHelper.syncOppToVisitServer(pickupOrder,'Pickup');
        }
        if(!dropOrder.isEmpty()){
            OpportunityTriggerHelper.syncOppToVisitServer(dropOrder,'Drop');
        }
        
        
    }*/
    
    
}