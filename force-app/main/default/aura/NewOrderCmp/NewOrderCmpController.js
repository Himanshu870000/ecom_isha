({
    doInit: function (component, event, helper) {
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
            },
            
            handleOptionSelected: function (cmp, event) {
            //Get the string of the "value" attribute on the selected option
              var selectedValue = event.getParam("value");
              alert("Selected Option: '" + selectedValue + "'");
            },
            
            openEventPopup : function(component, event, helper) {
            var modalFade = component.find('modalFade');
            var modalBackdrop = component.find('modalBackdrop');
            
            $A.util.addClass(modalFade,'slds-fade-in-open');
            $A.util.addClass(modalBackdrop,'slds-backdrop_open');
            },
            
            closeEventPopup : function(component, event, helper) {
            var modalFade = component.find('modalFade');
            var modalBackdrop = component.find('modalBackdrop');
            
            $A.util.removeClass(modalFade,'slds-fade-in-open');
            $A.util.removeClass(modalBackdrop,'slds-backdrop_open');
            }, 
                      
      
})