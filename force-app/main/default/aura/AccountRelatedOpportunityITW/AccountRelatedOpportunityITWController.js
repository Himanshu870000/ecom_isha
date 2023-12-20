({
    doaction : function(component, event, helper) {
        debugger;
        var action = component.get("c.getOppData");
        action.setParams({
            recId : component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            if(response.getState() === "SUCCESS"){
                var data = response.getReturnValue();
              	component.set("v.totalOppCount",data.TotalOpportunityCount);
                component.set("v.newOppCount",data.NewStageOpportunityCount);
                component.set("v.underOppCount",data.UnderPaymentOpportunityCount);
                component.set("v.closedOppCount",data.ClosedWonOpportunityCount);
                component.set("v.caseCount",data.TotalCaseCount);
            }
        });
        $A.enqueueAction(action);
    },
    
  
})