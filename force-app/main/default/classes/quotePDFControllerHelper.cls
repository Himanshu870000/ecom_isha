public class quotePDFControllerHelper {

    @AuraEnabled
    public static String checkPaymentTermDetails(String quoteId){
        //List<Payment_Term_Details__c> terms=[Select Id,Quote__r.Terms_Condition_Type__c From Payment_Term_Details__c WHERE Quote__c=:quoteId AND Payment_Term_Applicable__c=true];
        //if(terms.size()>0){
            //return terms;
        //}
        return 'Success';
    }
    @AuraEnabled
    public static QuoteDocument savePDF(string QuoteId)
    {
        try{
            List<Quote> quote=[select GrandTotal,Discount from Quote where Id=:QuoteId];
            if(quote.size()>0)
            {
                System.debug('QuoteId::'+QuoteId);
                QuoteDocument document=new QuoteDocument();
                document.QuoteId=QuoteId;
                PageReference pdf = Page.QuotePDF;
                pdf.getParameters().put('id',QuoteId);
                document.Document=pdf.getContent();
                insert document;
                System.debug(document);
                return document;    
            }
            return null;
            
        }catch(Exception ex)
        {
            System.debug(ex.getLineNumber());
            System.debug(ex.getLineNumber());
            return null;
        }
    }
}