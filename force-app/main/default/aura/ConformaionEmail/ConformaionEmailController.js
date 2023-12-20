({
	apexExecute : function(component, event, helper) {
            //Call Your Apex Controller Method.
            var action = component.get("c.sendEmailForConformation");
            action.setParams({
                'recordId':component.get('v.recordId')
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                    if (state === "SUCCESS") {
                        //after code
                        response.getReturnValue();

                        $A.get("e.force:closeQuickAction").fire();
                    } 
            });
            
            $A.enqueueAction(action);
	}
})