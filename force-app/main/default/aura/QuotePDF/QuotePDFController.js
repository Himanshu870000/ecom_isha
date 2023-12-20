({
    handleSave: function(component, event, helper) {
        debugger;
        var action = component.get("c.savePDF");
        action.setParams
        ({ 
            "recordId": component.get("v.recordId"),
           
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === 'SUCCESS') {
                var storeResponse = response.getReturnValue();
                console.log("SUCCESS RESULT: ", storeResponse);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Success',
                    message: 'Quote PDF Saved Successfully',
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'success',
                    mode: 'pester'
                });
                toastEvent.fire();
                var dismissActionPanel = $A.get("e.force:closeQuickAction");
                dismissActionPanel.fire();
            }
            else if(state ==='ERROR') {
                var errors= response.getError();
                console.log("Save ERROR: ", errors);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Save Error',
                    message: errors[0].message,
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'error',
                    mode: 'sticky'
                });
                toastEvent.fire();
                var dismissActionPanel = $A.get("e.force:closeQuickAction");
                dismissActionPanel.fire();
            }
        }, 'ALL' );
        $A.enqueueAction(action);
    }, 
})