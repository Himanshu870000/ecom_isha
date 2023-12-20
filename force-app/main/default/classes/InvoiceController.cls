public class InvoiceController {
	@AuraEnabled
    public static List<Order_Invoices__c> getInvoiceList(Integer pageSize, Integer pageNumber, string accountId){
        Integer offset = (pageNumber - 1) * pageSize;
        List<Order_Invoices__c> invList = new List<Order_Invoices__c>();
        invList = [Select Id,Name,Invoice_Date__c,Due_Date__c,Status__c FROM Order_Invoices__c WHERE Account__c=:accountId LIMIT :pageSize OFFSET :offset];
        return invList;
        
    }
}