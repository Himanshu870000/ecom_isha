({  
    doInit :  function(component, event, helper) {
        debugger;
        var accId = component.get("v.accountId");
        console.log('accId'+accId);
        debugger;
        component.set('v.withoutlabel',true);
        component.set('v.withlabel',false);
        component.set('v.dashBoard',true);
    },
    
	toggleRightSidebar: function(component, event, helper) {
        component.set('v.right',false);
        component.set('v.left',true);
        component.set('v.withlabel',true);
        component.set('v.withoutlabel',false);
        
    },
    
    toggleLeftSidebar: function(component, event, helper) {
        component.set('v.left',false);
        component.set('v.right',true);
        component.set('v.withlabel',false);
        component.set('v.withoutlabel',true);
      
    },
    navigateMenuDetails : function(component,event,helper){
        component.set('v.menus',true);
        component.set('v.icons',true);
        component.set('v.dashBoard',false);
        component.set('v.dealerProduct',false);
        component.set('v.livInventory',false);
        component.set('v.order',false);
        component.set('v.invoice',false);
        component.set('v.goalSetting',false);
    },
    
    navigateDB : function(component, event, helper) {
        debugger;
       	
        component.set('v.dashBoard',true);
        
        component.set('v.dealerProduct',false);
        component.set('v.livInventory',false);
        component.set('v.order',false);
        component.set('v.invoice',false);
        component.set('v.goalSetting',false);
	},
    
    navigateProd : function(component, event, helper) {
        component.set('v.dashBoard',false);
        component.set('v.livInventory',false);
        component.set('v.order',false);
        component.set('v.invoice',false);
        component.set('v.dealerProduct',true);
        component.set('v.goalSetting',false);
	},
    
    navigateLivInv : function(component, event, helper) {
        component.set('v.dashBoard',false);
        component.set('v.dealerProduct',false);
        component.set('v.order',false);
        component.set('v.invoice',false);
        component.set('v.goalSetting',false);
        component.set('v.livInventory',true);
	},
    
    navigateOrd : function(component, event, helper) {
        component.set('v.dashBoard',false);
        component.set('v.dealerProduct',false);
        component.set('v.livInventory',false);
        component.set('v.invoice',false);
        component.set('v.goalSetting',false);
        component.set('v.order',true);
	},
    
    navigateGSetting : function(component, event, helper) {
        component.set('v.dashBoard',false);
        component.set('v.dealerProduct',false);
        component.set('v.livInventory',false);
        component.set('v.invoice',false);
        component.set('v.order',false);
        component.set('v.goalSetting',true);
	},
    
    navigateInv : function(component, event, helper) {
        component.set('v.dashBoard',false);
        component.set('v.dealerProduct',false);
        component.set('v.livInventory',false);
        component.set('v.order',false);
        component.set('v.goalSetting',false);
        component.set('v.invoice',true);
        
	},
})