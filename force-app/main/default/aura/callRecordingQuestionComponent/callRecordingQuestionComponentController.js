({
    doInit : function(component, event, helper) {
        debugger;
        var action = component.get("c.fetchQuestions");
        action.setParams({
            recordId : component.get('v.recordId')
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state=='SUCCESS'){
                var result = response.getReturnValue();
                component.set('v.QuestionListRecord', result);
            }else{
                alert('Some Error Occured! Please try again later.');
            }
        });
        $A.enqueueAction(action);
    },
    
    createQuestionLineItemSave : function(component, event, helper){
        debugger;
        var action = component.get('c.handleSave');
        action.setParams({
           queList : component.get('v.QuestionListRecord')
        });
        action.setCallback(this, function(response){
            if(response.getState() == 'SUCCESS'){
                helper.showSuccess(component, event, helper);
            }
            else{
                alert('Some Error Occurred!')
            }
        });
    },
    handleOptionChange: function(component, event, helper){
        debugger;
    },
    
})