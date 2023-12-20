({
    fetchPOLineItem : function(component, event, helper) {
        helper.fetchPOLineItemHelper(component, event, helper);
        
        component.set("v.showCustomLookUp", showInput);
    },
    
    onCheck : function(component, event, helper) {
        debugger;
        var checkBoxCmp = component.find("checkbox");        
        var showInput = component.find("checkbox").get("v.value");
        component.set("v.showCustomLookUp", showInput);
        alert(checkBoxCmp.get("v.value"));
    },
    
    handleSubmit : function (component, event, helper){
        debugger;
        
        var prod = component.get("v.NewProductList");
        console.log("prod"+JSON.stringify(prod));
        
        var action = component.get("c.saveAsset"); 
        action.setParams({
            AssetList:prod
        }); 
        
        action.setCallback(this,function(response){
            var state = response.getState();
            //if callback is Success then show toast message and close the modal popup
            if(state === "SUCCESS")
            {
                //pass parameters to helper showToast method  
                helper.showToast('Success !', 'Record Inserted Successfully', 'success');
                $A.get("e.force:closeQuickAction").fire();
            }
        });
        $A.enqueueAction(action);   
    },
})