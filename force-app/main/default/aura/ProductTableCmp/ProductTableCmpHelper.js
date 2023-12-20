({
	getProducts : function(component, event) {
        var action = component.get("c.getProductList");
        action.setParams({
            'pageSize' : component.get("v.pageSize"),
            'pageNumber' : component.get("v.pageNumber")
        });
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                if(result.length < component.get("v.pageSize") || result.length == 0){
                    component.set("v.isLastPage", true);
                } else{
                    component.set("v.isLastPage", false);
                }
                component.set("v.dataSize", result.length);
                component.set("v.prodList", result);
            }
        });
        $A.enqueueAction(action);
    },
})