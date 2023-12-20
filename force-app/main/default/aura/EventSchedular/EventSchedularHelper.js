({
    getDaysAndDate: function(component,event,helper){
        
        var recId = '0050B0000082G6d';//component.get("v.recordId")
        var action = component.get("c.getDaysAndTime");
        action.setParams({
            "RecordId": recId
        });
        action.setCallback(this, $A.getCallback(function(response) {
            var state = response.getState();
            var storeResponse = response.getReturnValue();
            
            if (state == "SUCCESS") {
                {
                    if(storeResponse != null){
                        var custs = [];
                        var conts = response.getReturnValue()[0].daysAndTime;
                        for(var key in storeResponse[0].daysAndTime){
                            custs.push({value:conts[key], key:key});
                        }
                        component.set('v.SelStartDate',storeResponse[0].currentdayAndTime);
                        component.set('v.SelEndDate',storeResponse[0].currentdayAndTime);
                        component.set('v.Hostname',storeResponse[0].UserName);
                        component.set('v.HostEmail',storeResponse[0].Email);
                        component.set('v.HostCut',storeResponse[0].ShortName);
                    }
                }
            }else{}
        }));
        $A.enqueueAction(action);
    },
    
})