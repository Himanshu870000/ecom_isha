public class Deal_Trigger_Helper {
    
    public Static boolean runTrigger = true;
    public static void CreateDocumentCategories(List<Deal__c> DealList){
        String document_cat = [select Category_Names__c from Document_Categories__c].Category_Names__c;
        List<String> document_cat_list = document_cat.split(',');
        List<Document_Category__c> DocCatListToBeInserted = new List<Document_Category__c>();
        for(Deal__c deal : DealList){
            for(String doccat:document_cat_list){
                Document_Category__c doc_cat = new Document_Category__c();
                doc_cat.Name = doccat;
                doc_cat.Deal__c = deal.Id;
                DocCatListToBeInserted.add(doc_cat);
            } 
        }
        insert DocCatListToBeInserted;
    }
    public static void updateUnitTransfer(List<Deal__c> DealList){
        system.debug('Trigger to update Unit Fired');
       
        List<Deal__c> listToBeUpdated = new List<deal__C>();//[Select id,Transferred_Unit__c,Deal_Transfer_Approved__c,Unit__c from Deal__c where id in:DealList]; 
        
        for(Deal__c deal : DealList){
            if(deal.Transferred_Unit__c != null && deal.Deal_Transfer_Approved__c == true && deal.Transferred_Unit__c != ''){
                system.debug('Trigger to update Unit @ 24');
                deal.Unit__c = deal.Transferred_Unit__c;
                listToBeUpdated.add(deal);
            }
        }
        system.debug('listToBeUpdated'+listToBeUpdated.size());
        if(listToBeUpdated.size() > 0){
            update listToBeUpdated;
            system.debug('Trigger to update Unit');
        }
    }
    
}