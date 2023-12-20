({
	 doInit : function(component, event, helper){
         debugger;
         var recId='0Q05i000000IwWJCA0';
         var ValueOfQuoteScreen=true;
         var ValueOfTableScreen=false;
     var action = component.get("c.QuoteLineItemRecs");
          action.setParams({ 
            "recordId" : component.get("v.recordId")
              
          });
              //component.get("v.recordId")
              var quoteRecId=component.get("v.recordId");
                console.log('quoteRecId',JSON.stringify(quoteRecId));
              component.set("v.QuoterecordId",quoteRecId);
         
          action.setCallback(this, function(response) {
            var state = response.getState();
              if(state==='SUCCESS'){
                    var responseValue = response.getReturnValue();
                    component.set("v.QuoteLineItemlist",responseValue);
              }   
        });
         component.set("v.QuoteTableScreen",ValueOfQuoteScreen);
         component.set("v.ProductTableScreen",ValueOfTableScreen);
         
        $A.enqueueAction(action);
		
	},
    handleClickAddProduct : function(component, event, helper) {
          var  ValueOfQuoteScreen=false;
          var ValueOfProductTableScreen=true;
          component.set("v.QuoteTableScreen",ValueOfQuoteScreen);
          component.set("v.ProductTableScreen",ValueOfProductTableScreen);
        
          var action = component.get("c.ProductRecs");
           action.setCallback(this, function(response) {
            var state = response.getState();
              if(state==='SUCCESS'){
                    var responseValue = response.getReturnValue();
                    component.set("v.Productlist",responseValue);
                }
               console.log('responseValue',responseValue);
        });
        $A.enqueueAction(action);
    },
            onCheck: function(cmp, evt) {
                debugger;
                 var checkCmp = cmp.find("checkbox");
                console.log('checkCmp.get("v.value")::'+checkCmp.get("v.value"));
                 resultCmp = cmp.find("checkResult");
                 resultCmp.set("v.value", ""+checkCmp.get("v.value"));
        $A.enqueueAction(action);
             },
    selectSingleProduct: function(component,event,helper){
        debugger;
        var TempProducts=[];
        var SelectedProductIds=component.get("v.AllProductIds");
        var SelectedProducts=component.get("v.selectedProductList");
        
        TempProducts = component.get("v.Productlist");
        
     var selectedContacts = [];
        var checkvalue = component.find("checkContact");
         
        if(!Array.isArray(checkvalue)){
            if (checkvalue.get("v.value") == true) {
                selectedContacts.push(checkvalue.get("v.text"));
                SelectedProducts = SelectedProducts.filter(record => record.Id !== checkvalue[i].get("v.text"));
            }
        }else{
            for (var i = 0; i < checkvalue.length; i++) {
                if (checkvalue[i].get("v.value") == true) {
                    selectedContacts.push(checkvalue[i].get("v.text"));
                    if(SelectedProducts.find(item=>item.Id==checkvalue[i].get("v.text"))){
                        console.log('This Id Exists')
                    }
                    else{
                        SelectedProducts.push(TempProducts.find(record => record.Id === checkvalue[i].get("v.text"))); 
                    }
                    
                }
            }
        }
        component.set("v.selectedProductList", SelectedProducts);
        
        component.set("v.AllProductIds", selectedContacts);
         console.log('SelectedProducts--',JSON.stringify(SelectedProducts));
        console.log('SelectedProductIds--',JSON.stringify(SelectedProductIds));
    },
    
    /*selectSinglerec: function(component,event,helper){
        debugger;
        var TempProducts=[];
        var SelectedProductIds=component.get("v.AllProductIds");
        var SelectedProducts=component.get("v.selectedProductList");
        
        var recId = event.currentTarget.dataset.id;
        
        component.set("v.AllProductIds",recId)
        
        TempProducts = component.get("v.Productlist");
        
       /* var isChecked = component.find("checkContact").get("v.checked");
        console.log("Checkbox is checked: " + isChecked);
        component.set("v.isChecked", isChecked);*/
        
       // console.log('TempProducts--',JSON.stringify(TempProducts));
       /* console.log('value::'+component.find("checkContact"));
        var checkCmp = component.find("checkContact");
        console.log('checkCmp.get("v.value")::'+checkCmp.get("v.value"));*/
        /*if(event.target.checked){
          if(SelectedProducts.find(item=>item.Id==recId)){
             console.log('This Id Exists')
          }
         else{
             SelectedProducts.push(TempProducts.find(record => record.Id === recId));
             SelectedProductIds.push(recId);
           }    
        }else{
            SelectedProducts = SelectedProducts.filter(record => record.Id !== recId);
            SelectedProductIds=SelectedProductIds.filter(record => record !== recId);
        }
        component.set("v.selectedProductList", SelectedProducts);
        
        component.set("v.AllProductIds", SelectedProductIds);
        
       console.log('SelectedProducts--',JSON.stringify(SelectedProducts));
        console.log('SelectedProductIds--',JSON.stringify(SelectedProductIds));
        
    },*/
    
    //This Save Button Will Be Used Configurable Product
    handleClickSaveProduct:function(component, event, helper) {
        debugger;
        var TempEmptyArray=[];
        var  ValueOfQuoteScreen=true; 
         var ValueOfConfigureProduct=false;
        component.set("v.QuoteTableScreen",ValueOfQuoteScreen);
         component.set("v.ProductOptionScreen",ValueOfConfigureProduct);
        var recId='0Q05i000000IwWJCA0';
         var action = component.get("c.InsertQuoteLineItem");
          action.setParams({
              "ProductList":component.get("v.selectedProductList"),
              "quoteId" : component.get("v.QuoterecordId"),
              "productOptionlist":component.get("v.SelectedOptionlist")
              
          });
              //component.get("v.recordId")
          action.setCallback(this, function(response) {
            var state = response.getState();
              if(state==='SUCCESS'){
                    var responseValue = response.getReturnValue();
                    component.set("v.QuoteLineItemlist",responseValue);
                    component.set("v.SelectedOptionlist",TempEmptyArray);
              }   
        });
         
         
        $A.enqueueAction(action);
    },
    handleEdit:function(component, event, helper) {
        debugger;
        
        component.set("v.showinputfield", true);
    },
    
    handleClickSelect:function(component, event, helper) {
        debugger;
        var ValueOfConfigureProduct=true;
        var ValueOfProductTableScreen=false;
        var Tempvariable=true;
        component.set("v.ProductOptionScreen",ValueOfConfigureProduct);
        component.set("v.ProductTableScreen",ValueOfProductTableScreen);
        var proIds = component.get("v.AllProductIds");
        
        var action = component.get("c.ShowAllOptions");
         action.setParams({ 
            'ProductIds' : proIds
          });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
              if(state==='SUCCESS'){
                    var responseValue = response.getReturnValue();
                    console.log('responseValue In AllMaps--',JSON.stringify(responseValue));
                    component.set("v.SelectedProductOptions",responseValue);
              }   
        });
        /*if(Tempvariable==true){
           
        var action = component.get("c.AllMaps");
        action.setCallback(this, function(response) {
            var state = response.getState();
              if(state==='SUCCESS'){
                    var responseValue = response.getReturnValue();
                    console.log('responseValue In AllMaps--',JSON.stringify(responseValue));
                    //component.set("v.SelectedProductOptions",responseValue);
              }   
        });
     }*/
        $A.enqueueAction(action);
        
     },
    selectSingleOptionRec: function(component,event,helper){
        debugger;
        //var TempProducts=[];
        var SelectedOptionRec=component.get("v.selectedQLI");
        //var SelectedProducts=component.get("v.selectedProductList");
        
        var TempFeatureList = component.get("v.SelectedProductOptions");
        
     var selectedContacts = [];
        var checkvalue = component.find("checkContact");
         
        if(!Array.isArray(checkvalue)){
            if (checkvalue.get("v.value") == true) {
                selectedContacts.push(checkvalue.get("v.text"));
                SelectedOptionRec = SelectedOptionRec.filter(record => record.Id !== checkvalue[i].get("v.text"));
            }
        }else{
            for (var i = 0; i < checkvalue.length; i++) {
                if (checkvalue[i].get("v.value") == true) {
                    selectedContacts.push(checkvalue[i].get("v.text"));
                    if(SelectedOptionRec.find(item=>item.Id==checkvalue[i].get("v.text"))){
                        console.log('This Id Exists')
                    }
                    else{
                        SelectedOptionRec.push(TempFeatureList.find(record => record.Id === checkvalue[i].get("v.text"))); 
                    }
                    
                }
            }
        }
        component.set("v.SelectedOptions", SelectedOptionRec);
        
       // component.set("v.AllProductIds", selectedContacts);
         console.log('SelectedProductOptions--',JSON.stringify(SelectedOptionRec));
        //console.log('SelectedProductIds--',JSON.stringify(SelectedProductIds));
    },
    /*selectSingleOptionRec:function(component, event, helper) {
        debugger;
        var OptionrecId = event.currentTarget.dataset.id;
        
        var TempProductOptions=[];
        
        var SelectedProductOptions=component.get("v.SelectedOptionlist");
        
        var recId = event.currentTarget.dataset.id;
        
        TempProductOptions = component.get("v.SelectedProductOptions");
        console.log('TempProductOptions--',JSON.stringify(TempProductOptions));

        if(event.target.checked){
          if(SelectedProductOptions.find(item=>item.Id==recId)){
             console.log('This Id Exists')
          }
         else{
             SelectedProductOptions.push(TempProductOptions.find(record => record.Id === recId));  
           }    
        }else{
            SelectedProductOptions = SelectedProductOptions.filter(record => record.Id !== recId);
        }
        component.set("v.SelectedOptionlist", SelectedProductOptions); 
       console.log('SelectedProductOptions--',JSON.stringify(SelectedProductOptions));
        
    },*/
    handleClickPrevious:function(component, event, helper) {
       var ValueOfConfigureProduct=false;
        var ValueOfProductTableScreen=true;       
        component.set("v.ProductOptionScreen",ValueOfConfigureProduct);
        component.set("v.ProductTableScreen",ValueOfProductTableScreen); 
    },
    handleClickCalculate:function(component, event, helper) {
        debugger;
        var TempQuoteLineItem=[];
        var TempItem=[];
        var TempQuoteLineItem=component.get("v.QuoteLineItemlist");
        
        var action = component.get("c.GetQuotelineItemlist");
          action.setParams({ 
            "quoteLineItemRec" : TempQuoteLineItem,
              "Isinsertable":false
          });
          action.setCallback(this, function(response) {
            var state = response.getState();
              if(state==='SUCCESS'){
                    var responseValue = response.getReturnValue();
                     console.log('responseValue---',JSON.stringify(responseValue));
                     TempItem=responseValue;
                     console.log('TempItem---',JSON.stringify(TempItem));
                    
              }
              for(var i=0;i<TempItem.length;i++){
                  if(TempItem[i].Discount==null ){
                    TempItem[i]['NetTotal']=TempItem[i].Quantity*TempItem[i].UnitPrice;  
                  }else{
                      console.log('TempItem[i].Discount---',JSON.stringify(TempItem[i].Discount));
                      let Discount=(TempItem[i].Discount/100)*TempItem[i].UnitPrice;
                      console.log('Discount---',JSON.stringify(Discount));
                      let DiscountedPrice=TempItem[i].UnitPrice-Discount;
                      console.log('DiscountedPrice---',JSON.stringify(DiscountedPrice));
                      if(DiscountedPrice!=null){
                         TempItem[i]['NetTotal']=TempItem[i].Quantity*DiscountedPrice; 
                      }  
                  }
                  
              }
              component.set("v.QuoteLineItemlist",TempItem);
              console.log('TempItem After Net Total---',JSON.stringify(TempItem));
          });
        $A.enqueueAction(action);
    },
    handleClickSave:function(component, event, helper) {
        debugger;
        var TempQuoteLineItem=[];
        var TempItem=[];
        var TempQuoteLineItem=component.get("v.QuoteLineItemlist");
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        
        var action = component.get("c.GetQuotelineItemlist");
          action.setParams({ 
            "quoteLineItemRec" : TempQuoteLineItem,
              "Isinsertable":true
          });
          action.setCallback(this, function(response) {
            var state = response.getState();
              if(state==='SUCCESS'){
                    var responseValue = response.getReturnValue();
                     console.log('responseValue---',JSON.stringify(responseValue));
                     dismissActionPanel.fire();     
              }
              
          });
        $A.enqueueAction(action);
    },
    handleComponentEvent : function(component, event, helper) {
        debugger;
    	alert('Event handler at the parent component');
    	
        component.set("v.ProductOptionScreen",false);
        component.set("v.ProductTableScreen",false);
        component.set("v.QuoteTableScreen",true);
        
    	var totalOptions = event.getParam('SelectedOptions');
    	console.log('totalIncome',JSON.stringify(totalOptions));
        var action = component.get("c.InsertQuoteLineItem");
          action.setParams({
              "ProductList":component.get("v.selectedProductList"),
              "quoteId" :component.get("v.recordId"),
              "productOptionlist":totalOptions
              
          });
              //component.get("v.recordId")
          action.setCallback(this, function(response) {
            var state = response.getState();
              if(state==='SUCCESS'){
                    var responseValue = response.getReturnValue();
                    component.set("v.QuoteLineItemlist",responseValue);
                    //component.set("v.SelectedOptionlist",TempEmptyArray);
              }   
        });
        $A.enqueueAction(action);
    }
    
       
})