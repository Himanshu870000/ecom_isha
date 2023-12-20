public with sharing class InwardSKUs_Controller {
    
    @AuraEnabled(cacheable=true)
    public static List<Transfered_SKU__c> getTransferredSKUs(String WarehousetansferedlogID){
        System.debug('WarehousetansferedlogID----->'+WarehousetansferedlogID);
        List<Transfered_SKU__c> TransferredSKUs = [SELECT Id,Name,Product_Warehouse__r.Product__c,Product_Warehouse__r.Product__r.Name, Quantity__c,UOM__c,Warehouse_Transfer_Log__c, Warehouse_Transfer_Log__r.Name , Pending_Quantity__c,Recieved_Quantity__c,
                                                   Warehouse_Transfer_Log__r.Destination_Source__c, Warehouse_Transfer_Log__r.Destination_Source__r.Name, Warehouse_Transfer_Log__r.Source_Warehouse__c,Warehouse_Transfer_Log__r.Source_Warehouse__r.Name,Remarks__c
                                                   FROM Transfered_SKU__c WHERE Warehouse_Transfer_Log__c =:WarehousetansferedlogID AND Pending_Quantity__c > 0];
        System.debug('TransferredSKUs ===> ' + TransferredSKUs);
        return TransferredSKUs;
    }

    @AuraEnabled
    public static string SaveTransferLogDetails(string wtLogId, List<Transfered_SKU__c> TransferredSKUs){
        string message = '';
        system.debug('wtLogId -- ' + wtLogId);
        System.debug('TransferredSKUs ====> ' + TransferredSKUs);
        
        try{            
            Map<Id, Transfered_SKU__c> mapOfQtyByTsku = new Map<Id, Transfered_SKU__c>();
            Map<Id, Decimal> mapOfQtyByProductWH = new Map<Id, Decimal>();
            
            for(Transfered_SKU__c tSku : TransferredSKUs){
                if(tSku.Recieved_Quantity__c != null && tSku.Recieved_Quantity__c != 0){
                    mapOfQtyByProductWH.put(tSku.Product_Warehouse__c, tSku.Recieved_Quantity__c);
                    mapOfQtyByTsku.put(tSku.Id, tSku);
                }
            }
            
            System.debug('mapOfQtyByProductWH ====> ' + mapOfQtyByProductWH);
            System.debug('mapOfQtyByTsku ====> ' + mapOfQtyByTsku);
            
            List<Product_Warehouse__c> prodWarehouse = [SELECT Id, In_Transit_Inventory__c FROM Product_Warehouse__c WHERE Id IN: mapOfQtyByProductWH.keySet()];
            for(Product_Warehouse__c pWh : prodWarehouse){
                Decimal qty = mapOfQtyByProductWH.get(pWh.Id);
                if(mapOfQtyByProductWH.containsKey(pWh.Id)){
                    pWh.In_Transit_Inventory__c = pWh.In_Transit_Inventory__c > 0 ? pWh.In_Transit_Inventory__c - qty: 0;
                }
            }
            update prodWarehouse;
                        
            List<Transfered_SKU__c> tSkuLstToBeUpdated = [SELECT Id, Recieved_Quantity__c, Pending_Quantity__c, Remarks__c 
                                                          FROM Transfered_SKU__c WHERE Id IN: mapOfQtyByTsku.keySet()];
            
            for(Transfered_SKU__c tSku : tSkuLstToBeUpdated){
                if(mapOfQtyByTsku.containsKey(tSku.Id)){
                    tSku.Remarks__c = mapOfQtyByTsku.get(tSku.Id).Remarks__c;
                    tSku.Recieved_Quantity__c = tSku.Recieved_Quantity__c > 0 ? mapOfQtyByTsku.get(tSku.Id).Recieved_Quantity__c + tSku.Recieved_Quantity__c : mapOfQtyByTsku.get(tSku.Id).Recieved_Quantity__c;
                }
            }
            update tSkuLstToBeUpdated;                      
            message = 'SUCCESS';
        }
        catch(exception e){
            System.debug('the error has occured due to ===> ' + e.getMessage());
            System.debug('the error has occured at ===> ' + e.getLineNumber());
            message = 'FAIL';
        }
        return message;
        
    }


}