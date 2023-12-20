({
    check_exist_jira_issue : function(component,recordID) {	
        var action=component.get('c.check_exist_jira_issue');
        action.setParams({
            caseID:recordID
        });
        console.log(component.get('v.recordId'));
        console.log(action.getParams());
        action.setCallback(this,function(response){
           	console.log(response.getReturnValue().exist); 
            console.log(response.getState());
            if(response.getState()==='SUCCESS')
            {
            	component.set('v.existRecord',response.getReturnValue().exist);    
            }
            
        });
        $A.enqueueAction(action);
    }
})