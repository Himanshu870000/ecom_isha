({
	doInit : function(component, event, helper) {
        var accId = component.get("v.accIdForChild");
		helper.getDealerProducts(component, event);
	},
    
    handleNext : function(component, event, helper) { 
        var pageNumber = component.get("v.pageNumber");
        component.set("v.pageNumber", pageNumber+1);
        helper.getDealerProducts(component, helper);
    },
     
    handlePrev : function(component, event, helper) {        
        var pageNumber = component.get("v.pageNumber");
        component.set("v.pageNumber", pageNumber-1);
        helper.getDealerProducts(component, helper);
    },
    
    
    childComponentEvent : function(component, event,helper) { 
        debugger;
        //Get the event using registerEvent name. 
        var cmpEvent = component.getEvent("sampleCmpEvent"); 
        //Set event attribute value
        cmpEvent.setParams({"message" : "Welcome "}); 
        cmpEvent.fire(); 
    }
})