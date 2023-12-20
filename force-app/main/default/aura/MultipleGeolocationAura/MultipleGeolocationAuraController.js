({
    doInit : function(component, event, helper) {
        debugger;
        var selectedVisitDate = component.get("v.SelectedVisitDate");
        var baseURL = 'https://sales-production--mfgcloud--c.sandbox.vf.force.com/apex/MultipleGeolocationVF?id='+selectedVisitDate;
        console.log('baseURL === >'+baseURL);
        component.set("v.siteURL",baseURL);
    },
    
})