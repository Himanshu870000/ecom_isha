({
	doInit : function(component, event, helper) {
        debugger;
        var accId = component.get("v.accIdForChild");
        
        var options= [
            {'label': 'New', 'value': 'new'},
            {'label': 'In Process', 'value': 'inProcess'},
            {'label': 'Ready For Dispatch', 'value': 'readyForDispatch'},
            {'label': 'Delivered', 'value': 'delivered'},
            {'label': 'Invoiced', 'value': 'invoiced'},
            {'label': 'Paid', 'value': 'paid'},
            {'label': 'Closed', 'value': 'closed'},
        ];
            
        component.set("v.stageOptions", options);
		helper.getOrders(component, event);
	},
              
    handleOptionSelected: function (cmp, event) {
    //Get the string of the "value" attribute on the selected option
        var selectedValue = event.getParam("value");
        //alert("Selected Option: '" + selectedValue + "'");
    },
    
    handleNext : function(component, event, helper) { 
        debugger;
        var pageNumber = component.get("v.pageNumber");
        component.set("v.pageNumber", pageNumber+1);
        helper.getOrders(component, helper);
    },
     
    handlePrev : function(component, event, helper) {  
        debugger;
        var pageNumber = component.get("v.pageNumber");
        component.set("v.pageNumber", pageNumber-1);
        helper.getOrders(component, helper);
    },
    
    openModal : function(component, event, helper) {
        component.set("v.showModal", true);
    },
    
    closeModal : function(component, event, helper) {
        component.set("v.showModal", false);
    },
    
    createOrder : function(component, event, helper) {
        debugger;
        var newOrd = component.get("v.newOrder");
        // You can perform validations and other processing here before creating the account
        var action = component.get("c.createOrderRecord");
        action.setParams({
            "order": newOrd
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                component.set("v.showModal", false);
                component.set("v.newOrder",result);   
                // Optionally, you can refresh the account list or perform other actions here
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "The record Created successfully."
                });
                toastEvent.fire();  
            }
        });
        $A.enqueueAction(action);
    },  
    
    newOrder : function(component,event,helper){
        debugger;
        var modalFade1 = component.find('eventPopId');    
        component.find("eventPopId").submitDR(modalFade1);
    },
    
    orderDetail : function(component, event, helper) {
        debugger;
        var navigateEvent = $A.get("e.force:navigateToComponent");
        navigateEvent.setParams({
            componentDef: "c:OrderDetailsCmp"
            //You can pass attribute value from Component1 to Component2
            //componentAttributes :{ }
        });
        navigateEvent.fire();  
    }
})