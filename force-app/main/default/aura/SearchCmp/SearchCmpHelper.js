({
	SearchHelper : function(component, event, helper) {
        debugger;
        var action = component.get('c.getAccounts');
        action.setCallback(this,function(actionResult){
            component.set('v.accList', actionResult.getReturnValue());
        });
        $A.enqueueAction(action); 
        //  searchKey : component.get("v.searchKeyword"),             
    }

})