public class OpportunityInvoiceCreation {

    @AuraEnabled
    public static Boolean createInvoices(Id oppId){
        
        try{
            system.debug('oppId::'+oppId);
            List<Invoice__c> invoices=new List<Invoice__c>();
            //Invoice_Due_Period__mdt duePeriod=[ Select Id,Due_Periods__c from Invoice_Due_Period__mdt ];
            //Invoice_Tax__mdt tax=  [Select Id,Tax_Amount__c from Invoice_Tax__mdt];
            list<opportunity> opportunityList = [SELECT Id,No_of_Invoices__c,Amount FROM Opportunity WHERE No_of_Invoices__c!=null AND Id=:oppId];
            decimal oppAmount = 0;
            integer invoiceCount = 0;
            Integer invoiceMonthGap = 0;
            for(opportunity oppDetails : opportunityList){
                oppAmount = oppDetails.Amount;
                invoiceCount = integer.valueOf(oppDetails.No_of_Invoices__c);
                invoiceMonthGap=12/invoiceCount;
            }
            date tempEndDate = system.today();
            for(integer i=0;i<invoiceCount;i++){
                Invoice__c invoiceToCreate=new Invoice__c();
                invoiceToCreate.Amount__c=oppAmount/invoiceCount;
                if(i==0){
                    invoiceToCreate.Invoice_Date__c=date.today();
                }else{
                    invoiceToCreate.Invoice_Date__c = tempEndDate + 1;
                }
                invoiceToCreate.Opportunity__c=oppId;
                invoiceToCreate.Due_Date__c = invoiceToCreate.Invoice_Date__c + 15;
                invoiceToCreate.Invoice_End_Date__c = invoiceToCreate.Invoice_Date__c.addMonths(invoiceMonthGap) - 1;
                tempEndDate = invoiceToCreate.Invoice_End_Date__c;
                invoices.add(invoiceToCreate);
            }
            system.debug('invoices::'+invoices);
            if(invoices.size()>0){
                insert invoices;
                return true;
            }
            return false;
            
        }catch(Exception ex){
            System.debug(ex.getCause());
            System.debug(ex.getLineNumber());
            System.debug(ex.getMessage());
            return false;
        }
    }
}