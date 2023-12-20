({
    doInit : function(component, event, helper) {
        debugger;
        var action = component.get("c.getBoardsName");
          action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.BoardList", response.getReturnValue());
                  helper.getPicklistValues(component, event);
            }
        });
        $A.enqueueAction(action);
     }
  
   /* handleClick : function(component, event, helper) {
        debugger;
        component.set("v.Dispatched", !component.get("v.Dispatched"));
        
       		
	},
    handleClickA : function(component, event, helper) {
        debugger;
         component.set("v.Dispatched1", !component.get("v.Dispatched1"));
        
	},
   /*  handleClickB : function(component, event, helper) {
        debugger;
         component.set("v.Dispatched2", !component.get("v.Dispatched2"));
        
	},
     handleClickC : function(component, event, helper) {
        debugger;
         component.set("v.Dispatche3", !component.get("v.Dispatched3"));
        
	}*/
})