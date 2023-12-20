({
	 doInit: function(component, event, helper){
        debugger;
        // component.set("v.isOpen", true); 
        helper.checkNurOnLead(component, event);
        helper.addLeadNurtureRecord(component, event);   
    },
    addRow1: function(component, event, helper) {
        debugger;
        helper.addLeadNurtureRecord(component, event);
    },
    removeRow: function(component, event, helper) {
        debugger;
        var leadNurturelist2 = component.get("v.leadNurturelist");
        var selectedItem = event.currentTarget;
        var index = selectedItem.dataset.record;
        leadNurturelist2.splice(index, 1);
        component.set("v.leadNurturelist", leadNurturelist2);
    }, 
    save: function(component, event, helper) {
        debugger;
        if (helper.validateNurturetList(component, event)) {
            /*   helper.saveLeadNurtureList(component, event);
            alert('SaveCmp');*/
            var LeadrecId = component.get("v.recordId");
            var action  = component.get('c.createLeadNurture');
            // var reqid = component.get("v.recordId");
            action.setParams({
                "nurturelist"  : component.get("v.leadNurturelist"),
                "leadid" : LeadrecId
            });
            action.setCallback(this,function(result){
                var state = result.getState();
                if(state ==="SUCCESS"){
                    var data = result.getReturnValue();
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "message": "New Lead Nurture Steps Saved successfully.",
                        'duration':' 5000',
                        'key': 'info_alt',
                        'type': 'success',
                        'mode': 'pester'
                    });
                    toastEvent.fire(); 
                    $A.get('e.force:refreshView').fire();
                    var dismissActionPanel = $A.get("e.force:closeQuickAction");
                    dismissActionPanel.fire();
                    
                }else {
                    
                    alert(result.getError()[0].message);
                }
                
            });
            $A.enqueueAction(action);
        } 
     },
    CreateStep: function(component, event, helper){
        helper.addLeadNurtureRecord(component, event);
        component.set("v.NorecFound", false);
        component.set("v.isOpen", true);
    }
})