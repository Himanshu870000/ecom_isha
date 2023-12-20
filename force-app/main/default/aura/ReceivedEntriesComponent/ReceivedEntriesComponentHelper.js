({
    fetchPOLineItemHelper : function(component, event, helper) {
        debugger;
        var action = component.get("c.getPOLineItemList"); 
        action.setCallback(this,function(response){
            
            var NewProductList =[];
            var ProductList = [];
            var state = response.getState();
            if(state === "SUCCESS"){
                
                ProductList = response.getReturnValue();
                console.log('ProductList'+JSON.stringify(ProductList));
                for (let i = 0; i < ProductList.length; i++) {
                    
                       if(ProductList[i].Quantity__c != null && ProductList[i].Quantity__c > 1){
                        var individualPrice = ProductList[i].Price__c / ProductList[i].Quantity__c;
                        //component.set("v.individualPrice", individualPrice);
                        
                        for (let j = 0; j <= ProductList[i].Quantity__c; j++) {
                            NewProductList.push({
                                Name: ProductList[i].Product_Name__c,
                                Quantity: '1',
                                Price: individualPrice,
                                SerialNumber: null,
                                AccountId : '001N000002AUrUBIA1',
                                ContactId : '003N000001yDJTQIA4'
                            });
                        }
                        component.set("v.NewProductList",NewProductList);
                    } 
                    else{
                        NewProductList.push({
                                    Name: ProductList[i].Product_Name__c,
                                    Quantity: '1',
                                    Price: ProductList[i].Price__c,
                                    SerialNumber: null,
                                    AccountId : '001N000002AUrUBIA1',
                                    ContactId : '003N000001yDJTQIA4'
                                });
                        component.set("v.NewProductList",NewProductList);
                        console.log('NewProductList---------------->', NewProductList);
                    }
                    /*NewProductList.push({
                                    Name: ProductList[i].Product_Name__c,
                                    Quantity: '1',
                                    Price: ProductList[i].Price__c,
                                    SerialNumber: null,
                                    AccountId : '001N000002AUrUBIA1',
                                    ContactId : '003N000001yDJTQIA4'
                                });*/
                   
                } 
                component.set("v.NewProductList",NewProductList);
            }
            
        });
        $A.enqueueAction(action);
    },
    
    showToast : function(title, message, error) {
        let toastParams = {
            title: title,
            message: message, // Error message
            type: error
        };
        let toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams(toastParams);
        toastEvent.fire();
    }
})