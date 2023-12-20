({
    doInit : function(component, event, helper) {
            debugger;
           var value = helper.getParameterByName(component , event, 'inContextOfRef');
           var context = JSON.parse(window.atob(value));
           var newContext = JSON.stringify(context);
           component.set('v.recordId',context.attributes.recordId);
         
    }
   })