({
	FetchEMIDetails : function(component, event, helper) {
        
        debugger;
        var conId = component.get('v.recordId');
        var action = component.get('c.emiScheduleDetails');    				//call apex class method
        
        action.setParams({
            'conId' : component.get('v.recordId')
        });
        
        action.setCallback(this, function(response) { 							//store state of response
            
            debugger;
            var state = response.getState();
            debugger;
            if (state === "SUCCESS") {
                component.set('v.AllEMIDetails', response.getReturnValue());     	//set response value in wrapperList attribute on component.
            }
        });
        $A.enqueueAction(action);
    }
})