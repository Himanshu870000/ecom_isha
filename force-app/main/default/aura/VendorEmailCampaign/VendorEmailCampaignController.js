({
	doInit : function(component, event, helper) {
         debugger;
         //helper.getCurrentRecordData(component, event);
		var action = component.get("c.GetVendorList");
        action.setCallback(this, function(response){
            if(response.getState() === "SUCCESS"){
                var result = response.getReturnValue();
                component.set("v.data", result);
            }
        });
        $A.enqueueAction(action);
	},
     updateSelectedText: function (component, event) {
        debugger;
        var selectedRows = event.getParam('selectedRows');
        debugger; 
        var setRows = [];
        for ( var i = 0; i < selectedRows.length; i++ ) {
            setRows.push(selectedRows[i]);
        }
        component.set("v.selectedLeads", setRows);
        console.log('selected data: '+setRows);
    },
      hideQuickAction : function (component, event) {
          debugger;
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
    },
     selectAll : function (component, event) {
        debugger;   
        var selectedHeaderCheck = event.getSource().get("v.value");
        var getAllId = component.find("boxPack");
        if(! Array.isArray(getAllId)){
            if(selectedHeaderCheck == true){ 
                component.find("boxPack").set("v.value", true);
                
            }else{
                component.find("boxPack").set("v.value", false);
            }
        }else{
            
            if (selectedHeaderCheck == true) {
                for (var i = 0; i < getAllId.length; i++) {
                    component.find("boxPack")[i].set("v.value", true);
                    component.set("v.selectedCount", getAllId.length);
                }
            }
            else {
                for (var i = 0; i < getAllId.length; i++) {
                    component.find("boxPack")[i].set("v.value", false);
                    component.set("v.selectedCount", 0);
                }
            } 
        }  
    },
    
     checkboxSelect: function(component, event, helper) {
        debugger;
        var selectedRec = event.getSource().get("v.value");
        
        var getSelectedNumber = component.get("v.selectedCount");
        
        if (selectedRec == true) {
            getSelectedNumber++;
        } else {
            getSelectedNumber--;
        }
        
        component.set("v.selectedCount", getSelectedNumber);
    },
     SaveRecord : function(component, event, helper) {
        debugger;
         var spinner=component.get("v.show");
         component.set("v.show",true);
         var delId = [];
        // get all checkboxes 
        var getAllId = component.find("boxPack");
        // If the local ID is unique[in single record case], find() returns the component. not array
        if(! Array.isArray(getAllId)){
            if (getAllId.get("v.value") == true) {
                delId.push(getAllId.get("v.text"));
            }
        }else{
            // play a for loop and check every checkbox values 
            // if value is checked(true) then add those Id (store in Text attribute on checkbox) in delId var.
            for (var i = 0; i < getAllId.length; i++) {
                if (getAllId[i].get("v.value") == true) {
                    delId.push(getAllId[i].get("v.text"));
                    console.log("Record ID :::"+delId);
                }
            }
        } 
         helper.InsertMethod(component, event, delId);
    }
})