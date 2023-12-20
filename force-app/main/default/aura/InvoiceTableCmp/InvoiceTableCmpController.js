({
	doInit : function(component, event, helper) {
        var accId = component.get("v.accIdForChild");
		helper.getInvoices(component, event);
	},
    handleNext : function(component, event, helper) { 
        var pageNumber = component.get("v.pageNumber");
        component.set("v.pageNumber", pageNumber+1);
        helper.getInvoices(component, helper);
    },
     
    handlePrev : function(component, event, helper) {        
        var pageNumber = component.get("v.pageNumber");
        component.set("v.pageNumber", pageNumber-1);
        helper.getInvoices(component, helper);
    },
})