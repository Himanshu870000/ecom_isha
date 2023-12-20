({
	doInit : function(component, event, helper){
        debugger;
        var action = component.get("c.getInvestmentRecords");
        action.setCallback(this, function(response){
            var state = response.getState();
            var storeResponse = response.getReturnValue();
            console.log("SUCCESS RESULT: ", storeResponse);
            if(state === 'SUCCESS') {
                component.set("v.investmentList", storeResponse);
            }
        }, 'ALL' );
        $A.enqueueAction(action);
    },
})