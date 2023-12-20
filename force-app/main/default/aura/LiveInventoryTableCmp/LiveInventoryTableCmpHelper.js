({
	getStoreInventory : function(component, event) {
        debugger;
		var action = component.get("c.getStoreInventoryList");
        action.setParams({
            'pageSize' : component.get("v.pageSize"),
            'pageNumber' : component.get("v.pageNumber"),
            'accountId' : component.get("v.accIdForChild")
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var result = response.getReturnValue();
                if(result.length < component.get("v.pageSize") || result.length == 0){
                    component.set("v.isLastPage", true);
                } else{
                    component.set("v.isLastPage", false);
                }
                component.set("v.dataSize", result.length);
                component.set("v.livInvList",result);
            }
        });
        $A.enqueueAction(action);
	}
})