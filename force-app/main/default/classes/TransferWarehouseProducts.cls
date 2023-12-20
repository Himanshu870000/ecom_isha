public without sharing class TransferWarehouseProducts{
    

    /*@AuraEnabled(cacheable=true)
    public static List<sObject> getWarehouseMasterRecords(string searchKey,string recordId){
        List <sObject> returnList = new List <sObject> ();
        List<Clinic__c> ClinicRecodrd=new List<Clinic__c>();
        string sQuery;
        system.Debug('searchKey--'+searchKey);
        try{
            string sWildCardText = '%'+searchKey+'%'  ;
            system.Debug('sWildCardText--'+sWildCardText);
            if(searchKey==null){
                system.debug('First Query');
                ClinicRecodrd=[Select Id,Name,Active__c From Clinic__c Where Id!=:recordId AND Active__c=true];
            }else{
                system.debug(' Second Query');
                ClinicRecodrd=[Select Id,Name,Active__c From Clinic__c Where Name LIKE:sWildCardText AND Id!=:recordId AND Active__c=true];  
            }
            System.debug('returnList---->'+returnList);
            System.debug('ClinicRecodrd---->'+ClinicRecodrd);
            return ClinicRecodrd;
        }
        catch(Exception e){
            System.debug('Exception--->'+e.getMessage());
            System.debug('Exception--->'+e.getLineNumber());
            return ClinicRecodrd;
        }
    } */

    @AuraEnabled(Cacheable=true)
    public Static  List<Product_Warehouse__c>  getproductWarehouseRecords(String recid) {
        List<Product_Warehouse__c> prodWareRecs = new List<Product_Warehouse__c>();
        if(recid != null){
            prodWareRecs = [Select Id, Name, Product_Name__c, Current_Inventory__c, Warehouse__c, Product__c, In_Transit_Inventory__c
                            from Product_Warehouse__c where Warehouse__c=:recid and Current_Inventory__c >=1];
        }
        system.debug('prodWareRecs---'+prodWareRecs);
        return prodWareRecs;
    }

    @AuraEnabled
    public static String insertWarehouseTransferLog(List<tWrapper> prodList , String warehouseMasterId,string SelectedWareHouseId) {
        System.debug('prodList===>'+prodList);
        System.debug('prodList.size()===>'+prodList.size());
        System.debug('warehouseMasterId--->'+warehouseMasterId);
        System.debug('SelectedWareHouseId--->'+SelectedWareHouseId);
        
        //update prodList;
        Warehouse_Transfer_Log__c wtlRec = new Warehouse_Transfer_Log__c();
        wtlRec.Source_Warehouse__c = warehouseMasterId; //Current recordId
        wtlRec.Destination_Source__c = SelectedWareHouseId; //Selected Record
        wtlRec.Transfered_DateTime__c = System.today();
        wtlRec.Status__c = 'In-Transit';
        insert wtlRec;
        
        System.debug('wtlRec--->'+wtlRec.Id);
        
        if(wtlRec.ID != null)
        {
            System.debug('Hi, WtlRec is created -- ');
            List<Transfered_SKU__c> TrafSKUList = new List<Transfered_SKU__c>();
            integer i = 0;
            for(tWrapper prodwh : prodList){
                i++;
                Transfered_SKU__c tranfRec = new Transfered_SKU__c();
                tranfRec.Warehouse_Transfer_Log__c = wtlRec.Id;
                //tranfRec.Quantity__c = prodwh.In_Transit_Inventory__c;
                //tranfRec.Product_Warehouse__c=prodwh.Id;
                tranfRec.Quantity__c = prodwh.Quantity > 0 ? prodwh.Quantity : 5+i;
                tranfRec.Product_Warehouse__c=prodwh.pWHId;
                TrafSKUList.add(tranfRec);
            }
            insert TrafSKUList;
            //update prodList;
        }
        return 'success';
    }
    
    @AuraEnabled(cacheable=true)
    public static List<sObject> getWarehouseMasterRecords(string searchKey,string recordId){
        List <sObject> returnList = new List <sObject> ();
        List<Warehouse_Master__c> WareHouseRecodrd=new List<Warehouse_Master__c>();
        string sQuery;
        system.Debug('searchKey--'+searchKey);
        try{
            string sWildCardText = '%'+searchKey+'%'  ;
            
            system.Debug('sWildCardText--'+sWildCardText);
            if(searchKey==null){
                system.debug('First Query');
                WareHouseRecodrd=[Select Id,Name From Warehouse_Master__c Where Id!=:recordId];
            }else{
                system.debug(' Second Query');
                WareHouseRecodrd=[Select Id,Name From Warehouse_Master__c Where Name LIKE:sWildCardText AND Id!=:recordId];  
            }
            System.debug('returnList---->'+returnList);
            System.debug('WareHouseRecodrd---->'+WareHouseRecodrd);
            return WareHouseRecodrd;
        }
        catch(Exception e){
            System.debug('Exception--->'+e.getMessage());
            System.debug('Exception--->'+e.getLineNumber());
            return WareHouseRecodrd;
        }
    } 
    
    public class tWrapper{
        @AuraEnabled
        public decimal Quantity;
        @AuraEnabled
        public Id pWHId;
    }
}