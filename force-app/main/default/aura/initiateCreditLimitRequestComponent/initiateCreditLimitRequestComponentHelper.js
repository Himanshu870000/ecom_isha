({
		showMessage : function(message,isSuccess) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": isSuccess?"Success!":"Error!",
            "type":isSuccess?"success":"error",
            "message": message
        });
        toastEvent.fire();
            
            var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
             $A.get('e.force:refreshView').fire();
    },
})