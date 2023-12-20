({
    doInit : function(component, event, helper){
        
        if(component.get("v.SearchKeyWord"))
            component.set("v.filled",true);
    },
    
    onfocus : function(component,event,helper){
        $A.util.addClass(component.find("mySpinner"), "slds-show");
        var forOpen = component.find("searchRes");
        $A.util.addClass(forOpen, 'slds-is-open');
        $A.util.removeClass(forOpen, 'slds-is-close');
        // Get Default 5 Records order by createdDate DESC  
        var getInputkeyWord = '';
        helper.searchHelper(component,event,getInputkeyWord);
    },
    onblur : function(component,event,helper){       
        component.set("v.listOfSearchRecords", null );
        var forclose = component.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
    },
    createNewCompany: function(component,event,helper){   
    	
        component.set("v.displayNewCandidate",true);
    },
    
    keyPressController : function(component, event, helper) {
        // get the search Input keyword   
        debugger;
        var getInputkeyWord = component.get("v.SearchKeyWord");
        
        // check if getInputKeyWord size id more then 0 then open the lookup result List and 
        // call the helper 
        // else close the lookup result List part.   
        if( getInputkeyWord.length > 0 ){
            var forOpen = component.find("searchRes");
            $A.util.addClass(forOpen, 'slds-is-open');
            $A.util.removeClass(forOpen, 'slds-is-close');
            helper.searchHelper(component,event,getInputkeyWord);
        }
        else{  
            component.set("v.listOfSearchRecords", null ); 
            var forclose = component.find("searchRes");
            $A.util.addClass(forclose, 'slds-is-close');
            $A.util.removeClass(forclose, 'slds-is-open');
        }
    },
    
    // function for clear the Record Selaction 
    clear :function(component,event,heplper){
        debugger;
        
        var pillTarget = component.find("lookup-pill");
        var lookUpTarget = component.find("lookupField"); 
        
        $A.util.addClass(pillTarget, 'slds-hide');
        $A.util.removeClass(pillTarget, 'slds-show');
        
        $A.util.addClass(lookUpTarget, 'slds-show');
        $A.util.removeClass(lookUpTarget, 'slds-hide');
        //component.set("v.selectedRecord.lookupObj" , {});
        component.set("v.SearchKeyWord",null);
        component.set("v.listOfSearchRecords", null );
        component.set("v.selectedRecord", {} );  
        
        var mainList = component.get("v.mainList");
        
        //var parentId = component.get("v.parentId");
        mainList.forEach(function(item,index){
                item.lookupObj = {};
                //component.set("v.displayLabel",selectedAccountGetFromEvent.Name);
                component.set("v.SearchKeyWord","");
                component.set("v.filled",false);
                // no need to break here since we are using forEach which is more efficient than for
           
        });
        component.set("v.mainList",mainList);
    },
    
    // This function call when the end User Select any record from the result list.   
    handleComponentEvent : function(component, event, helper) {
        debugger;
        // get the selected Account record from the COMPONETN event 	 
        var selectedAccountGetFromEvent = event.getParam("recordByEvent");
        
        var mainList = component.get("v.mainList");
        
        //var parentId = component.get("v.parentId");
        mainList.forEach(function(item,index){
                item.lookupObj = JSON.parse(JSON.stringify(selectedAccountGetFromEvent));
                component.set("v.displayLabel",selectedAccountGetFromEvent.Name);
                component.set("v.SearchKeyWord",selectedAccountGetFromEvent.Name);
                component.set("v.filled",true);
                // no need to break here since we are using forEach which is more efficient than for
        });
        
        component.set("v.mainList",mainList);
        var forclose = component.find("lookup-pill");
        $A.util.addClass(forclose, 'slds-show');
        $A.util.removeClass(forclose, 'slds-hide');
        
        var forclose = component.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
        
        //var lookUpTarget = component.find("lookupField");
        //$A.util.addClass(lookUpTarget, 'slds-hide');
        //$A.util.removeClass(lookUpTarget, 'slds-show');  
        
    },
})