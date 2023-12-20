({
    getTowers: function(component, event, helper) {
        debugger;
        var blockId = event.target.Id;
        var recId = event.currentTarget.dataset.id;
        var conId = component.get("v.recordId");
        
        var Towers = [];
        
        var action = component.get("c.getavailableTowers");
        action.setParams({
            BlockId : recId,
        });
        action.setCallback(this, function(response) {
            console.log();
            var toastEvent = $A.get("e.force:showToast");
            var response = response.getReturnValue();
            component.set("v.Towers",response);
            toastEvent.setParams({
                "title": "Success!",
                "message": "Available Towers for this block are updated!!"
            });
            toastEvent.fire();
            //component.set("v.displayResult", true);
        });
        $A.enqueueAction(action);
    },
    getFloors: function(component, event, helper) {
        debugger;
        var towerId = event.target.Id;
        var recId = event.currentTarget.dataset.id;
        var conId = component.get("v.recordId");
        
        var Floors = [];
        
        var action = component.get("c.getavailableFloors");
        action.setParams({
            TowerId : recId,
        });
        action.setCallback(this, function(response) {
            console.log();
            var toastEvent = $A.get("e.force:showToast");
            var response = response.getReturnValue();
            component.set("v.Floors",response);
            toastEvent.setParams({
                "title": "Success!",
                "message": "Available Floors for this block are updated!!"
            });
            toastEvent.fire();
        });
        $A.enqueueAction(action);
    },
    getRooms: function(component, event, helper) {
        debugger;
        var towerId = event.target.Id;
        var recId = event.currentTarget.dataset.id;
        var conId = component.get("v.recordId");
        
        var Floors = [];
        
        var action = component.get("c.getavailableRooms");
        action.setParams({
            FloorId : recId,
        });
        action.setCallback(this, function(response) {
            console.log();
            var toastEvent = $A.get("e.force:showToast");
            var response = response.getReturnValue();
            component.set("v.rooms",response);
            toastEvent.setParams({
                "title": "Success!",
                "message": "Available Rooms for this floor are updated!!"
            });
            toastEvent.fire();
        });
        $A.enqueueAction(action);
    },
    bookRoom: function(component, event, helper) {
        debugger;
       
        var recId = event.currentTarget.dataset.id;
        var conId = component.get("v.recordId");
        
        var action = component.get("c.bookavailableRooms");
        action.setParams({
            studentId : conId,
            roomId : recId
        });
        action.setCallback(this, function(response) {
            console.log();
            var toastEvent = $A.get("e.force:showToast");
            var response = response.getReturnValue();
            toastEvent.setParams({
                "title": "Success!",
                "message": response
            });
            toastEvent.fire();
        });
        $A.enqueueAction(action);
        component.set("v.selectProjectDisplay",false);
        component.set("v.selectedProject",false);
    },
})