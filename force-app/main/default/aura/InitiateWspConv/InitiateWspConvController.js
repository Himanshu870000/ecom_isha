({
    doInit : function(component, event, helper) {
        debugger;
        var action = component.get("c.startConversation");
        action.setParams({
            "recordId": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var serverResponse = response.getReturnValue();
            var Url = 'https://web.whatsapp.com/send?phone='+serverResponse.Whatsapp__c+'&amp;text='+serverResponse.Predefined_Message__c;
            window.open(Url);
            var dismissActionPanel = $A.get("e.force:closeQuickAction");
            dismissActionPanel.fire();
        });
        $A.enqueueAction(action);
    },
})