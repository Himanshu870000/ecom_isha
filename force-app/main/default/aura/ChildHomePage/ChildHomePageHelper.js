({
	  getPicklistValues: function(component, event) {
          debugger;
        var action = component.get("c.getEvents");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                
                /*var eventMap = [];
                for(var key in result){
                    eventMap.push({key: key, value: result[key]});
                }*/
             
              //  var data = JSON.stringify(result);
              //  component.set("v.EventPicklist", JSON.stringify(result));
                 component.set("v.EventPicklist", result);
            }
        });
        $A.enqueueAction(action);
      } 
    
})