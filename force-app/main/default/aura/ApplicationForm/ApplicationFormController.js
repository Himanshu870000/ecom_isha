({	
    doInit : function(component, event, helper){
        debugger;
        var recordId= component.get("v.recordId");
        var action = component.get("c.getSchoolRecord");
        action.setParams({
            recordId:recordId
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var data = response.getReturnValue();
                
                component.set("v.School", data); 
                
            }
            
            
        });
        $A.enqueueAction(action);
    },
    handleClick : function(component, event, helper){
        debugger;
        var action = component.get("c.UpdateStudentForm");
        var SchoolRecord = component.get("v.School");
        //delete bookrec.nihrm__BookingContact__r;
        var recordId= component.get("v.recordId");
        
        action.setParams({
            recordId :recordId,
            studentRec:SchoolRecord
            
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var data = response.getReturnValue();
                alert('updated')
            }else if(state === "ERROR"){
                var errors = action.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        alert('in error',errors[0].message);
                    }
                }
            }else if (status === "INCOMPLETE") {
                alert('No response from server or client is offline.');
            }
        });
        $A.enqueueAction(action);
    },
    
    onChange: function (component, event, helper) {
        debugger;
        var comp = component.find('schoolType');
        var selectedTypeVal = comp.get('v.value');
        component.set("v.School.Type__c",selectedTypeVal);    
    },
    BoardonChange: function (component, event, helper) {
        debugger;
        var comp = component.find('BoardType');
        var selectedTypeVal = comp.get('v.value');
        component.set("v.School.Board_Affiliation__c",selectedTypeVal);    
    },
    deliveryonChange: function (component, event, helper) {
        debugger;
        var comp = component.find('deleveryMeduim');
        var selectedTypeVal = comp.get('v.value');
        component.set("v.School.Delivery_Medium__c",selectedTypeVal);    
    },
     feeonChange: function (component, event, helper) {
        debugger;
        var comp = component.find('FeeRange');
        var selectedTypeVal = comp.get('v.value');
        component.set("v.School.Fee_Range__c",selectedTypeVal);    
    },
    gradeonChange: function (component, event, helper) {
        debugger;
        var comp = component.find('grade');
        var selectedTypeVal = comp.get('v.value');
        component.set("v.School.Grade_Range__c",selectedTypeVal);    
    },

    
})