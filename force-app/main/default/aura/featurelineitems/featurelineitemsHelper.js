({
    helperMethod : function(component) {
        debugger;
        const featureList = component.get('v.SelectedProductOptions');
        var featureName = component.get('v.FeatureName');
        const tempList = [];
        for (let index = 0; index < featureList.length; index++) {
            if (featureList[index].FeatureId__r.Name == featureName) {
                tempList.push(featureList[index]);
                component.set('v.tempList',tempList);
            }
            
        }
        console.log('Temp List Feature--',JSON.stringify(tempList));

    },
     /*selectSingleOption:function(component, event, helper) {
        debugger;
        var OptionrecId = event.currentTarget.dataset.id;
        
        var SelectedOptionRec=component.get("v.selectedQLI");
        
        var recId = event.currentTarget.dataset.id;
         
        var TempFeatureList = component.get("v.SelectedProductOptions");
         
         var tempExistingList = [];
         
         if(component.get("v.selectedQLI").length > 0){
             tempExistingList = component.get("v.selectedQLI");
         }
        console.log('TempFeatureList--',JSON.stringify(TempFeatureList));
        
        if(event.target.checked){
            
            for(var i = 0;i<TempFeatureList.length;i++){
                if(TempFeatureList[i].Id == recId){
                    SelectedOptionRec.push(TempFeatureList[i]);
                }
            }
            
            component.set("v.selectedQLI",SelectedOptionRec);
            
            
            
          /*if(SelectedOptionRec.find(item=>item.Id==recId)){
             console.log('This Id Exists');
          }
         else{
             SelectedOptionRec.push(TempFeatureList.find(record => record.Id === recId));
                       for(let i=0;i<SelectedOptionRec.length;i++){
                           tempExistingList.push(SelectedOptionRec);
                           
                         //TempProductOptions.push(SelectedOptionRec);
                      } 
             component.set("v.selectedQLI",SelectedOptionRec);
           } */   
       /*}else{
            SelectedOptionRec = SelectedOptionRec.filter(record => record.Id !== recId);
        }
          console.log(JSON.stringify(component.get("v.selectedQLI"))) ;       
        component.set("v.SelectedOptions", SelectedOptionRec); 
        //console.log('TempProductOptions--',JSON.stringify(TempProductOptions));
       console.log('SelectedProductOptions--',JSON.stringify(SelectedOptionRec));
        
    },*/
    selectSingleOption: function(component,event,helper){
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
                if(SelectedOptionRec.find(item=>item.Id==checkvalue.get("v.text"))){
                        console.log('This Id Exists')
                    }
                    else{
                        SelectedOptionRec.push(TempFeatureList.find(record => record.Id === checkvalue.get("v.text"))); 
                    }
                //SelectedOptionRec = SelectedOptionRec.filter(record => record.Id !== checkvalue[i].get("v.text"));
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
})