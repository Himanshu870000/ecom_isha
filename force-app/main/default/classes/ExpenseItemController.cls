public with sharing class ExpenseItemController {
    @AuraEnabled(cacheable=true)
    public static String getRecordName(Id recordId){
        return [Select Name from ExpenseT__Expense__c where Id=:RecordId].Name;
    }
    @AuraEnabled
    public static String uploadFile(String base64, String filename, String expenseItemRecordId) {
          ContentVersion cv = createContentVersion(base64, filename);
          ContentDocumentLink cdl = createContentLink(cv.Id, expenseItemRecordId);
          if (cv == null || cdl == null) { return null; }
          return cdl.Id;
    }
    private static ContentVersion createContentVersion(String base64, String filename) {
        ContentVersion cv = new ContentVersion();
        cv.VersionData = EncodingUtil.base64Decode(base64);
        cv.Title = filename;
        cv.PathOnClient = filename;
        try {
          insert cv;
          return cv;
        } catch(Exception e) {
          System.debug('Exception Message::'+e.getMessage()+'Line Number::'+e.getLineNumber());
          return null;
        }
      }
      private static ContentDocumentLink createContentLink(String contentVersionId, String recordId) {
        if (contentVersionId == null || recordId == null) { return null; }
                ContentDocumentLink cdl = new ContentDocumentLink();
                cdl.ContentDocumentId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =: contentVersionId].ContentDocumentId;
                cdl.LinkedEntityId = recordId;
                cdl.ShareType = 'V';
                try {
                    insert cdl;
                    return cdl;
                } catch(Exception e) {
                    System.debug('Exception Message::'+e.getMessage()+'Line Number::'+e.getLineNumber());
                    return null;
                }
    }

}