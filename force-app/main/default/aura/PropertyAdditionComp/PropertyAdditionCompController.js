({
    openModel: function(component, event, helper) {
        component.set("v.selectProjectDisplay", true);
    },
    
    closeModel: function(component, event, helper) {
        component.set("v.selectProjectDisplay", false);
    },
    submitDetails: function(component, event, helper) {
        debugger;
        var roomType = component.get("v.selectedRoomType");
        var conId = component.get("v.recordId");
        var sharingType = component.get("v.selectedSharingType");
        var acNeeded = component.get("v.isAcRequired");
        var Blocks = [];
        var action = component.get("c.getavailableHostelRooms");
        action.setParams({
            roomType : roomType,
            studentId : conId,
            sharingType : sharingType,
            acNeeded : acNeeded
        });
        action.setCallback(this, function(response) {
            console.log();
            var toastEvent = $A.get("e.force:showToast");
            var response = response.getReturnValue();
            /*for (let i = 0; i < response.length; i++) {
                Blocks.push(response[i]);
            }*/
            
            component.set("v.Blocks",response);
            
            toastEvent.setParams({
                "title": "Success!",
                "message": "Your Results have been Updated."
            });
            toastEvent.fire();
            component.set("v.displayResult", true);
        });
        $A.enqueueAction(action);
    },
})