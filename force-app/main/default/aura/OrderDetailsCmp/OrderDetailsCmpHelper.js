({
	getStageNameHelper : function(component, event, helper) {        
        var action =   component.get("c.statusNamePath");         
         action.setParams({
         "recordId":component.get("v.recordId")
         });
         action.setCallback(this, function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
                var result = response.getReturnValue();
                component.set('v.recordId', result.Id);
            }
        });        
 
        $A.enqueueAction(action); 
    },
})