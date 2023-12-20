({
	getAllInvoices : function(component, event) {
        var action = component.get("c.getAllInvoicesCount");
        debugger;
         var accId = component.get("v.accIdForChild");
        action.setParams({
            "accountId" : accId
        });
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                component.set("v.accRecord", result.accRec);
                
                component.set("v.CasePending", result.CasePending);
                component.set("v.CaseRaised", result.caseRaised);
                component.set("v.CaseResolved", result.CaseRessolved);
                
                component.set("v.InvoicesPending", result.orderTotalInvoicepending);
                component.set("v.InvoicesPaid", result.orderTotalInvoicePaid);
                component.set("v.TotalInvoices", result.orderTotalInvoice);
                
                component.set("v.TotalTargetOrders", result.orderTargetSet);
                component.set("v.TargetOrdersAcheived", result.orderTargetAchieved);
                component.set("v.TargetOrdersPending", result.ordeTargetPending);
                
                component.set("v.TotalTargetSet", result.yearlyTargetSet);
                component.set("v.TargetAcheived", result.yearlyTargetAchieved);
                component.set("v.TargetPending", result.yearlyTargetPending);
            }
        });
        $A.enqueueAction(action);
    }
})