({
	 insertVendorRequest : function(component, event, deleteRecordsIds) {
		debugger;
        var action = component.get("c.insertSelectedVendorRequest");
        action.setParams({
            AccountIdList : deleteRecordsIds,
            ProductRequestId : component.get("v.recordId ")
        });
        action.setCallback(this, function(response){
            if(response.getState() === "SUCCESS"){
                var data = response.getReturnValue();
                if(data !=null){
                     var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Success',
                        message: 'Vendor Request Record Created Successfully !',
                        duration:' 5000',
                        key: 'info_alt',
                        type: 'success',
                        mode: 'pester'
                    });
                    toastEvent.fire();
                    var dismissActionPanel = $A.get("e.force:closeQuickAction");
                    dismissActionPanel.fire();
                    var spinner=component.get("v.show");
                    component.set("v.show",false);
                }
            }
        });
        $A.enqueueAction(action);
	},
    
})