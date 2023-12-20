({
    doInit : function(component,event,helper){
        debugger;
        var action = component.get('c.getOpportunity');
        action.setParams({ 
            "recordId" : component.get("v.recordId") 
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state ==="SUCCESS"){
                var result=response.getReturnValue();
                console.log('result--',result);
                if(result.Amount == null || result.Amount == undefined ||result.Amount =='' ){
                    alert('Add products to proceed');
                    $A.get("e.force:closeQuickAction").fire();
                    return null;
                }
                if(result.Account.Email__c == null || result.Account.Email__c == undefined ||result.Account.Email__c =='' ){
                    alert('Add Email on Account to proceed');
                    $A.get("e.force:closeQuickAction").fire();
                    return null;
                }
                if(result.Account.Phone == null || result.Account.Phone == undefined ||result.Account.Phone =='' ){
                    alert('Add Phone on Account to proceed');
                    $A.get("e.force:closeQuickAction").fire();
                    return null;
                }
                component.set("v.totalPayment",result.Due_Amount__c);
                component.set("v.upfrontPayment",result.Due_Amount__c);
                
                //var duePay = (result.Amount) - (result.UpFront_Payment__c);
                // component.set("v.duePayment",duePay);
            }
        });
        $A.enqueueAction(action);
    },
    
    handlePayRadio : function(component, event, helper) {
        debugger;
        var paymentType = event.getParam('value');
        //alert(paymentType);
        
        component.set("v.rdPayValue",paymentType);
        
    },
    
    handleRadio : function(component, event, helper) {
        debugger;
        var paymentOption = event.getParam('value');
        //alert(paymentOption);
        component.set("v.rdvalue",paymentOption);
        
    },
    
    handleFilesChange : function (component, event) {
        debugger;
        var uploadedFiles = event.getParam("files");
        var documentId = uploadedFiles[0].documentId;
        var fileName = uploadedFiles[0].name;
        component.set("v.fileName",fileName);
       
    },
    
    Save : function(component,event,helper){
     debugger;
		let button = component.find('disablebuttonid');
    	button.set('v.disabled',true);        
        var action = component.get("c.updateOpprecord");
        action.setParams({ 
            "recordId" : component.get("v.recordId"),
            "PaymentOptions" : component.get("v.rdvalue"),
            "PaymentType": component.get("v.rdPayValue"),
            "PaymentMode": component.get("v.paymentGateway"),
            "UpFrontPayment": component.get("v.upfrontPayment"),
            "PaymentGateway":component.get("v.paymentGateway")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                if(component.get("v.rdvalue") == 'Manual Pay'){
                    helper.uploadHelper(component, event);
                }
                else if (state === "ERROR") {
                }
                $A.get('e.force:refreshView').fire();
                $A.get("e.force:closeQuickAction").fire();
                var dismissActionPanel = $A.get("e.force:closeQuickAction");
                dismissActionPanel.fire();
            }
            });
            $A.enqueueAction(action); 		
	},
    
    handleClose : function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire() 
    },
        
    handleUpfront:function(component, event, helper) {
        debugger;
        var total=component.get("v.totalPayment");
        var selectedValue =  event.getSource().get("v.value");
        component.set("v.upfrontPayment",selectedValue);
        console.log('total--',total);
        console.log('selectedValue--',selectedValue);
        
        var DuePayment = total - parseInt(selectedValue);
        console.log('DuePayment--',DuePayment);
        component.set("v.duePayment",DuePayment);   
    },
    
    onChange : function(component, event, helper) {
        debugger;  
        var selectedPaymentMode = component.find('paymentMedPicklist').get('v.value');
        component.set("v.SelectedPayMode",selectedPaymentMode);
    },
    
    
    onChannelChange : function(component, event, helper) {
        debugger;
        var channel =  component.find('paymentTypePicklist').get('v.value');
        component.set("v.SelectedPayMode",channel);
    },
    
    
    onValueChange : function(component,event,helper){
        debugger;
        var payGateway = component.find('paymentGatewayPicklist').get('v.value');
        console.log('payGateway--',payGateway);
        component.set("v.paymentGateway",payGateway);
    }
    

})