trigger ContentTrigger on Content__c (after insert, after update) {
	//Call Hander Class
    if(Trigger.isInsert && Trigger.isAfter){
    	ContentTriggerHandler.afterInsert(Trigger.new);  
    }
    if(Trigger.isUpdate && Trigger.isAfter){
    	ContentTriggerHandler.afterUpdate(Trigger.new, Trigger.oldMap);   
    }
}