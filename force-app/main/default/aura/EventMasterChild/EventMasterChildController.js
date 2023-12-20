({
	 doInit : function(component, event, helper) {
        debugger;
        var action = component.get("c.getEventMasters");
          action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.EventList", response.getReturnValue());
            } 
              /*var result = response.getReturnValue();
                var data = JSON.stringify(result);
                component.set("v.EventList", data);*/
              
        });
        $A.enqueueAction(action);
     }
})