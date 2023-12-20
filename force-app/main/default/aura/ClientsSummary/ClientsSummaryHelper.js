({
    getCardData: function(component) {
        debugger;
        // Sample data for demonstration purposes
        var action = component.get('c.getAllAccountCount');
        action.setCallback(this,function(response){
            if(response.getState() === 'SUCCESS'){
                var result = response.getReturnValue();
                if(result != null){
                    var oppRecCount = result.oppToatlCount;
                    var accETBRecCount = result.accETBCount;
                    var accNTBRecCount = result.accNTBCount;
                    var accLCRecCount = result.accLCCount;
                    var cardData = [
                        { Title: 'Total Prospects', Description:''  ,cl: '#62b7ed' ,Padding: '2%', View: 'View' ,listviewId: '00B0T000001ieqhUAA', wi:'70%' ,ml:'14%' ,br:'8px' ,mr:'-1%', scope:'Lead'},
                        { Title: 'Active Accounts', Description: '' ,cl: '#62b7ed' ,Padding: '2%' ,View: 'View' ,listviewId: '00B0k000002cOcgEAE',wi:'70%' ,ml:'14%' ,br:'8px' ,mr:'0%', scope:'Account'},
                        { Title: 'New Accounts', Description: '' ,cl: '#62b7ed' ,Padding: '2%' ,View: 'View' ,listviewId: '00B0k000002cOclEAE',wi:'70%' ,ml:'14%' ,br:'8px' ,mr:'0%', scope:'Account'},
                        { Title: 'Inactive Accounts', Description: '' ,cl: '#62b7ed' ,Padding: '2%' ,View: 'View' ,listviewId: '00B0k000002cOcqEAE',wi:'70%' ,ml:'14%' ,br:'8px' ,mr:'-1%', scope:'Account'}
                    ];
                    var temparray = [];
                    for(var i in cardData){
                        if(cardData[i].Title == 'Total Prospects'){
                            cardData[i].Description = oppRecCount;
                            temparray.push(cardData[i].Description);
                        }
                        if(cardData[i].Title == 'Active Accounts'){
                            cardData[i].Description = accETBRecCount;
                            temparray.push(cardData[i].Description);
                        }
                        if(cardData[i].Title == 'New Accounts'){
                            cardData[i].Description = accNTBRecCount;
                            temparray.push(cardData[i].Description);
                        }
                        if(cardData[i].Title == 'Inactive Accounts'){
                            cardData[i].Description = accLCRecCount;
                            temparray.push(cardData[i].Description);
                        }
                    }
                    // Set the data in the component attribute
                    component.set('v.cardData', cardData);
                }
            }            
        });
        $A.enqueueAction(action);
        
    }
})