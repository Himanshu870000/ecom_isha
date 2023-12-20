({
    doInit: function(component) {
        component.set('v.checkSpinner', true);
        var recId = component.get("v.recordId")
        var action = component.get('c.getUnitsforTransfer');
        var self = this;
        action.setParams({
            "recordId": recId
        });
        action.setCallback(this, function(actionResult) {
            component.set('v.units', actionResult.getReturnValue());
            component.set('v.displayUnits', true);
            component.set('v.checkSpinner', false);
        });
        $A.enqueueAction(action);
    } ,
    //LeadTriggerHelper.createVisitLineItems(unitList,'00QN000000AjveKMAR');
    createVisits: function(component) {
        debugger;
        component.set('v.checkSpinner', true);
        var unitId = component.get("v.selectedUnit");
        //var projectID = component.get("v.ProjectID");
        var dealId = component.get("v.recordId");
        var action = component.get('c.TransferUnit');
        var self = this;
        action.setParams({
            "unitId":unitId,
            "dealId": dealId
        });
        action.setCallback(this, function(actionResult) {
            component.set('v.checkSpinner', false);
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Success!",
                "message": "The Deal Transfer Process has been Started successfully."
            });
            toastEvent.fire();
        });
        $A.enqueueAction(action);
    } ,
     //Select all contacts
    handleSelectAllContact: function(component, event, helper) {
        debugger;
        var getID = component.get("v.units");
        var checkvalue = component.find("selectAll").get("v.value");        
        var checkContact = component.find("checkContact"); 
        if(checkvalue == true){
            for(var i=0; i<checkContact.length; i++){
                checkContact[i].set("v.value",true);
            }
        }
        else{ 
            for(var i=0; i<checkContact.length; i++){
                checkContact[i].set("v.value",false);
            }
        }
    },
     
    //Process the selected contacts
     handleSelectedContacts: function(component, event, helper) {
        debugger;
         var valES_1 = event.getSource().get("v.name");
         component.set('v.selectedUnit', valES_1);
    }
})