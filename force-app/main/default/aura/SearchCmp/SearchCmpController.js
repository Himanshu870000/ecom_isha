({
	doInit: function (component, evt, helper) {
      debugger;
      helper.SearchHelper(component, event);
    },
    
    onChange1: function (component, evt, helper) {
        debugger;
       
      //  var selectedLimit = component.find('searchField').get('v.value');
      //  let valueTyp = event.target.value;
        var searchKey = component.find("searchField").get("v.value");
        console.log("searchKey::::::::::"+searchKey);
        var action = component.get("c.findByName");
        action.setParams({
            "searchKey":searchKey
        });
        action.setCallback(this,function(a){
            component.set("v.accList",a.getReturnValue());
            component.set('v.SearchList',true);
        });
        $A.enqueueAction(action); 
        
    }
})