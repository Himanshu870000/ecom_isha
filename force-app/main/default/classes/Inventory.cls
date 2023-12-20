public class Inventory {

     @AuraEnabled
    public Static  List<Inventory__c>  getproductWarehouseRecords(String recid)
    {
        List<Inventory__c> prodWareRecs = new List<Inventory__c>();
        if(recid != null){
            prodWareRecs = [Select Id, Name, Product__r.Name,Total_Inventory__c,In_transit_Quantity__c from Inventory__c where Clinic__c=:recid and Total_Inventory__c >=1];
        }
        return prodWareRecs;
    }
    
    @AuraEnabled
    public static String insertWarehouseTransferLog(List<Inventory__c> prodList , String warehouseMasterId,string SelectedWareHouseId)
    {
        System.debug('prodList===>'+prodList);
        System.debug('prodList.size()===>'+prodList.size());
        System.debug('warehouseMasterId--->'+warehouseMasterId);
        System.debug('SelectedWareHouseId--->'+SelectedWareHouseId);
        Decimal TotalWQuanity=0;
        for(Inventory__c INV:prodList){
               if(INV.In_transit_Quantity__c>0){
                   TotalWQuanity=TotalWQuanity+INV.In_transit_Quantity__c;
               }
        }
        Inventory_Transfer__c wtlRec = new Inventory_Transfer__c();
        wtlRec.Source_Clinic__c = warehouseMasterId; //Current recordId
        wtlRec.Destination_Clinic__c = SelectedWareHouseId; //Selected Record
        wtlRec.Total_Transferred_Quantity__c = TotalWQuanity;
        
        insert wtlRec;
        if(wtlRec.ID != null)
        {
            System.debug('Hi, WtlRec is created -- ');
            List<Transferd_product__c> TrafSKUList = new List<Transferd_product__c>();
            for(Inventory__c prodwh : prodList){
                Transferd_product__c tranfRec = new Transferd_product__c();
                tranfRec.Inventory_Transfer__c = wtlRec.Id;
                tranfRec.Quantity__c = prodwh.In_transit_Quantity__c; // Intransit__c intransit (replacing quantity to transfer)
                tranfRec.Inventory__c = prodwh.Id;
                TrafSKUList.add(tranfRec);
            }
            insert TrafSKUList;
            update prodList;
        }
        return 'success';
    }

}