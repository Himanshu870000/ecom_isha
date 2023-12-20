({
    onload: function (component, event, helper) {
        debugger;
        helper.datafactory(component, event);
        component.set("v.ShowAvailableSlots", true);
        /*var currentLeadId = component.get("v.recordId");
        var action = component.get("c.PassEventDetailsOnDoint");
        action.setParams({
            'LeadId': currentLeadId
        });
        action.setCallback(this, function (response) {
            var state = response.getState();

            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                component.set("v.Userdetail", storeResponse.UserInfodetails);
                component.set("v.Eventrecord", storeResponse.EventRecDetail);
                component.set("v.LeadRecord", storeResponse.leadDetail);
                if (storeResponse.EventRecDetail.GMeet_Event_Id__c !== '') {
                    component.set("v.RescheduleCheckbox", true);
                    //var elements = document.getElementsByClassName("myTest");
                    //elements[0].style.display = 'block'; 
                    //$("#myTest *").attr("disabled", "disabled").off('click');
                    component.set("v.RescheduleCheckboxDateTime", true);
                    component.set("v.EmailListRecord", storeResponse.EventRecDetail.Attendees_list__c.split(','));
                }

            }
        });
        //4. Add This Method to Action
        $A.enqueueAction(action);*/


    },
	closeModel: function (component, event, helper) {
        // Set isModalOpen attribute to false  
        component.set("v.ShowAvailableSlots", false);
    },
    openModel : function(component, event, helper){
        component.set("v.ShowAvailableSlots", true);
        
    },
     CheckAvailableSlotforSSM: function (component, event, helper) {
        debugger;
        helper.showSpinner(component);
        var StartTimeForGmeet = component.get("v.Eventrecord.StartDateTime");
        var EndTimeForGmeet = component.get("v.Eventrecord.EndDateTime");
        var EmailforGeetMeet;
        var SMEmail;
        var SSMEmail;
        var checkvalue1 = component.find("EventCheckbox1");
        var checkvalue2 = component.find("EventCheckbox2");
        //helper.FetchLeadDetails(component, event);
        if (!Array.isArray(checkvalue2)) {
            if (checkvalue2.get("v.checked")) {
                if (StartTimeForGmeet != null && EndTimeForGmeet != null) {
                    SSMEmail = checkvalue2.get("v.name");
                    var action = component.get("c.CheckAvailableSlotFromAPI");
                    action.setParams({
                        'StartTime': StartTimeForGmeet,
                        'EndTime': EndTimeForGmeet,
                        'Email': SSMEmail
                    });
                    action.setCallback(this, function (response) {
                        var state = response.getState();

                        if (state === "SUCCESS") {
                            var storeResponse = response.getReturnValue();
                            component.set("v.BookedAndAvailbleSlots", storeResponse);
                            helper.hideSpinner(component);
                            if (storeResponse != null) {
                                component.set("v.AvailableSlots", true);
                            }
                        }
                    });
                    //4. Add This Method to Action
                    $A.enqueueAction(action);

                }
                else {
                    component.set("v.Eventrecord.IsSSMInvited__c", false);
                    helper.hideSpinner(component);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title: 'Warning',
                        message: 'Start Date Time and End Date Time cannot be Empty!!!',
                        duration: ' 5000',
                        key: 'info_alt',
                        type: 'warning',
                        mode: 'sticky'
                    });
                    toastEvent.fire();
                }


            }
            else {
                helper.hideSpinner(component);

            }
        }
    },
    handleClick : function (component, event, helper) {
        debugger;
        var action = component.get("c.updateDemoDAte");
        action.setParams({
            'leadID': component.get("v.recordId")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();

            if (state === "SUCCESS") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Success',
                    message: 'Demo Slot Booked',
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


    },
    
})