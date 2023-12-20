public class AttachPitchDeck {
    public static void updateContentDoc(Map<Id,Opportunity> newOpportunityMap){
        try{
            Map<string, string> opportunityIdByBidAssetidMap = new Map<String, String>();
            Map<string, string> BidAssestIdByContentDocumentLinkMap = new Map<String, String>();
            Map<string, string> opportunityIdByFolderIdMap = new Map<String, String>();
            List<ContentDocumentLink> contentDocuLinkList = new List<ContentDocumentLink>();
            List<ContentDocumentLink> contentDocuLinkListToInsertUnderOpp = new List<ContentDocumentLink>();
            List<Folder__C> foldersList = new List<Folder__C>();
            
            if(!newOpportunityMap.isEmpty()){
                for(Opportunity oppRec :  newOpportunityMap.values()){
                    if(oppRec.Bid_Branding_Asset__c != null){
                        opportunityIdByBidAssetidMap.put(oppRec.Id, oppRec.Bid_Branding_Asset__c);
                    }
                }
                if(!opportunityIdByBidAssetidMap.isEmpty()){
                    contentDocuLinkList = [SELECT ContentDocumentId,LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId in: opportunityIdByBidAssetidMap.values()];
                    foldersList = [Select Id,Opportunity__c From Folder__c where Opportunity__c in : opportunityIdByBidAssetidMap.keyset() and Name = 'Pitch Deck'];
                    if(!foldersList.isEMpty()){
                        for(Folder__c folderRec : foldersList){
                            opportunityIdByFolderIdMap.put(folderRec.Opportunity__c, folderRec.Id);
                        }
                    }
                    if(!contentDocuLinkList.isEmpty()){
                        for(ContentDocumentLink CDRec : contentDocuLinkList){
                            BidAssestIdByContentDocumentLinkMap.put(CDRec.LinkedEntityId, CDRec.ContentDocumentId);
                        }
                    }
                }
                for(String opportunityId : opportunityIdByBidAssetidMap.keySet()){
                    ContentDocumentLink cdl = new ContentDocumentLink();
                    cdl.ContentDocumentId = BidAssestIdByContentDocumentLinkMap.get(opportunityIdByBidAssetidMap.get(opportunityId));  // [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId ='a62N0000000Cx6pIAC'].ContentDocumentId;
                    cdl.LinkedEntityId = opportunityIdByFolderIdMap.get(opportunityId);
                    cdl.Visibility = 'AllUsers';
                    contentDocuLinkListToInsertUnderOpp.add(cdl);
                }
                if(!contentDocuLinkListToInsertUnderOpp.isEmpty()){
                    insert contentDocuLinkListToInsertUnderOpp;
                }
                
                //insert cdl;
            }
        }
        catch(exception ex){
            
        }
    }
}