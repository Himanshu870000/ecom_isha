({
	doInit : function(component,event,helper){
        debugger;
        var accId = component.get("v.accIdForChild");
        helper.getStageNameHelper(component, event, helper);    
    },
        
    handleNext : function(component, event, helper) { 
        debugger;
        var pageNumber = component.get("v.pageNumber");
        component.set("v.pageNumber", pageNumber+1);
        helper.getStageNameHelper(component, helper);
    },
     
    handlePrev : function(component, event, helper) {  
        debugger;
        var pageNumber = component.get("v.pageNumber");
        component.set("v.pageNumber", pageNumber-1);
        helper.getStageNameHelper(component, helper);
    },
    
    statusPicklistSelect : function(component,event,helper){
        debugger;
        var stepName = event.getParam("detail").value;
        alert('stepName'+stepName);
        component.set("v.statusField.Status",stepName);
        
        component.find("record").saveRecord($A.getCallback(function(response){
             if (response.state === "SUCCESS") {
                $A.get('e.force:refreshView').fire();
            }
        }));
    },
})