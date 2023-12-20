({
	doInit : function(component, event, helper) {
		debugger;
        var action=component.get('c.sendProfitabilityReport');
        action.setParams({
            recordId : component.get('v.recordId')
        });
        action.setCallback(this, function(response){
            if(response.getState() === 'SUCCESS'){
                if(response.getReturnValue() == 'Success'){
                    component.set('v.isSent', true);
                    component.set('v.notSent', false);
                    
                }
                if(response.getReturnValue() == 'Error'){
                    component.set('v.isSent', false);
                    component.set('v.notSent', true);
                }
            } 
        });
        $A.enqueueAction(action);
	}
})