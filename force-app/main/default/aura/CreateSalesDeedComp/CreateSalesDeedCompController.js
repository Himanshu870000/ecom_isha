({  
    
    onInit : function( component, event, helper ) {    
        
        let action = component.get( "c.generatesalesdeedDoc" );  
        action.setParams({  
            dealId: component.get( "v.recordId" ),
            fileName : 'Sales Deed'
        });  
        action.setCallback(this, function(response) {  
            let state = response.getState();  
            if ( state === "SUCCESS" ) {  
                $A.get("e.force:closeQuickAction").fire();  
                $A.get('e.force:refreshView').fire();   
                
            }  else {
                
                let showToast = $A.get( "e.force:showToast" );
                showToast.setParams({
                    title : 'Testing Toast!!!',
                    message : 'Document was Not generated.' ,
                    type : 'error',
                    mode : 'sticky',
                    message : 'Some error occured'
                });
                showToast.fire();
                
            }
        });  
        $A.enqueueAction( action );         
        
    }
    
})