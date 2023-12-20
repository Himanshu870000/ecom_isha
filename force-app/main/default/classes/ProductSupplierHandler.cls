public class ProductSupplierHandler {
    public static void tagFinalVendor(List<Product_Supplier__c> psList,Map<Id,Product_Supplier__c> mapofOldPS){
        Set<Id> opportunityIdSet = new Set<Id>();
        Map<Id,Id> mapofOppIdBySupplierId = new Map<Id,Id>();
        for(Product_Supplier__c ps : psList){
            if(ps.Final_Vendor__c != mapofOldPS.get(ps.Id).Final_Vendor__c && ps.Final_Vendor__c){
                if(ps.Requisition__c != null){
                    opportunityIdSet.add(ps.Requisition__c);
                    mapofOppIdBySupplierId.put(ps.Requisition__c,ps.Vendor__c);
                }
            }
        }
        
        if(!opportunityIdSet.isEmpty()){
            List<Opportunitylineitem> oliList = [select id,Vendor__c,opportunityid from OpportunityLineItem where opportunityid in: opportunityIdSet];
            
            for(Opportunitylineitem oli : oliList){
                oli.Vendor__c = mapofOppIdBySupplierId.get(oli.opportunityid);
            }
            update oliList;
        }
    }
}