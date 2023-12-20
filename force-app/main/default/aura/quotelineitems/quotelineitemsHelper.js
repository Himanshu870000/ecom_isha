({
    getFeatureList: function (component) {
        debugger;
        var action = component.get("c.getAllFeaturesFromProduct");
        var self = this;
        action.setParams({ ProductIdsList : component.get("v.productIds") });
        action.setCallback(this, function (actionResult) {
            var state = actionResult.getState();
            if (component.isValid() && state === "SUCCESS") {
                console.log('Data::' + actionResult.getReturnValue());
                let featureList = actionResult.getReturnValue();
                const letters = [];
                for (var i = 0; i < featureList.length;i++){
                    if (!letters.includes(featureList[i].Category__c)) {
                        letters.push(featureList[i].Category__c);
                    }
                    
                }
                component.set("v.Categories", letters);
                component.set("v.contacts", actionResult.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    getProductOption: function () {
        
    },
    handleClickSelect:function(component, event, helper) {
        debugger;
        var ValueOfConfigureProduct=true;
        var ValueOfProductTableScreen=false;
        var Tempvariable=true;
        //component.set("v.ProductOptionScreen",ValueOfConfigureProduct);
        //component.set("v.ProductTableScreen",ValueOfProductTableScreen);
        //var proIds = component.get("v.AllProductIds");
        
        var action = component.get("c.ShowAllOptions");
        var proIds = component.get("v.productIds");
        
        var action = component.get("c.ShowAllOptions");
        action.setParams({ 
            'ProductIds' : proIds
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state==='SUCCESS'){
                var responseValue = response.getReturnValue();
                console.log('responseValue In AllMaps--',JSON.stringify(responseValue));
                component.set("v.SelectedProductOptions",responseValue);
            }   
        });
        /*if(Tempvariable==true){
           
        var action = component.get("c.AllMaps");
        action.setCallback(this, function(response) {
            var state = response.getState();
              if(state==='SUCCESS'){
                    var responseValue = response.getReturnValue();
                    console.log('responseValue In AllMaps--',JSON.stringify(responseValue));
                    //component.set("v.SelectedProductOptions",responseValue);
              }   
        });
     }*/
        var selectedQliList=component.get("v.selectedQLI");
        console.log('selectedQliList--',JSON.stringify(selectedQliList));
        $A.enqueueAction(action);
        
    },
    handleSaveProduct:function(component, event, helper) {
        debugger;
        var Temprec=component.get("v.selectedQLI");
        var QuoteComponentEvent = component.getEvent('featuresXOptions');
        // Setting the attribute of event using setParams()
        // 
        QuoteComponentEvent.setParams({
            SelectedOptions: Temprec
        });
        // Firing the event
        QuoteComponentEvent.fire();
        
        
    }
});