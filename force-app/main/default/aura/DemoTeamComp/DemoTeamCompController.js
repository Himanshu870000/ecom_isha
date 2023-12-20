({
    doInit : function(component, event, helper) {
        component.set("v.showModal",true);
        
        var action = component.get("c.taskForSalesTeam");
        action.setParams({
            leadId : component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log('>>>>> state'+ state );
            if (state === "SUCCESS") {           
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Success',
                    message: 'Email has been sent successfully!!',
                    duration:' 3000',
                    key: 'info_alt',
                    type: 'success',
                    mode: 'pester'
                });
                toastEvent.fire();
            }
        })
        $A.enqueueAction(action);
        

        window.setTimeout(
            $A.getCallback(function() {
                $A.get('e.force:refreshView').fire();
                component.set("v.showModal", false);
                var dismissActionPanel = $A.get("e.force:closeQuickAction");
                dismissActionPanel.fire()
            }), 3000
        );
    },
    
    hideModel: function(component, event, helper) {
        
        component.set("v.showModal", false);
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();

    },
})