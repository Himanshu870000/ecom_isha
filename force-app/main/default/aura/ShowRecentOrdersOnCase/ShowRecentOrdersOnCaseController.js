({
    fetchOrders : function(component, event, helper) {
        component.set('v.mycolumns', [
            {label: 'Order Number', fieldName: 'OrderNumber', type: 'text'},
            {label: 'Account Name', fieldName: 'AccountName', type: 'text'},
            {label: 'Order Start Date', fieldName: 'EffectiveDate', type: 'Date'},
            {label: 'Order Amount', fieldName: 'TotalAmount', type: 'decimal '},
            {label: 'Status', fieldName: 'Status', type: 'text '}
        ]);
        var action = component.get("c.fetchOrderList");
        action.setParams({
            'caseId' : component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var rows = response.getReturnValue();
                for (var i = 0; i < rows.length; i++) {
                    var row = rows[i];
                    if (row.Account) row.AccountName = row.Account.Name;
                }
                component.set('v.orderList', rows);
            }
        });
        $A.enqueueAction(action);
    }
})