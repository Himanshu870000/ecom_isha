({
	doInit : function(component, event, helper) {
        debugger;
		var action = component.get("c.sendEmail");
        action.setParams({
             "recordId": component.get('v.recordId')
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
              var dismissActionPanel = $A.get("e.force:closeQuickAction");
              dismissActionPanel.fire();                
            }  else if(state === "ERROR"){
                var errors = action.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        alert(errors[0].message);
                    }
                }
            }else if (status === "INCOMPLETE") {
                alert('No response from server or client is offline.');
            }        
        });
        $A.enqueueAction(action);
    }
})