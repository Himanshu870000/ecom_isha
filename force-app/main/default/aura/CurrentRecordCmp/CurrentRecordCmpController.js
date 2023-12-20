({
    doInit : function(component, event, helper) {
        var recordId = component.get('v.recordId');
        helper.check_exist_jira_issue(component,recordId);
    }
})