trigger InvoicesTrigger1 on Invoices__c (after update) {
    
    if(trigger.isAfter && trigger.isUpdate){
        List<id> invIdset = new List<Id>();
        system.debug('After Insert--->');
    
        for(Invoices__c inv : trigger.new){
            if(inv.Status__c !=null &&  inv.Status__c == 'Realized' && (trigger.oldMap).get(inv.Id).Status__c != inv.Status__c){
                invIdset.add(inv.id);    
            } 
        }
        system.debug('invIdset--->'+invIdset);
        if(invIdset.size() > 0){
            List<Invoice_Attacment__e> invAttachmentList = new List<Invoice_Attacment__e>();
            for(Id invoiceId : invIdset){
                Invoice_Attacment__e invAtt = new Invoice_Attacment__e();
                invAtt.Iinvoice__c = invoiceId;
                //insert invAtt;
                invAttachmentList.add(invAtt);               
            }
            if(!invAttachmentList.isEmpty()){
                List<Database.SaveResult> results = EventBus.publish(invAttachmentList);
                
            }
            
            //AfterInsertInvoicePDF.insertInvoiceAttachemt(invIdset); 
        }
    }
}