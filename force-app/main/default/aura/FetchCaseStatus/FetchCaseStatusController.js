({
    doInit: function(component, event, helper) {
        var caseId = component.get("v.recordId");
        var action = component.get("c.getCaseData");
        action.setParams({
            "caseId": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
            }
            else if (state === "ERROR") {
                // Handle error response
            }
            var dismissActionPanel = $A.get("e.force:closeQuickAction");
            dismissActionPanel.fire();
            $A.get('e.force:refreshView').fire();
            
        });
        $A.enqueueAction(action);
    }
})