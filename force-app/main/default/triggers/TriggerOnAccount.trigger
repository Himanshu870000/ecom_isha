trigger TriggerOnAccount on Account (after insert, before insert) {
    AccountTriggerHandler accHandler = AccountTriggerHandler.getInstance();
    
    if(trigger.isInsert && Trigger.isAfter){
        accHandler.afterInsert(Trigger.newMap);
    }
    
    if(trigger.isInsert && Trigger.isBefore){
        //accHandler.CreateDocumentCategories(Trigger.new);
        accHandler.fillNeccesaryDetailsForFSL(Trigger.new);
    }
}