public class POTriggerHandler {
	private static POTriggerHandler helperInstance;
    public static POTriggerHandler getInstance(){
        if(helperInstance==null)
            helperInstance = new POTriggerHandler();
        return helperInstance;
    }
    
    public void afterInsert(Map<Id,Purchase_Order__c> poMap){
        List<String> poFolders = System.Label.PO_Folder_Name.split(',');

        List<Task> tskList = new List<Task>();
        List<Sale_Order__c> soList = new List<Sale_Order__c>();
        List<Folder__c> folders = new List<Folder__c>();

        for(Purchase_Order__c po : poMap.values()){
            
            Sale_Order__c so = new Sale_Order__c();
            so.Opportunity__c = po.Opportunity__c;
            so.Purchase_Order__c = po.Id;
            so.Account__c = po.Vendor__c;
            so.Order_Status__c = 'Open';
            so.Payment_Method__c = 'Online';
            so.Payment_Amount__c = po.Payment_Amount__c;
            soList.add(so);

            Task tsk = new Task();
            tsk.Subject = 'Sales Ops Team has been assigned a new Task';
            tsk.ActivityDate = po.PO_Date__c;
            tsk.OwnerId = '005N000000AyhmwIAB';
            tsk.WhatId = po.Id;
            tskList.add(tsk);
            
            if(poFolders!=null){
                for(String fName : poFolders){
                    Folder__c folder = new Folder__c(Name=fName,Purchase_Order__c = po.Id);
                    folders.add(folder);
                }
            }
        }
        
        if(!soList.isEmpty()){
            insert soList;
        }
        
        if(!tskList.isEmpty()){
         	insert tskList;   
        }
        
        if(!folders.isEmpty()){
         	insert folders;   
        }
    }


}