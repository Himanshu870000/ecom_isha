({
    onPageReferenceChange: function (cmp, evt, helper) {
        debugger;
        var myPageRef = cmp.get("v.pageReference");
        var label = $A.get("$Label.c.listViewId");
        var Tasks = myPageRef.state.c__listofTasks;
        helper.GetAssignmentgroup(cmp, evt);
        if(Tasks.length < 0 || Tasks.length == ""){
            helper.showWarning(cmp, evt);
            var navEvent = $A.get("e.force:navigateToList");
            navEvent.setParams({
                "listViewId": label,
                "listViewName": "All Tasks",
                "scope": "Task"
            });
            navEvent.fire();
        }
        else{
            var TasksArr = Tasks.split(',');
            cmp.set("v.ListofTasks", TasksArr);
            cmp.set("v.isModalOpen", true);
        }
    },
    
    closeModel: function (component, event, helper) { 
        component.set("v.isModalOpen", false);
        var TaskListView = component.get("v.AllTaskListview");
        component.set("v.isModalOpen", false);
        var navEvent = $A.get("e.force:navigateToList");
        navEvent.setParams({
            "listViewId": TaskListView.Id,
            "listViewName": TaskListView.Name,
            "scope": "Task"
        });
        navEvent.fire();
    },
    
    submitDetails: function (component, event, helper) {
        debugger;
        var selectedAssignGroupForJs = component.get("v.SelectedAssignGroup");
        var leadlist = component.get("v.ListofTasks");
        var leadSize = leadlist.length;
        if(leadlist.length == 1 && leadlist[0] == ""){
            var TaskListView = component.get("v.AllTaskListview");
            component.set("v.isModalOpen", false);
            var navEvent = $A.get("e.force:navigateToList");
            navEvent.setParams({
                "listViewId": TaskListView.Id,
                "listViewName": TaskListView.Name,
                "scope": "Task"
            });
            navEvent.fire();
        }
        else{
            var action = component.get('c.TransferTask');
            action.setParams({
                TaskListId: leadlist,
                SelectedAssignUserGroup: selectedAssignGroupForJs
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var serverResponse = response.getReturnValue();
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'SUCCESS',
                        message: 'Task Assigned Successfully to Selected User',
                        duration:' 5000',
                        key: 'info_alt',
                        type: 'success',
                        mode: 'pester'
                    });
                    toastEvent.fire();
                    
                    var TaskListView = component.get("v.AllTaskListview");
                    component.set("v.isModalOpen", false);
                    var navEvent = $A.get("e.force:navigateToList");
                    navEvent.setParams({
                        "listViewId": TaskListView.Id,
                        "listViewName": TaskListView.Name,
                        "scope": "Task"
                    });
                    navEvent.fire();
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
            
        }
    },
    
    
})