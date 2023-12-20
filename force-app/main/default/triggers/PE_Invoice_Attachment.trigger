trigger PE_Invoice_Attachment on Invoice_Attacment__e (after insert) {
    system.debug('After Insert');
    List<Id> invIdset = new List<Id>();
    
    for(Invoice_Attacment__e invoiceAttRec : trigger.newMap.values()){
        TaxInvoiceHelper.attachPdf(invoiceAttRec.Iinvoice__c);
        //invIdset.add(invoiceAttRec.Iinvoice__c);
    }
    if(!invIdset.isEMpty()){
        //AfterInsertInvoicePDF.insertInvoiceAttachemt(invIdset);
    }
}