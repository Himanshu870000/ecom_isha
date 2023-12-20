({
	 addLeadNurtureRecord: function(component, event,helper) {
        debugger;
        var LeadNurturelist1 = component.get("v.leadNurturelist");
        LeadNurturelist1.push({
            'sobjectType': 'Lead_Nurture_Step__c',
            'Name': '',
            'Start_Date__c': '',
            'End_Date__c': '' ,
            'Description__c': '',
            'Status__c': 'Schedule',
            'Tobealerted': '',
            'TobeGreenSignalled': '',
            'User__c':''
        });
         
         component.set("v.leadNurturelist", LeadNurturelist1);
    }, 
	validateNurturetList: function(component, event,helper) {
        debugger;
        var isValid = true;
        var leadNurturelist2 = component.get("v.leadNurturelist");
        for (var i = 0; i < leadNurturelist2.length; i++) {
            if (leadNurturelist2[i].Name == '') {
                isValid = false;
                alert('Account Name cannot be blank on row number ' + (i + 1));
            }
        }
        return isValid;
    },
    
    checkNurOnLead : function(component, event){
        debugger;
        var action = component.get("c.checkLeadNurStep");
       
        action.setParams({
            "leadId" : component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            if(response.getState() === "SUCCESS"){
                var data = response.getReturnValue();
                component.set("v.leadNurturelist", data);
                /*const date = new Date();
                let day = date.getDate();
                let month = date.getMonth() + 1;
                let year = date.getFullYear();
                
                // This arrangement can be altered based on how we want the date's format to appear.
                let currentDate = `${year}-${month}-${day}`;
                for(var i=0; data.length >0; i++){
                    if(data[i].End_Date__c <  currentDate && (data[i].Status__c != 'Completed' || data[i].Status__c == 'Not Completed')){
                        data[i].Tobealerted = true;
                    }
                    else if(data[i].End_Date__c >  currentDate && (data[i].Status__c == 'Completed')){
                        data[i].TobeGreenSignalled = true;
                    }
               }*/
                if(data.length >0){
                    component.set("v.isOpen", true);
                    component.set("v.NorecFound", false);
                }
                else{
                    component.set("v.NorecFound", true);
                    component.set("v.isOpen", false);
                }
            }
        });
        $A.enqueueAction(action);
    }
 
})