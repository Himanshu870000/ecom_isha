public class VendoreAndProductList_Ctrl {
    @AuraEnabled
    public static  List<Contact> getallVendorlist(){
        try{
            List<Contact> conlist = [Select id,Name from Contact where Type__c ='Vendor'];
            system.debug('conlist===='+conlist);
            return conlist;
        }catch(Exception e){
            system.debug('line Error ====>'+e.getLineNumber());
        }
        return null;
    }
    @AuraEnabled
    public static  List<Product2> Productlist(){
        try{
            List<Product2> prolist = [Select id,Name,RAM__c,ROM__c,Description,Processor__c,Category__c	 from Product2 where Category__c='Hardware'];
            return prolist;
        }catch(Exception e){
            system.debug('line Error ====>'+e.getLineNumber());
        }
        return null;
    }
    @AuraEnabled
    public static  Contact getallVendorDeatailsRecords(string vendorid){
        try{
            Contact conRec = [Select id,Name,MailingAddress,MailingCity,MailingCountry,MailingStreet from Contact where id =:vendorid];
            system.debug('conRec===='+conRec);
            
            return conRec;
        }catch(Exception e){
            system.debug('line Error ====>'+e.getLineNumber());
        }
        return null;
    }
    @AuraEnabled
    public static  void createPurchaseorderlineItem(List<string> proIdlist,Integer quntity){
        list<Purchase_Order_Line_Item__c> poliCreate = new list<Purchase_Order_Line_Item__c>();
        if(!proIdlist.isEmpty()){
            for(id proid :proIdlist){
                Purchase_Order_Line_Item__c POLIRec = new  Purchase_Order_Line_Item__c();
                POLIRec.Product__c = proid;	
                POLIRec.Quantity__c = quntity;
                poliCreate.add(POLIRec);
            }
            insert poliCreate;
        }
        
        
    }
}