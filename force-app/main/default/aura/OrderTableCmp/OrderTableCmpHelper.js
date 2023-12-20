({
	getOrders : function(component, event) {
        debugger;
		var action = component.get("c.getOrderList");
        
        /*Format Date value to dd/mm/yyyy
        for(var i=0;i<orderList.length;i++){
            orderList[i].formattedDate = $A.localizationService.formatDate(orderList[i].EffectiveDate, "DD/MM/YYYY");
            orderList[i].formattedEndDate = $A.localizationService.formatDate(orderList[i].EndDate, "DD/MM/YYYY");
        }  */
        
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
                component.set("v.ordList",result);
            }
        });
        $A.enqueueAction(action);
	}
})