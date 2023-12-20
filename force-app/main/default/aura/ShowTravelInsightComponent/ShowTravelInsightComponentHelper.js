({
    helperMethod : function(component ,event ,helper,MonthName,year) {
        
        var action = component.get('c.getMonthlyRecord');
        action.setParams({ 
            month:MonthName,
            year:year
        });
        action.setCallback(this, function(response) {
            if(response.getState() === "SUCCESS"){
                var data = response.getReturnValue();
                if(data !=null && data.length >0){
                    var resultdata = data;
                    for(var i in resultdata){
                        resultdata[i].CreatedDateFormatted = resultdata[i].CreatedDate.slice(0,10);
                        var reAmount = resultdata[i].Total_Distance__c * 18;
                        resultdata[i].TotalCost = reAmount.toFixed(2);
                    }
                    component.set("v.dataList",resultdata);
                    // alert(JSON.stringify(data.dayVisitPlanList)) 
                }else{
                    component.set('v.dataList', []);
                }
            }
        });
        $A.enqueueAction(action);
        
    },
    
    getMTEId : function(component ,event, helper){
        debugger;
        var month = component.get("v.selectedMonth");
        var year = component.get("v.selectedYear");
        var action = component.get('c.saveFilesUnderMTE');
        action.setParams({
            month:month,
            year:year
        });
        action.setCallback(this, function(response){
           var state = response.getState();
            if(state === 'SUCCESS'){
                var result = response.getReturnValue();
                component.set('v.MTEId', result);
                console.log
            }
        });
        $A.enqueueAction(action);
    }
})