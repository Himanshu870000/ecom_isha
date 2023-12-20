({
    doInit : function(component, event, helper) {
        debugger;
        var action = component.get("c.getallVendorlist");
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS"){
                var data =  response.getReturnValue();
                
                component.set("v.ConVendorlist",data);
            }
        });
        $A.enqueueAction(action); 
    },
    handleProductSelection: function(component, event, helper) {
        debugger; 
        var selectedRecId = event.getSource('contactSelect').get("v.value");
        component.set("v.selectedvendorID",selectedRecId);
        var action = component.get("c.Productlist");
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS"){
                var data =  response.getReturnValue();
                var temparry = []
                for(var i=0; i<data.length; i++){
                    data[i].isRecordSelected = true;
                    temparry.push(data[i]);
                }
                component.set("v.productlist",temparry);
                
                var obj = {
                    "Id" : "",
                    "quantity" : ""
                };
                var objlist = [];
                for(var i=0; i<data.length; i++){
                    obj.Id = data[i].Id;
                    obj.quantity = '';
                    objlist.push(obj);
                }
                var objemptylist = objlist;
                component.set("v.updateprolist",objemptylist);
            }
        });
        $A.enqueueAction(action); 
    },
    handleSelectAllLead: function (component, event, helper) {
        debugger;
        
        var selectedHeaderCheck = event.getSource().get("v.value");
        var updatedAllRecords = [];
        var updatedPaginationList = [];
        var CompleteLeadlist = component.get("v.productlist");
        
        
        for (var i = 0; i < CompleteLeadlist.length; i++) {
            
            if (selectedHeaderCheck == true) {
                CompleteLeadlist[i].isChecked = true;
                component.set("v.selectedCount", CompleteLeadlist[i].length);
            } else {
                CompleteLeadlist[i].isChecked = false;
                component.set("v.selectedCount", 0);
            }
            updatedAllRecords.push(CompleteLeadlist[i]);
            if(updatedAllRecords != null){
                component.set("v.CompleteLeadlist", updatedAllRecords); 
            }
        }
         
    },
    checkboxSelect: function(component, event, helper) {
        debugger;
        var recId = event.getSource().get("v.text").toString(); //.dataset.id;
        var existprodlist = component.get("v.productlist");
        var temparry = [];
        /*for(var i=0; i<existprodlist.length; i++){
            if(existprodlist[i].Id == recId){
                existprodlist[i].isRecordSelected = false;
                temparry.push(existprodlist[i]);
            }
         }*/  
        var updatedAllRecords = [];
        var selectedRec = event.getSource('checkid').get("v.value");
        
        var CompleteLeadlist = component.get("v.productlist");
        
        for (var i = 0; i < CompleteLeadlist.length; i++) {
           
            if (selectedRec == true) {
                if(existprodlist[i].Id == recId){
                    CompleteLeadlist[i].isRecordSelected = false;
                }
                CompleteLeadlist[i].isChecked = true;
                component.set("v.selectedCount", CompleteLeadlist[i].Id);
                
            } else {
                if(existprodlist[i].Id == recId){
                    CompleteLeadlist[i].isRecordSelected = true;
                }
                              
                CompleteLeadlist[i].isChecked = false;
                component.set("v.selectedCount", 0);
            }
            updatedAllRecords.push(CompleteLeadlist[i]);
        }
        component.set("v.productlist",updatedAllRecords); 
        var getSelectedNumber = component.get("v.selectedCount");
        
    },
    
    PreviewAllData : function(component, event, helper) {
        debugger;
        var unit = component.get("v.quantity");
       var list1 = component.get("v.updateprolist");
        var newlist =[];
        for(var i = 0; i < list1.length; i++){
            list1[i].quantity = unit;
              newlist.push(list1[i]);
        }
        
        var list = component.get("v.productlist"); 
        var vendorRecid = component.get("v.selectedvendorID");
        var action = component.get("c.getallVendorDeatailsRecords");
        action.setParams({
            "vendorid" : vendorRecid
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS"){
                var data =  response.getReturnValue();
                component.set("v.vendorRecordsDetails",data);
                component.set("v.showCard", true);
                component.set("v.hideCard", false);
            }
        });
        $A.enqueueAction(action); 
        
    } 
})