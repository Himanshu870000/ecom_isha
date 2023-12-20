({  
    doInit: function(component, event, helper) {
        debugger;
        component.set("v.displayMeetingSchedular", true);
        var today = new Date();
        var dd = String(today.getDate()).padStart(2, '0');
        var mm = String(today.getMonth() + 1).padStart(2, '0'); //January is 0!
        var yyyy = today.getFullYear();
        
        today = mm + '/' + dd + '/' + yyyy;
        
        const monthNames = ["January", "February", "March", "April", "May", "June",
                            "July", "August", "September", "October", "November", "December"
                           ];
        
        var monthNum = parseInt(mm);
        var month = monthNames[monthNum-1] +' - '+ yyyy;
        component.set('v.CurrentMonth',month);
        //document.write("The current month is " + monthNames[mm]);
        
        helper.getDaysAndDate(component,event,helper);  
    },
    openModel: function(component, event, helper) {
        // Set isModalOpen attribute to true
        component.set("v.displayMeetingSchedular", true);
    },
    
    closeModel: function(component, event, helper) {
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
    },
    getSlots: function(component, event, helper) {
        debugger;
        
        var date = event.getParam("selectedDate");
        var day = event.getParam("selectedDay");
        component.set("v.PassDate", date);
        var date = component.get('v.PassDate');
        //component.set('v.checkSpinner',true);
        //var day = event.currentTarget.title;
        //var date = event.currentTarget.id;
        var slot = component.get("v.SelSlot");
        var recId = '0050B0000082G6d';//component.get("v.recordId")
        //String RecId,String SchDate,String schday,String Slot
        component.set('v.SelDay',day);
        component.set('v.SelDate',date);
        var action = component.get("c.getAvailableSlots");
        action.setParams({
            "RecId": recId,
            "schday": day,
            "SchDate":date,
            "Slot": slot
        });
        action.setCallback(this, $A.getCallback(function(response) {
            var state = response.getState();
            var storeResponse = response.getReturnValue();
            if (state == "SUCCESS") {
                {
                    component.set('v.checkSpinner',false);
                    component.set('v.showSlots',true);
                    component.set('v.availableSlots',response.getReturnValue());
                }
            }else{}
        }));
        $A.enqueueAction(action);
    },
    scheduleTeamsMeeting: function(component, event, helper) {
        debugger;
        component.set('v.checkSpinner',true);
        var slot = component.get("v.SelSlotDuration");
        var selectedContacts = component.get("v.selectedLookUpRecords");
        var emailList = [];
        
        for (let i = 0; i < selectedContacts.length; i++) {
            if(selectedContacts[i].Email != null && selectedContacts[i].Email != undefined){
                emailList.push(selectedContacts[i].Email);
            }
        }
        
        var slotduration = component.get("v.SelSlot");
        var startSlot = component.get("v.SelStartDate");
        var endSlot = component.get("v.SelEndDate");
        var recId = '0050B0000082G6d';//component.get("v.recordId")
        var description = component.get("v.Description");
        var secondEmail = component.get("v.emailOfAnotherUser");
        var action = component.get("c.scheduleMeetingforUser");
        action.setParams({
            "startSlot": startSlot,
            "endSlot":endSlot,
            "description":description,
            "secondEmail":emailList
        });
        action.setCallback(this, $A.getCallback(function(response) {
            var state = response.getState();
            var storeResponse = response.getReturnValue();
            if (state == "SUCCESS") {
                {   
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "message": "The Meeting Link  has been Generated successfully.Check your Calender!!"
                    });
                    toastEvent.fire();
                    component.set("v.displayMeetingSchedular", false);
                    debugger;
                    var homeEvt = $A.get("e.force:navigateToObjectHome");
                    homeEvt.setParams({
                        "scope": "Event"
                    });
                    homeEvt.fire();
                    component.set("v.displayMeetingSchedular", false);
                    component.set('v.checkSpinner',false);
                    //alert('Your meeting has been scheduled with the user with the meeting id :'+response.getReturnValue());
                }
            }else{
                component.set('v.checkSpinner',false);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Some Error Occured!!"
                });
                toastEvent.fire();
                
                component.set("v.displayMeetingSchedular", false);
                var homeEvt = $A.get("e.force:navigateToObjectHome");
                homeEvt.setParams({
                    "scope": "Event"
                });
                homeEvt.fire();
                
            }
        }));
        $A.enqueueAction(action);
    },
    scheduleZoomMeeting: function(component, event, helper) {
        debugger;
        component.set('v.checkSpinner',true);
        var slot = component.get("v.SelSlotDuration");
        var selectedContacts = component.get("v.selectedLookUpRecords");
        var emailList = [];
        
        for (let i = 0; i < selectedContacts.length; i++) {
            if(selectedContacts[i].Email != null && selectedContacts[i].Email != undefined){
                emailList.push(selectedContacts[i].Email);
            }
        }
        
        var slotduration = component.get("v.SelSlot");
        var startSlot = component.get("v.SelStartDate");
        var endSlot = component.get("v.SelEndDate");
        var recId = component.get("v.recordId");
        var description = component.get("v.Description");
        var secondEmail = emailList[0];//component.get("v.emailOfAnotherUser");
        var action = component.get("c.CreateZoomMeetingWithOutlook");
        action.setParams({
            "startSlot": startSlot,
            "endSlot":endSlot,
            "description":description,
            "secondEmail":secondEmail,
            "leadId":recId
        });
        action.setCallback(this, $A.getCallback(function(response) {
            var state = response.getState();
            var storeResponse = response.getReturnValue();
            if (state == "SUCCESS") {
                {
                    component.set('v.checkSpinner',false);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!!",
                        "message": "The Meeting Link  has been Generated successfully.Check your Calender!!"
                    });
                    toastEvent.fire();
                    var dismissActionPanel = $A.get("e.force:closeQuickAction");
                    dismissActionPanel.fire();       
                    $A.get('e.force:refreshView').fire();
                }
            }else{
                component.set('v.checkSpinner',false);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Some Error Occured!!"
                });
                toastEvent.fire();
                
                var dismissActionPanel = $A.get("e.force:closeQuickAction");
                dismissActionPanel.fire();
                 $A.get('e.force:refreshView').fire();
            }
        }));
        $A.enqueueAction(action);
    },
    ChooseSlot: function(component, event, helper) {
        debugger;
        var slot = event.currentTarget.title;
        component.set('v.SelSlotDuration',slot);
    },
    ShowMeetingSchedular :function(component, event, helper) {
        debugger;
        component.set('v.displayMeetingSchedular',false);
        component.set('v.displayMeetingSchedularChild',true);
    },
    showMeetingDetails :function(component, event, helper) {
        debugger;
        component.set('v.displayMeetingSchedularChild',false);
        component.set('v.displayMeetingDetails',true);
    }
})