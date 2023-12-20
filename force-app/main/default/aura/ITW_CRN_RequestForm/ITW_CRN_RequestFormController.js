({
    doInit : function(component, event, helper) {
        debugger;
        let CallpickListMethod = component.get("c.pickListIndustry");
        $A.enqueueAction(CallpickListMethod);
        let CallpickListMethod2 = component.get("c.pickListInception");
        $A.enqueueAction(CallpickListMethod2);
        let CallpickListMethod3 = component.get("c.pickListTitle");
        $A.enqueueAction(CallpickListMethod3);
        
        var action = component.get("c.getCurrentAccountDetails");
        action.setParams({
            "recordId" : component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var data = response.getReturnValue();
                component.set("v.brandName", data.Name);
                component.set("v.legalName", data.Company_Legal_Name__c);
                component.set("v.website", data.Website);
                component.set("v.selInception", data.Inception_Of_Company__c); 
                component.set("v.selIndustry", data.Industry); 
                
                component.set("v.AccountRec", data);
                
            }else if(state === "ERROR"){
                var errors = action.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        alert(errors[0].message);
                    }
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    pickListIndustry : function(component, event, helper) {
        debugger;
        var action = component.get("c.getPickListValuesMethod");
        action.setParams({
            "ObjectApi_name": 'Account',
            "Field_Name": 'Industry'
        });
        action.setCallback(this, function (response) {
            var State = response.getState();
            if (State === "SUCCESS") {
                var data = response.getReturnValue();
                component.set("v.pickValuesIndustry", data);
            }
        });
        $A.enqueueAction(action);
        helper.getCurrentInoiceRecord(component, event);
    },
    
    
    onIndustryChangeHandler : function(component, event, helper) {
        debugger
        var selPickIndustry = component.find('field').get('v.value');
        component.set("v.selIndustry", selPickIndustry);
        var accountRec = component.get('v.AccountRec');
        accountRec.Industry = selPickIndustry;
        component.set("v.AccountRec",accountRec);
    },
    
    onInceptionChangeHandler : function(component, event, helper) {
        debugger
        var selPickInception = component.find('field1').get('v.value');
        component.set("v.selInception", selPickInception);
        var accountRec = component.get('v.AccountRec');
        accountRec.Inception_Of_Company__c = selPickInception;
        component.set("v.AccountRec",accountRec);      
    },
    
    onTitleChangeHandler : function(component, event, helper) {
        debugger
        var selPickTitle = component.find('field3').get('v.value');
        component.set("v.selTitle", selPickTitle);
        var contactRec = component.get('v.contactRec');
        contactRec.Title = selPickTitle;
        component.set("v.contactRec",contactRec);
        
    },
    
    pickListInception : function(component, event, helper) {
        debugger;
        var action = component.get("c.getPickListValuesMethod");
        action.setParams({
            "ObjectApi_name": 'Account',
            "Field_Name": 'Inception_Of_Company__c'
        });
        action.setCallback(this, function (response) {
            var State = response.getState();
            if (State === "SUCCESS") {
                var data = response.getReturnValue();
                component.set("v.pickValuesInception", data);
            }
        });
        $A.enqueueAction(action);
    },
    pickListTitle : function(component, event, helper) {
        debugger;
        var action = component.get("c.getPickListValuesMethod");
        action.setParams({
            "ObjectApi_name": 'Contact',
            "Field_Name": 'Salutation'
        });
        action.setCallback(this, function (response) {
            var State = response.getState();
            if (State === "SUCCESS") {
                var data = response.getReturnValue();
                component.set("v.pickValuesTitle", data);
            }
        });
        $A.enqueueAction(action);
    },
    
    saveRecord : function(component, event, helper) {
        debugger;
        var action = component.get("c.saveRequestForm");
        action.setParams({
            AccountId : component.get("v.recordId"),
            accRec : component.get("v.AccountRec"),
            ConRec : component.get("v.contactRec")
        });
        action.setCallback(this, function(response){
            if(response.getState() === "SUCCESS"){
 
                    //alert("Update Account & Created Contact Record")
                   // var address = component.find("address").get("v.value");
                   
                   window.location.href = "https://www.itwglobal.com/";  
                
                
            }
        });
        $A.enqueueAction(action);
    }
    
    
    
})