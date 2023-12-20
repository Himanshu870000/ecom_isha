public without sharing class GenerateDynamicEwayBillController {


    public string recordId = System.currentPageReference().getParameters().get('id'); 
    public Opportunity oppRec {set;get;}

    public GenerateDynamicEwayBillController(){
        oppRec =[SELECT ID,Name FROM Opportunity WHERE ID =:recordId];
    }

    @AuraEnabled
    public static string savePDF(String url,String id,String fileName){
        try {
            string  disReqId = id;
            PageReference ref = new PageReference(url);
            ContentVersion cont = new ContentVersion();
            
            cont.Title = fileName;
            cont.PathOnClient = fileName+'.pdf';
            cont.VersionData = ref.getContentAsPdf();
            cont.Origin = 'H';
            
            insert cont;
           
            ContentDocumentLink cdl = createContentLink(cont.Id, id);
            createFolderRecord(url,id,fileName);
            return 'Success';     
        } 
        catch (Exception e) {
            System.debug('savePDF Exception Message---->'+e.getMessage());
            System.debug('savePDF Exception Line Number---->'+e.getLineNumber());
            return e.getMessage();
            //throw new AuraHandledException(e.getMessage());
        }
    }
    
    private static ContentDocumentLink createContentLink(String contentVersionId, String recordId) {
        if (contentVersionId == null || recordId == null) { return null; }
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = [ SELECT ContentDocumentId FROM ContentVersion WHERE Id =: contentVersionId ].ContentDocumentId;
        cdl.LinkedEntityId = recordId;
        cdl.ShareType = 'V';
        try {
            insert cdl;
            return cdl;
        } 
        catch(DMLException e) {
            System.debug('createContentLink Exception Message---->'+e.getMessage());
            System.debug('createContentLink Exception Line Number---->'+e.getLineNumber());
            return null;
        }
    }

    public static void createFolderRecord(String url,String id,String fileName){
        try {
            System.debug('url--->'+url);
            System.debug('id--->'+id);
            System.debug('fileName--->'+fileName);
            List<Folder__c> folder;
            
            if(id != null){
                folder = [SELECT ID,Name,Opportunity__c FROM Folder__c WHERE Name = 'Eway bill' AND Opportunity__c =:id LIMIT 1];
                Folder__c folderRec = new Folder__c();
                System.debug('folder.size()---->'+folder.size());

                if(folder.size() == 0){  
                    system.debug('folder.Id Size is 0)');
                    folderRec.Name = 'Eway bill';
                    folderRec.Opportunity__c = id;
                    insert folderRec;
                    System.debug('folderRec---->'+folderRec);
                    savePDF2(url, folderRec.Id, fileName);
                }
                else{
                    savePDF2(url, folder[0].Id, fileName);
                }
            }
        } 
        catch (Exception e) {
            System.debug('createFolderRecord Exception Message---->'+e.getMessage());
            System.debug('createFolderRecord Exception Line Number---->'+e.getLineNumber());
            //throw new AuraHandledException(e.getMessage());
        }
    }

    @future(callout = TRUE)
    private static void savePDF2(String url,String id,String fileName){
        try {
            string  disReqId = id;
            PageReference ref = new PageReference(url);
            ContentVersion cont = new ContentVersion();
            
            cont.Title = fileName;
            cont.PathOnClient = fileName+'.pdf';
            cont.VersionData = ref.getContentAsPdf();
            cont.Origin = 'H';
            
            insert cont;
           
            ContentDocumentLink cdl = createContentLink(cont.Id, id);
        } 
        catch (Exception e) {
            System.debug('savePDF Exception Message---->'+e.getMessage());
            System.debug('savePDF Exception Line Number---->'+e.getLineNumber());
            //throw new AuraHandledException(e.getMessage());
        }
    }


}