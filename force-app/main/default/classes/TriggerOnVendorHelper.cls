public class TriggerOnVendorHelper {
    
    Public static void documentCaegories(LIst<vendor__c> newVendores){
        String document_cat = [select Category_Names__c from Category_Names__mdt WHERE Label = 'Vendor'].Category_Names__c;
        List<String> document_cat_list = document_cat.split(',');
        List<Document_Category__c> DocCatListToBeInserted = new List<Document_Category__c>();
        for(vendor__c vndRecord :newVendores){
            for(String doccat:document_cat_list){
                Document_Category__c doc_cat = new Document_Category__c();
                doc_cat.Name = doccat;
                doc_cat.Vendor__c = vndRecord.Id;
                DocCatListToBeInserted.add(doc_cat);
            } 
        }
        insert DocCatListToBeInserted;
    }
}