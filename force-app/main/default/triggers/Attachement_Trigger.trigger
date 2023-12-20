trigger Attachement_Trigger on Attachment (after insert) {
    
    if(Trigger.isinsert && Trigger.isafter){
        
        Attachement_Trigger_Helper.HandleAttachements(Trigger.new);
    }
    
}