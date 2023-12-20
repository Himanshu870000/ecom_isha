({
	doInit : function(component, event, helper) {
        debugger;
		var action = component.get('c.getRecCreditLimits');
        action.setParams({
            recordId : component.get('v.recordId')
        });
        action.setCallback(this, function(response){
            if(response.getState() === 'SUCCESS'){
                var amount = response.getReturnValue();
                if(amount == null || amount == undefined){
                    helper.showMessage('Please Specify Recommended Credit Limit First!', false);
                }else{
                    helper.showMessage('Credit Limit Allocation Request Submitted Successfully for INR ' + amount, true );
                }
            } 
        });
        $A.enqueueAction(action);
	}
})