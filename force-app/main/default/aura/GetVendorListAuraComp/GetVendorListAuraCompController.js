({
	doInit : function(component, event, helper) {
         debugger;
       //  helper.getCurrentRecordData(component, event);
		var action = component.get("c.getAllVendorRecord");
        action.setCallback(this, function(response){
            if(response.getState() === "SUCCESS"){
                var result = response.getReturnValue();
                if(result!=null || result!=undefined){
                    for(let i=0;i<result.length;i++){
                        result[i].design='border-radius:15px;box-shadow: 0 4px 8px 0 rgba(0,0,0,0.2);transition: 0.3s;width: calc(49.33% - 20px);margin-bottom: 20px;text-align: center; padding: 20px;background-color:blue;color:white;font-size:17px;';
                        result[i].selected=false;
                    }
                }
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
         var delId = component.get("v.SelectedVendorRecords");
        // get all checkboxes 
        /*var getAllId = component.find("boxPack");
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
        } */
         if(delId.length!=0){
              helper.insertVendorRequest(component, event, delId);
         }
         
    },
    SearchButtomClick:function(component, event, helper) {
        debugger;
        var vendorRecordDetail=component.get("v.data");
        var SelectedVendorRecordIds=component.get("v.SelectedVendorRecords");
        var SelectedId=event.currentTarget.dataset.id;
       
        if(SelectedId!=null || SelectedId!=undefined){
            if(vendorRecordDetail.length!=0){
                for(let i=0;i<vendorRecordDetail.length;i++){
                    if(vendorRecordDetail[i].Id==SelectedId){
                        if(vendorRecordDetail[i].selected==false){
                            vendorRecordDetail[i].design='border-radius:15px;box-shadow: 0 4px 8px 0 rgba(0,0,0,0.2);transition: 0.3s;width:calc(49.33% - 20px);margin-bottom: 20px;text-align: center; padding: 20px;background-color: #50C878;color:white;font-size:17px;';
                            vendorRecordDetail[i].selected=true;
                            SelectedVendorRecordIds.push(SelectedId);
                            break; 
                        }else if(vendorRecordDetail[i].selected==true){
                            vendorRecordDetail[i].design='border-radius:15px;box-shadow: 0 4px 8px 0 rgba(0,0,0,0.2);transition: 0.3s;width: calc(49.33% - 20px);margin-bottom: 20px;text-align: center; padding: 20px;background-color:blue;color:white;font-size:17px;';
                            vendorRecordDetail[i].selected=false;
                            if(SelectedVendorRecordIds.length!=0){
                                for(let j=0;j<SelectedVendorRecordIds.length;j++){
                                    if(SelectedVendorRecordIds[j]==SelectedId){
                                        delete SelectedVendorRecordIds[j];
                                        break;
                                    }
                                }
                                console.log('SelectedVendorRecordIds--'+JSON.stringify(SelectedVendorRecordIds));
                            }
                            break; 
                        }
                        
                    }
                }
                component.set("v.data", vendorRecordDetail);
            }  
        }
        
        if(SelectedVendorRecordIds.length!=0 && SelectedVendorRecordIds!=null && SelectedVendorRecordIds!=undefined){
          console.log('SelectedVendorRecordIds--'+JSON.stringify(SelectedVendorRecordIds));
          component.set("v.SelectedVendorRecords",SelectedVendorRecordIds);
        }
    }
})