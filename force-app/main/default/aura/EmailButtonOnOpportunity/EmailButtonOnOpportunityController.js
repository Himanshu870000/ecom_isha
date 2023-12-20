({
    doInit : function(component, event, helper) {
        debugger;
        var action = component.get("c.sendEmail");
        var recID = component.get("v.recordId");
         action.setParams({
             "recordId":recID
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
              var dismissActionPanel = $A.get("e.force:closeQuickAction");
              dismissActionPanel.fire();                
            }         
        });
        $A.enqueueAction(action);
    }
})