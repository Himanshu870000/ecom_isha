({
    getCurrentRecordData : function(component, event){
        debugger;
          var action = component.get("c.getCurrentRecordDetails");
        action.setParams({
            recordId : component.get("v.recordId"),
        });
        action.setCallback(this, function(response){
            if(response.getState() === "SUCCESS"){
                var data = response.getReturnValue();
                component.set("v.EvnetScheId", data.Event_Schedular__c);
                component.set("v.BALIId", data.Branding_Asset_Line_Item__c);
                component.set("v.OppName", data.Name);
                component.set("v.ProductId", data.Product__c);
            }
        });
        $A.enqueueAction(action);
    },
    InsertMethod : function(component, event, deleteRecordsIds) {
		debugger;
        var action = component.get("c.insertOpportunity");
        action.setParams({
            AccountIdList : deleteRecordsIds,
            EveSchduleId : component.get("v.EvnetScheId"),
            BraAssLineItemId : component.get("v.BALIId"),
            OppName : component.get("v.OppName"),
            BidBrandId : component.get("v.recordId ")
        });
        action.setCallback(this, function(response){
            if(response.getState() === "SUCCESS"){
                var data = response.getReturnValue();
                if(data !=null){
                     var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Success',
                        message: 'Opportunity Created Successfully !',
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