({
    
    handleComponentEvent : function(component, event, helper) {
        debugger;
        // get the selected Account record from the COMPONETN event 	 
        var selectedUserGetFromEvent = event.getParam("recordByEvent");
        component.set("v.SelectedBDA", selectedUserGetFromEvent);

    },
    FetchBDAAllActivityRecord : function(component, event, helper){
        debugger;
        helper.showSpinner(component);
        var BDASelectedID = component.get("v.SelectedBDA").Id; // 
        var selectedDate = component.get("v.selectedDate");
        
        var action = component.get("c.GetAllBDARecords");
        action.setParams({
            'UserId': BDASelectedID,
            'DateTobeQuery' : selectedDate
        });
        
        
        action.setCallback(this, function(response) {
            //$A.util.removeClass(component.find("mySpinner"), "slds-show");
            var state = response.getState();
            
            if (state === "SUCCESS") {
                helper.hideSpinner(component);
                var storeResponse = response.getReturnValue();
                // if storeResponse size is equal 0 ,display No Result Found... message on screen. }
                if (storeResponse.length == 0) {
                    component.set("v.Message", 'No Result Found...');
                    component.set("v.emptyWrapper", true);
                } else if(storeResponse.length > 0){
                    component.set("v.WrapperList", storeResponse);
                    component.set("v.emptyWrapper", false);
                }
                else{

                }
                // set searchResult list with return value from server.
                component.set("v.WrapperList", storeResponse);
            }
            
        });
        // enqueue the Action  
        $A.enqueueAction(action);
    }
})