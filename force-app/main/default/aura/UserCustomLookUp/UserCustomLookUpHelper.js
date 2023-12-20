({
    searchHelper : function(component,event,getInputkeyWord) {
        debugger;
        var OBjName = component.get("v.SearchKeyWord");
        var ObjApiName = component.get("v.objectAPIName");
        // call the apex class method 
        var action = component.get("c.userList");
        
        // set param to method  
        action.setParams({
            'searchKeyWord': OBjName,
            'ObjectName'   : ObjApiName
        });
        
        // set a callBack    
        action.setCallback(this, function(response) {
            $A.util.removeClass(component.find("mySpinner"), "slds-show");
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                // if storeResponse size is equal 0 ,display No Result Found... message on screen.                }
                if (storeResponse.length == 0) {
                    component.set("v.Message", 'No Result Found...');
                } else {
                    component.set("v.Message", '');
                }
                // set searchResult list with return value from server.
                component.set("v.listOfSearchRecords", storeResponse);
            }
            
        });
        // enqueue the Action  
        $A.enqueueAction(action);
    },
})