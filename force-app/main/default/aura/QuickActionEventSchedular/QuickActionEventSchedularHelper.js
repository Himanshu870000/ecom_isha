({
    InsertMethod : function(component, event, deleteRecordsIds) {
        debugger;
        component.set("v.BBAIdString",deleteRecordsIds);
      //  let callUpdateMethod = component.get("c.updateBBARecord");
      //  $A.enqueueAction(callUpdateMethod);
        var action = component.get("c.tagBAlIToEventMaster");
        var qty = component.get("v.selctProductQty");
        action.setParams({
            BAITIds : deleteRecordsIds,
            recordId : component.get("v.recordId"),
            Qty : qty
        });
        /*action.setParams({
            SelectBBAsset : component.get("v.AllSelectedBidBrandingRecs")
        });*/
        action.setCallback(this, function(response){
            debugger;
            if(response.getState() === "SUCCESS"){
                var data = response.getReturnValue();
                if(data !=null){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Success',
                        message: 'Bid Branding Asset Record Created Successfully !',
                        duration:' 5000',
                        key: 'info_alt',
                        type: 'success',
                        mode: 'pester'
                    });
                    toastEvent.fire();
                    var dismissActionPanel = $A.get("e.force:closeQuickAction");
                    dismissActionPanel.fire(); 
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    updateBBARecord : function(component, event){
        debugger;
        let BBId = component.get("v.BBAIdString");
        var action = component.get("c.updateQuantity");
        action.setParams({
            BidBranAssetIdSet : BBId
        });
        action.setCallback(this, function(response){
            if(response.getState() === "SUCCESS"){
                var data = response.getReturnValue();
            }
        });
        $A.enqueueAction(action);
    },
    
})