({
    getUnitList: function(component) {
        component.set('v.checkSpinner', true);
        var recId = component.get("v.recordId")
        var action = component.get('c.getUnits');
        var self = this;
        action.setParams({
            "recordId": recId
        });
        action.setCallback(this, function(actionResult) {
            component.set('v.units', actionResult.getReturnValue());
            component.set('v.ProjectID', actionResult.getReturnValue()[0].Project__c);
            component.set('v.displayUnits', true);
            component.set('v.checkSpinner', false);
        });
        $A.enqueueAction(action);
    } ,
    //LeadTriggerHelper.createVisitLineItems(unitList,'00QN000000AjveKMAR');
    createVisits: function(component) {
        debugger;
       
        component.set('v.checkSpinner', true);
        var selIds = component.get("v.selectedunitIds");
        var units = component.get("v.units");
        var projectID = component.get("v.ProjectID");
        var finalUnits = [];
        var leadId = component.get("v.recordId");
        if(selIds.length > 0){
            for (let i = 0; i < units.length; i++) {
                for (let j = 0; j < selIds.length; j++) {
                    if(units[i].Id == selIds[j] ){
                        finalUnits.push(units[i]);
                    }
                }
            } 
            units = finalUnits;
        }
        
        
        var action = component.get('c.createVisitLineItems');
        var self = this;
        action.setParams({
            "unitsList":units,
            "projectId": projectID,
            "leadId": leadId
        });
        action.setCallback(this, function(actionResult) {
            component.set('v.checkSpinner', false);
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Success!",
                "message": "The Visits has been Created successfully."
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
        
        var selectedContacts = [];
        var checkvalue = component.find("checkContact");
         
        if(!Array.isArray(checkvalue)){
            if (checkvalue.get("v.value") == true) {
                selectedContacts.push(checkvalue.get("v.text"));
            }
        }else{
            for (var i = 0; i < checkvalue.length; i++) {
                if (checkvalue[i].get("v.value") == true) {
                    selectedContacts.push(checkvalue[i].get("v.text"));
                }
            }
        }
        component.set("v.selectedunitIds",selectedContacts);
        console.log('selectedContacts-' + selectedContacts);
    }
})