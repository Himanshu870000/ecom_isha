global class GenerateIdentificationReportBatchLight implements Database.Batchable<sObject>, 
Database.Stateful, Database.AllowsCallouts{
    
    global string dealvalue;
    global GenerateIdentificationReportBatchLight(string dealId){
        system.debug('dealId'+dealId);
        dealvalue = dealId;
    }
   
    global Database.QueryLocator start(Database.BatchableContext BC){
        system.debug('gi'+dealvalue);
        String query = 'select Id,Name ,Conga_Link__c from Deal__c where Id=:dealvalue';
        system.debug('query'+query);
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC,List<Deal__c> scope){
        String AttId = CongaHelperToolLightning.generateReport(scope[0].Conga_Link__c, 'Sales Deed', null, null, null);
        system.debug('AttId'+AttId);
        String docCatId = [Select id from Document_Category__c where deal__c = :scope[0].Id AND Name = 'Sale Deed'][0].Id;
        
        List<Documents_Attachment__c> daToDel = [select id from Documents_Attachment__c where name = 'Sales Deed' and Document_Category__c =:docCatId];
        if (daToDel.Size() > 0){
            //delete daToDel;
        }
        
        Documents_Attachment__c da = new Documents_Attachment__c();
        da.Attachement_Id__c  = AttId;
        da.name = 'Sales Deed';
        da.Document_Category__c =  docCatId;  
        insert da;
        
        //CongaHelper.generateReport(scope[0].Id,'Sales Deed');
    }
    
    global void finish(Database.BatchableContext BC){
        system.debug('');
    }
}