// ImageDisplayController.js
({
    init: function(component, event, helper) {
        var recordId = component.get("v.recordId");
        
        // Fetch the record data
        var action = component.get("c.getRecordData");
        action.setParams({ 
            recordId: recordId 
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var record = response.getReturnValue();
                component.set("v.record", record);
                component.set("v.imageUrl",record.ImageURL__c);
            }
        });
        
        $A.enqueueAction(action);
    }
})