/**
 * @author [Dinesh Baddawar]
 * @email dinesh.b@utilitarianLab.com
 * @create date 2023-04-25 13:28:57
 * @modify date 2023-04-25 13:28:57
 * @desc [description]
 */

public class ITW_InvoicPDFController {
    Public String recordId {get;set;}
    Public Invoices__c getInvRecord {get;set;}
    Public Opportunity getOppRecprd {get;set;}
    Public List<OpportunityLineItem> oppLineItemList {get;set;}
    public String invoiceDate {get;set;}
     public ITW_InvoicPDFController(ApexPages.StandardController controller) {
     recordId = controller.getId();
     System.debug('recordId === >'+recordId);
     if(!String.isBlank(recordId)){
      getInvRecord = [SELECT Id,Name,Account__c,Quote__c,Invoice_Date__c,Opportunity__c,Payment_Terms_Net__c,Status__c,Account__r.Name,Account__r.BillingStreet,Account__r.BillingCity,Account__r.BillingState, Quote__r.Name, Quote__r.BillingStreet, Quote__r.BillingCity, Quote__r.BillingState, Quote__r.BillingPostalCode, Quote__r.BillingCountry, Quote__r.ShippingStreet, Quote__r.ShippingCity, Quote__r.ShippingState, Quote__r.ShippingPostalCode,Quote__r.ShippingCountry,Quote__r.BillingName,Quote__r.ShippingName FROM Invoices__c WHERE Id=:recordId];
      System.debug(' geInvRecord === >'+getInvRecord);
      if(!String.isBlank(getInvRecord.Opportunity__c)){
        oppLineItemList = [SELECT Id,Name,Product2.Name,Product2Id,TotalPrice,Discount,ProductCode,ListPrice,UnitPrice,Quantity,Batch_No__c FROM OpportunityLineItem WHERE OpportunityId =:getInvRecord.Opportunity__c];
      }
     }
   }

   @AuraEnabled
   public Static String generateITW_Invoice(string recordId){
    try{
      if(!String.isBlank(recordId)){
        List<Attachment> attachmentList = new List<Attachment>();
        PageReference pageRef = page.ITW_InvoicePDF;
        pageRef.getParameters().put('id',recordId);
        blob vBody;
        vBody=pageRef.getContent();
        Attachment attach = new Attachment();
        attach.Body = vBody;
        attach.Name = 'ITW_Invoice'+'_'+System.now()+'.pdf';
        attach.ParentId = recordId;
        attach.ContentType = 'application/pdf';
        attachmentList.add(attach);
        if(!attachmentList.isEmpty()){
            insert attachmentList;
            system.debug('attachmentList ID==>' +attachmentList[0].Id);
        }
        return 'Success';
      }
    }catch(Exception e){
      System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
    }
    return null;
   }
}