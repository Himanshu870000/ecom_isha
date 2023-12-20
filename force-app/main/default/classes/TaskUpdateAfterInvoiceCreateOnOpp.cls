public class TaskUpdateAfterInvoiceCreateOnOpp {

    Public Static Void UpdateTaskOnInvCreate(List<Invoice__c>InvoiceRec){
        set<Id> OppIdset=new Set<Id>();
        for(Invoice__c Inv:InvoiceRec){
            if(Inv.Opportunity__c!=null){
                OppIdset.add(Inv.Opportunity__c);
            }
        }
        List<Task> taskListTobeUpdate = [select id,Status from task where whatId in:OppIdset and Subject ='Generate Perfoma Invoice'];
        for(Task ts : taskListTobeUpdate){
            ts.Status = 'Completed';
        }
        update taskListTobeUpdate;
    }
}