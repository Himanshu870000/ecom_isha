public with sharing class SharePointCallout {
    @future(callout=true)
    public static void createFolder(Set<Id> prodList){
        String document_cat = [select Category_Name__c from Product_Document_Categories__c].Category_Name__c;
        List<String> document_cat_list = document_cat.split(',');

        Map<Id,Product2> pMap = new Map<Id,Product2>([Select Id,Name From Product2 Where Id In : prodList]);
        for(Product2 pro : pMap.values()){
            pro.Name = pro.Name.replace(' ','');
            String response = SharePointHandler.createFolderInsideSite('Documents/'+pro.Name);
            if(response=='Success'){
                for(String pd: document_cat_list){
                    SharePointHandler.createFolderInsideSite('Documents/'+pro.Name+'/'+pd);
                }
            }
        }
    }
}