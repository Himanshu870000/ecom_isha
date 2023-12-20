({
	doInit : function(component, event, helper) {
		function myGreeting() {
            debugger;
            var parent = document.querySelector(".slds-col.slds-no-flex.slds-grid.slds-align-bottom");
            if(parent) {
                var button = parent.querySelectorAll(".slds-button.slds-button_icon.slds-button_icon-container")[0];
                if(button)button.click();
            }else {
                //window.location.reload();
            }        
        }
        
        const myTimeout = setInterval(myGreeting, 5000);
        
	}
})