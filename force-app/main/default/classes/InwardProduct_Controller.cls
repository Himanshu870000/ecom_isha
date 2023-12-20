public with sharing class InwardProduct_Controller {
    
    @AuraEnabled(cacheable=true)
    public static List<Transferd_product__c> getTransferredSKUs(String WarehousetansferedlogID){
        System.debug('WarehousetansferedlogID----->'+WarehousetansferedlogID);
        List<Transferd_product__c> TransferredSKUs = [SELECT Id,Inventory__r.Product__r.Name,Quantity__c,Inventory__r.Clinic__r.Name,Received_Quantity__c
                                                   FROM Transferd_product__c WHERE Inventory_Transfer__c =:WarehousetansferedlogID ];
        System.debug('TransferredSKUs ===> ' + TransferredSKUs);
        return TransferredSKUs;
    }

    @AuraEnabled
    public static string SaveTransferLogDetails(List<Transferd_product__c> TransferredSKUs){
        string message = '';
        set<Id> TransfetProdId=new Set<Id>();
        try{
            System.debug('TransferredSKUs ====> ' + TransferredSKUs);
            update TransferredSKUs;
            /*if(!TransferredSKUs.isEmpty()){
                for(Transferd_product__c TP:TransferredSKUs){
                    if(Tp.Id!=null){
                       TransfetProdId.add(Tp.Id); 
                    }
                }
            }
            List<Transferd_product__c> TransferredSKUProd=new List<Transferd_product__c>();
            List<Inventory__c> INVList=new List<Inventory__c>();
            if(!TransfetProdId.isEmpty()){
               TransferredSKUProd = [SELECT Id,Inventory__c,Inventory__r.Product__r.Name,Quantity__c,Inventory__r.Clinic__r.Name,Received_Quantity__c
                                                   FROM Transferd_product__c WHERE Id=:TransfetProdId];
            }

            if(!TransferredSKUProd.isEmpty()){
                for(Transferd_product__c tpr:TransferredSKUProd){
                    if(tpr.Inventory__c!=null){
                        Inventory__c INV=new Inventory__c();
                        INV.Id=tpr.Inventory__c;
                        INV.In_transit_Quantity__c=0;
                        INV.Total_Inventory__c=INV.Total_Inventory__c-tpr.Received_Quantity__c;
                        INVList.add(INV);
                    }
                }
            }

            if(!INVList.isEmpty()){
                Update INVList;
            }*/
            
            message = 'SUCCESS';
        }
        catch(exception e){
            System.debug('the error has occured due to ===> ' );
            System.debug('the error has occured at ===> ' );
            message = 'FAIL';
        }
        return message;
        
    }


}