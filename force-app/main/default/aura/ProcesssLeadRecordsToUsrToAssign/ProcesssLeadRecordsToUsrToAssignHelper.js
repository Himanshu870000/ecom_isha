({
    GetAssignmentgroup: function (cmp, evt) {
        debugger;
        var action = cmp.get('c.QueryAssignmentGroup');
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var serverResponse = response.getReturnValue();
                var AssignGroupmap = [];
                for(var key in serverResponse.AssignGroupMapWrap){
                    AssignGroupmap.push({key: key, value: serverResponse.AssignGroupMapWrap[key].Name});
                }
                cmp.set("v.AssignGroupList", AssignGroupmap);
                cmp.set("v.AllTaskListview", serverResponse.AllTasklistview);
            }
            else if (state === "INCOMPLETE") {
                
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " +
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });
        
        $A.enqueueAction(action);
    },
    
    showWarning : function(component, event) {
        debugger;
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Warning',
            message: 'Please Select Task Records ',
            duration:' 5000',
            key: 'info_alt',
            type: 'warning',
            mode: 'sticky'
        });
        toastEvent.fire();
    },	
})