public class Attachement_Trigger_Helper {
    
    public static void HandleAttachements(List<Attachment> AttList){
        system.debug('AttList'+AttList);
        Boolean isProposal = false;
        
        List<id> parentIds = new List<Id>();
        for(Attachment att:AttList){
            parentIds.add(att.parentId);
        }
        List<Documents_Attachment__c> DocAttList = new List<Documents_Attachment__c>();
        List<Document_Category__c> propList=  [Select id from Document_Category__c where id in:parentIds];
        if(propList.size() > 0){
            isProposal = true;
        }
        for(Attachment att:AttList){
            Documents_Attachment__c da = new Documents_Attachment__c();
            da.Attachement_Id__c  = att.Id;
            da.name = att.Name;
            if(isProposal == true){
                da.Document_Category__c =  att.ParentId;
                DocAttList.add(da);
            }
        }
        system.debug(DocAttList);
        if(DocAttList.size() > 0){
            insert DocAttList;    
        }
        
    }
}