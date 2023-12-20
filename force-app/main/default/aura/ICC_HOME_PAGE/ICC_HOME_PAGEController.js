({
	clickHandler : function(component, event, helper) {
		alert('You can jump in to Dashboard from here');
	},
   /* clickHandler2 : function(component, event, helper) {
		alert('From here you can jump into icc events ');
	}*/
    clickHandler2 : function(component, event, helper) {
        debugger;
         component.set("v.Dispatched", !component.get("v.Dispatched"));
       /* var button = component.find("v.abc" );
        var value = buttont.get("v.value");
        
        if(Value==false){
            component.set("v.flag" ,true);
        }else{
            component.set("v.flag" ,false);
        }*/
       		
	}
    
})