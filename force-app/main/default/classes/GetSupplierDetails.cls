public class GetSupplierDetails {

    @AuraEnabled(cacheable=true)
    Public Static List<Product_Supplier__c> GetSuppliers(Id OppProductId){

        List<Product_Supplier__c> ProductSupplierList=[select Id,Name,Vendor__r.Name,Vendor__c From Product_Supplier__c Where Opportunity_Product__c=:OppProductId];

        return ProductSupplierList;

    }

 @AuraEnabled
    Public Static String OpportunityProductStVendor( List<Product_Supplier__c> ProductSupplierRec,Id OppProductId){

        OpportunityLineItem OppLitemRec=new OpportunityLineItem();
        OppLitemRec.Id=OppProductId;
        OppLitemRec.Vendor__c=ProductSupplierRec[0].Vendor__c;

        Update OppLitemRec;

      return 'SUCCESS';

    }
    
    @AuraEnabled
    Public Static List<Vendor__c> GetVendorList(){
        List<Vendor__c> VendorList=[Select Id,Name,Vendor_Email__c,Vendor_Phone__c,Vendor_category__c From Vendor__c];
            
     return VendorList;
    }
    
    @AuraEnabled
    Public Static Void SetVendorDetails(List<Id>VendorList,Id OpportunityId){
        
       List<Product_Supplier__c> PrdSupToInsert=new List<Product_Supplier__c>();
        IF(!VendorList.IsEmpty()){
            for(Id VID:VendorList){
                 Product_Supplier__c ProductSpplierRec=new Product_Supplier__c();
                 ProductSpplierRec.Requisition__c=OpportunityId;
                 ProductSpplierRec.Vendor__c=VID; 
                 PrdSupToInsert.add(ProductSpplierRec);
            } 
        }
        if(!PrdSupToInsert.isEmpty()){
            Insert PrdSupToInsert;
        }
        FSLQuotePDFControllerDemo1.sendQuoteToMultipleVendor(OpportunityId);
        
    }

}