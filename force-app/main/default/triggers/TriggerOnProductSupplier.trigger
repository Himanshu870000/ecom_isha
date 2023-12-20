trigger TriggerOnProductSupplier on Product_Supplier__c (after update) {
    if(trigger.isUpdate && trigger.isAfter){
        ProductSupplierHandler.tagFinalVendor(trigger.new,trigger.oldMap);
    }
}