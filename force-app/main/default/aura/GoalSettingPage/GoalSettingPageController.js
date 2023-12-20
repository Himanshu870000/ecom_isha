({
	doInit : function(component, event, helper) {
        debugger;
        var accId = component.get("v.accIdForChild");
		helper.goalSetting(component, event,helper);  
	},
    
    handleNext : function(component, event, helper) { 
        debugger;
        var pageNumber = component.get("v.pageNumber");
        component.set("v.pageNumber", pageNumber+1);
        helper.goalSetting(component, helper);
    },
     
    handlePrev : function(component, event, helper) {  
        debugger;
        var pageNumber = component.get("v.pageNumber");
        component.set("v.pageNumber", pageNumber-1);
        helper.goalSetting(component, helper);
    },
    
    handleInputChange: function(component, event, helper) {
        var inputValue = component.get("v.inputValue");
        component.set("v.progressValue", inputValue);
    },
    
    increment : function(component, event, helper) {
		var currentCounter = component.get("v.counter");
        component.set("v.counter",currentCounter + 1);
	},
    
    decrement : function(component, event, helper) {
		var currentCounter = component.get("v.counter");
        if (currentCounter > 0) {
            component.set("v.counter", currentCounter - 1);
        }
	},
    
    updateProgress : function(component, event, helper) {
        debugger;
        var startValue = component.get("v.startValue");
        var stopValue = component.get("v.stopValue");
        var currentValue = component.get("v.currentValue");
        
        var action = component.get("c.calculateProgress");
        action.setParams({
            "startValue": startValue,
            "stopValue": stopValue,
            "currentValue": currentValue
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var progress1 = response.getReturnValue();
                component.set("v.progress", progress1);
            }
        });
        
        $A.enqueueAction(action);
    },
    
    openModal : function(component, event, helper) {
        debugger;
        component.set("v.showModal", true);
    },
    
    closeModal : function(component, event, helper) {
        component.set("v.showModal", false);
    },
    
    createGoal : function(component, event, helper) {
        debugger;
        var nGoal = component.get("v.newGoal");
        // You can perform validations and other processing here before creating the account
        var action = component.get("c.createYearlyGoal");
        action.setParams({
            "yearlyGoal": nGoal
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                component.set("v.showModal", false);
                component.set("v.newGoal",result);   
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
    
    handleSuccess : function(component, event, helper) {
       
        component.find('notifLib').showToast({
            "variant":"success",
            "title":"Record Created Successfully",
            "message":"Record Id: " + event.getParam("id")
        });
    }
    
   /* onSelectValue: function (component, event, helper) {
        debugger;
        var selectedRecord = event.getSource().get('v.value');
        var action = component.get("c.getProductPrice");
        action.setParams({
            "selectedProductId": selectedRecord
            
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
               // component.set("v.productPrice", result);
            }
        });  
        
        $A.enqueueAction(action);
        
    } */
    
    

})