public class QuoteTriggerHelper {
    public static void insertQuoteLineItem(List<Quote> quoteList){
        set<id> opportunityIds = new Set<id>();
        Map<Id,Id> quoteidByOpportunityid = new Map<Id,Id>();
        
        List<Opportunity> opportunityList = new List<Opportunity>();
        List<QuoteLineItem> newQuoteLineItemList = new List<QuoteLineItem>();
        
        for(Quote quoteRec : quoteList){
            if(quoteRec.OpportunityId != null){
                quoteidByOpportunityid.put(quoteRec.OpportunityId,quoteRec.id);
            }
        }
        system.debug('quoteidByOpportunityid-->'+quoteidByOpportunityid);
        if(!quoteidByOpportunityid.isEmpty()){
            opportunityList = [Select Id,(Select Id,Product2Id,UnitPrice,Quantity From OpportunityLineItems) From Opportunity where id in :quoteidByOpportunityid.keyset() ];
            if(!opportunityList.isEmpty()){
                for(Opportunity oppRec : opportunityList){
                    QuoteLineItem newQuoteLineItem = new QuoteLineItem();
                    newQuoteLineItem.QuoteId = quoteidByOpportunityid.get(oppRec.id);
                    newQuoteLineItem.PricebookEntryId =  [select id from pricebookEntry where product2Id =: oppRec.OpportunityLineItems[0].Product2Id].id;
                    newQuoteLineItem.Quantity = oppRec.OpportunityLineItems[0].Quantity;
                    newQuoteLineItem.UnitPrice = oppRec.OpportunityLineItems[0].UnitPrice; 
                    newQuoteLineItemList.add(newQuoteLineItem);
                }
                if(!newQuoteLineItemList.isEmpty()){
                    insert newQuoteLineItemList;
                }
            }
            
            callFutureMethod(quoteidByOpportunityid.values());
        }
    }
    @future(callout=true)
    
    public static void callFutureMethod (List<Id> quoteIds) {
        
        //Initialize the quote url
        String quoteUrl = '/quote/quoteTemplateDataViewer.apexp?';
        
        //Get the Quote Template Id from Custom Settings
        String quoteTemplateId = '0EHN0000001uVa5';
        
        //List variable to get all the Quote Documents
        List<QuoteDocument> lstQuoteDoc = new List<QuoteDocument>();
        
        if(!quoteIds.isEmpty() && quoteIds.size() > 0) {
            
            for(Id quoteId :quoteIds) {
                //Construct the quote URL to generate PDF
                quoteUrl += 'id=' + quoteId;
                quoteUrl += '&headerHeight=197&footerHeight=10';
                quoteUrl += '&summlid=' + quoteTemplateId;
                
                //call the quote url
                PageReference pageRef = new PageReference(quoteUrl);
                
                //get the quotePdf
                Blob quoteBlob;
                
                if(Test.isRunningTest()) {
                    quoteBlob = Blob.valueOf('Generate Pdf');
                } else {
                    quoteBlob = pageRef.getContentAsPDF();
                }
                
                //initialze the QuoteDocument to hold the quote pdf for insertion
                QuoteDocument quoteDoc = new QuoteDocument();
                quoteDoc.Document = quoteBlob;
                quoteDoc.QuoteId = quoteId;
                lstQuoteDoc.add(quoteDoc);
            }
        }
        
        if(!lstQuoteDoc.isEmpty() && lstQuoteDoc.size() > 0) {
            Database.insert(lstQuoteDoc);
        }
        
    }
}