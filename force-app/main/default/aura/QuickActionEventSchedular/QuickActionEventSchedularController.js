({
    doInit : function(component, event, helper) {
        debugger;
        var url = $A.get('$Resource.ItwUpdatedLogo');
        component.set('v.backgroundImageURL', url);
        component.set("v.selectedFirstRecordPage", true);
        var action = component.get("c.getEventDetails");
        action.setParams({
            "recordId" : component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            if(response.getState() === "SUCCESS"){
                var result = response.getReturnValue();
                component.set('v.data', result);  
                component.set("v.Productcount",result.Product_Available_Quantity__c);
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
            } else {
                for (var i = 0; i < getAllId.length; i++) {
                    component.find("boxPack")[i].set("v.value", false);
                    component.set("v.selectedCount", 0);
                }
            } 
        }  
    },
    
    checkboxSelect: function (component, event, helper) {
        debugger;
        var selectedRec = event.getSource().get("v.value");
        if (selectedRec == true) {
            component.set("v.checkSelect", true);
        }
        else {
            component.set("v.checkSelect", false);
        }
        var selectedRecordId = event.getSource().get("v.text");
        var AllSelectedRecords = [];
        var SelctedBBAsset = component.get("v.AllSelectedBidBrandingRecs");
        var SelectedrecordAfterUncheck = [];
        var allBidBrandingAsset = component.get("v.data");
        if(selectedRec == true){
            for(var i=0; i<allBidBrandingAsset.length; i++){
                if (allBidBrandingAsset[i].Id == selectedRecordId) {
                    allBidBrandingAsset[i].ShowPencilIcon = true;
                    SelctedBBAsset.push(allBidBrandingAsset[i]);
                    component.set("v.EditEmail", true); 
                } 
                else {
                    allBidBrandingAsset[i].ShowPencilIcon = false;
                }
            }
            debugger;
            component.set("v.data", allBidBrandingAsset);
            component.set("v.AllSelectedBidBrandingRecs" , SelctedBBAsset);
            component.set("v.SelectedRecordShowList",SelctedBBAsset);
        }
        if(selectedRec == false){
            for (var i=0; i<SelctedBBAsset.length; i++){
                if(SelctedBBAsset[i].id != selectedRecordId ){
                     allBidBrandingAsset[i].ShowPencilIcon = false;
                    SelctedBBAsset.splice(selectedRecordId);
                }
            }
            debugger;
           component.set("v.SelectedRecordShowList",SelctedBBAsset);
            
           // for(var i=0; i<allBidBrandingAsset.length; i++){
            //    if (allBidBrandingAsset[i].Id == selectedRecordId) {
            //        allBidBrandingAsset[i].ShowPencilIcon = false;
                    //AllSelectedRecords.push(allBidBrandingAsset[i])
            //    } 
           // }
           // component.set("v.data", allBidBrandingAsset);
           // component.set("v.AllSelectedBidBrandingRecs", SelectedrecordAfterUncheck);
        }
        var getSelectedNumber = component.get("v.selectedCount");
        if (selectedRec == true) {
            getSelectedNumber++;
        } else {
            getSelectedNumber--;
        }
        component.set("v.selectedCount", getSelectedNumber);
    },
    
    SaveRecord : function(component, event, helper) {
        component.set("v.selectedFirstRecordPage",false);
        component.set("v.selectedRecordToShow",true);
        var setLabelAsSave = "Save"
       
        debugger;
        var delId = [];
     
        if(component.get("v.buttonLabel") == "Save"){
            component.set("v.disableSave",true);
            
            var action = component.get("c.insertBidBrandingAssets");
            action.setParams({
                "bidBrandingAssestsList" : component.get("v.SelectedRecordShowList"),
                "eventSchedularId" : component.get("v.recordId")
            });
            action.setCallback(this, function(response){
                if(response.getState() === "SUCCESS"){
                  /*  var result = response.getReturnValue();
                    component.set('v.data', result);  
                    component.set("v.Productcount",result.Product_Available_Quantity__c);
                    */
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Success',
                        message: 'Successfully Created Bid Branding Assets Records',
                        duration:' 5000',
                        key: 'info_alt',
                        type: 'success',
                        mode: 'pester'
                    });
                    toastEvent.fire();
                }
                var dismissActionPanel = $A.get("e.force:closeQuickAction");
                dismissActionPanel.fire();
            });
            $A.enqueueAction(action);
        }
         component.set("v.buttonLabel",setLabelAsSave);
    },
    
    
    
    ondblclick : function(component,event,helper){ 
        debugger;
    },
 
    inlineEditQuantity : function(component,event,helper){   
        debugger;
        component.set("v.EditEmail", true); 
        setTimeout(function(){ 
            component.find("inputId1").focus();
        }, 100);
    },
    
    closeQuantityBox :function(component, event, helper) {
        debugger;
        component.set("v.EditEmail", false); 
        if(event.getSource().get("v.value") != undefined && event.getSource().get("v.value").trim() == ''){
            component.set("v.showErrorClass",true);
        }else{
            component.set("v.showErrorClass",false);
        }
    },
    
    onQuantityChange : function(component,event,helper){ 
        debugger;
        var qtyList = component.get("v.selctProductQty");
        if(event.getSource().get("v.value") != undefined && event.getSource().get("v.value").trim() != ''){ 
            qtyList.push(event.getSource().get("v.value"));
            debugger;
        }
        component.set("v.selctProductQty",qtyList);
    },
    
    closeQuantityBox : function (component, event, helper) {
        debugger;
        component.set("v.EditEmail", false); 
        if(event.getSource().get("v.value") != undefined && event.getSource().get("v.value").trim() == ''){
            component.set("v.showErrorClass",true);
        }else{
            component.set("v.showErrorClass",false);
        }
    },
    
})