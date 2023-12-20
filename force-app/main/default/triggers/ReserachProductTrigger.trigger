trigger ReserachProductTrigger on Research_Product__c (after update) {
    
    ReserachProductTriggerHelper helperInstance = ReserachProductTriggerHelper.getInstance();
    
	if(trigger.isAfter && trigger.isUpdate){
        helperInstance.convertToProduct(trigger.new);
    }
}