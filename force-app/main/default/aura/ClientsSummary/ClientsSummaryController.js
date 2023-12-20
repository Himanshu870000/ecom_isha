({
	init: function(component, event, helper) {
        helper.getCardData(component);
    },
    getrecord: function(component, event, helper) {
        debugger;
        var listviewId = event.target.dataset.id;
        var scope = event.target.dataset.value;
        //var listviews = response.getReturnValue();
        var navEvent = $A.get("e.force:navigateToList");
            navEvent.setParams({
                "listViewId": listviewId,
                "listViewName": null,
                "scope": scope
            });
            navEvent.fire();
    }
})