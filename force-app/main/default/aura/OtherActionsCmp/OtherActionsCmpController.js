({
    openGoogle : function(component, event, helper) {
        window.open("https://insideview-app-demo-dev-ed.lightning.force.com", "_blank");
    },
    
    openSalesforce : function(component, event, helper) {
        window.open("https://www.salesforce.com", "_blank");
    },
    
    openModel: function(component, event, helper) {
        // Set isModalOpen attribute to true
        component.set("v.isModalOpen", true);
    },
    
    closeModel: function(component, event, helper) {
        // Set isModalOpen attribute to false  
        component.set("v.isModalOpen", false);
    },
    
    submitDetails: function(component, event, helper) {
        // Set isModalOpen attribute to false
        //Add your code to call apex method or do some processing
        component.set("v.isModalOpen", false);
    },
})