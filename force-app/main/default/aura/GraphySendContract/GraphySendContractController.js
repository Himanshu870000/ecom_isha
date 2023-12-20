({
    sendEmail : function(component, event, helper) {
        debugger;
        var action = component.get("c.attachPdf");
        action.setParams({
            recordId : component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {  
               var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Success',
                    message: 'Contract has been shared',
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'success',
                    mode: 'pester'
                });
                toastEvent.fire();
                $A.get("e.force:closeQuickAction").fire();
            } 
            $A.get('e.force:refreshView').fire();
            $A.get("e.force:closeQuickAction").fire();
            

        });
        
        $A.enqueueAction(action);
    }
})