({
	 callApexMethod: function(component, caseId) {
        var action = component.get("c.getCaseData");
        action.setParams({
            "caseId": caseId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                // Handle successful response
            }
            else if (state === "ERROR") {
                // Handle error response
            }
            var dismissActionPanel = $A.get("e.force:closeQuickAction");
            dismissActionPanel.fire();
        });
        $A.enqueueAction(action);
    }
})