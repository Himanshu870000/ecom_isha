({
    doInit : function(component, event, helper) {
        var action = component.get("c.getRecommendedAccounts");
        action.setParams({
        });
        action.setCallback(this, function(response){
            if(response.getState() === "SUCCESS"){
                var result = response.getReturnValue();
                component.set('v.data', result);  
            }
        });
        $A.enqueueAction(action);
    }
})