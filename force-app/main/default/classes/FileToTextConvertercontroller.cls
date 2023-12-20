public class FileToTextConvertercontroller {
 @auraenabled
    public static QuoteLineItem covertImageText(id recordId, String img){
        String richTextFieldValue = '<img src="data:image/png;base64,' + img + '"/>';
 
         QuoteLineItem imgTotxt =  [SELECT Id, ProdImage__c FROM QuoteLineItem Where id =:recordId];
        imgTotxt.ProdImage__c = richTextFieldValue;
        update imgTotxt;
            return imgTotxt;
        
      
    }
   
}