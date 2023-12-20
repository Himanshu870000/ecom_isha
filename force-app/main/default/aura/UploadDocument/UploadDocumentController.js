({
    doInit: function (component, event, helper) {

        debugger;
        component.set("v.showSpinner", true);
        var currentRecId = component.get('v.recordId');
        var action = component.get('c.SendEmail');
        
        action.setParams({
            "accId": currentRecId
        });
        action.setCallback(this, function (response) {
            var state = response.getState(); // get the response state
            if (state == 'SUCCESS') {
                var serverResponse = response.getReturnValue();

                //if (serverResponse == 'Events Details processing is in Progress! Recording Processing is also In progress!' || serverResponse == null || serverResponse == 'Event Record not found!Events Details processing is in Progress! Recording Processing is also In progress!') {
                    
                    $A.get("e.force:closeQuickAction").fire();
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title: 'Success',
                        message: 'Upload Document Email has been send successfully!!',
                        duration: ' 5000',
                        key: 'info_alt',
                        type: 'success',
                        mode: 'pester'
                    });
                    toastEvent.fire();
                    component.set("v.showSpinner", false);
                    $A.get('e.force:refreshView').fire();
                //}
            }
        });
        $A.enqueueAction(action);
    }
})