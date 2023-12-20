// Apex controller
public without sharing class OpportunityController {
    
    @AuraEnabled
    Public static string UpadteOpportunity(string recordId,string requirementDetail,string filename,string attachmentBody){
        
        list<Opportunity> OppList=new List<Opportunity>();
        system.debug('recordId--'+recordId);
        system.debug('requirementDetail--'+requirementDetail);
        Opportunity OppRec=new Opportunity();
        OppRec.Id=recordId;
        OppRec.Higher_Level_Requirement__c=string.valueOf(requirementDetail);
        OppRec.StageName='Under Design Team';
        OppList.add(OppRec);
        if(!OppList.isEmpty()){
             Update OppList;
        }
        InserTAttachment(recordId,filename,attachmentBody);
        
        return 'success';
    }
    @AuraEnabled
    //Inserting Document In Client Mock Document
    Public static void InserTAttachment(string parentId,string filename,String attachmentBody){
        system.debug('parentId--'+parentId);
        system.debug('filename--'+filename);
        system.debug('attachmentBody--'+attachmentBody);
        Folder__c FolderRec=[Select Id,Name From Folder__c where Opportunity__C =:parentId and Name = 'Client Mock Document'];
        system.debug('FolderRec--'+FolderRec.Id);
        ContentVersion conVer = new ContentVersion();
        conVer.ContentLocation = 'S'; 
        conVer.PathOnClient = 'attachmentName'; 
        conVer.Title = filename; 
        conVer.VersionData = EncodingUtil.base64Decode(attachmentBody); 
        conVer.isMajorVersion = false;
        insert conVer;   
        
        ContentDistribution cdl = new ContentDistribution();
        cdl.ContentVersionId = conVer.Id;
        cdl.Name = filename;
        cdl.RelatedRecordId = FolderRec.id;
        insert cdl;
        system.debug('ContentDistribution----'+cdl);
        Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id].ContentDocumentId;
        ContentDocumentLink conDocLink = New ContentDocumentLink();
        conDocLink.LinkedEntityId = FolderRec.id;//'a5eN0000000FC7cIAG';//FolderRec.Id; 
        conDocLink.ContentDocumentId = conDoc; 
        conDocLink.shareType = 'V';
        insert conDocLink;
        
        Folder__c f = new Folder__c(Id=FolderRec.Id,Status__c='Uploaded');
        update f;
    }
    
}