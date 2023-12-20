({
	 check_exist_jira_issue : function(component,recordID) {
         debugger;
        var action=component.get('c.check_exist_jira_issue');
        action.setParams({
            caseID:recordID
        });
        console.log(component.get('v.recordId'));
        console.log(action.getParams());
        action.setCallback(this,function(response){
           	console.log(response.getReturnValue()); 
            console.log(response.getState());
            if(response.getState()==='SUCCESS')
            {
            	component.set('v.existRecord',response.getReturnValue());    
            }
            
        });
        $A.enqueueAction(action);
    }
})