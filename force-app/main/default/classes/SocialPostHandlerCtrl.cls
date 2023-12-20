public class SocialPostHandlerCtrl {
    
    @AuraEnabled
    public static void createContent(String header, String footer, String fileContents, List<String> plateforms, DateTime scheduledate, Boolean isPostNow){
        try{
            Content__c contObj = new Content__c();
            if(String.isNotBlank(header)){
            	contObj.Header__c = header;    
            }if(String.isNotBlank(footer)){
            	contObj.Footer__c = footer;    
            }if(scheduledate !=null){
                contObj.Schedule_Date_Time__c = scheduledate;
            }
            if(plateforms !=null && !plateforms.isEmpty()){
                
                System.debug('String.join(selectedValues'+ String.join(plateforms, ';'));
                String options = String.join(plateforms, ';');
                System.debug('Option @@'+ options);
                contObj.Plateform__c = options;
            }
            
            INSERT contObj;
            
            Attachment attachment = new Attachment();
            attachment.Name = 'MyPost.jpeg'; 
            attachment.Body = EncodingUtil.base64Decode(fileContents);
            attachment.ParentId = contObj.Id; 
            attachment.ContentType = 'image/jpeg';
            INSERT attachment;
            
            if(isPostNow){
            	postContent(contObj.Id); // calling Instagram API
            }
        }catch(Exception ex){
        	System.debug('Exception ::'+ ex.getMessage() +'Line Number ::'+ex.getLineNumber());
            throw new AuraHandledException(ex.getMessage());
        }
    }
    @AuraEnabled(cacheable=true)
    public static Map<String, String> getPickListValue(String Object_Api_Name, String field_Api_Name){
        Map<String, String> optionMap = new Map<String, String>();
        if(String.isNotBlank(Object_Api_Name) && String.isNotBlank(field_Api_Name)){
            try{
                Map<String,Schema.SObjectType> globaldesObj = Schema.getGlobalDescribe(); 
                Map<String, Schema.SObjectField> field_map = globaldesObj.get(Object_Api_Name.toLowerCase()).getDescribe().fields.getMap(); 
                List<Schema.PicklistEntry> picklistValues = field_map.get(field_Api_Name).getDescribe().getPickListValues();
                
                for(Schema.PicklistEntry pvObj : picklistValues) {
                    optionMap.put(pvObj.getValue(),pvObj.getLabel());
                }
                return optionMap;
            }catch(Exception ex){
                System.debug('Exception ::'+ ex.getMessage() +'Line Number ::'+ex.getLineNumber());    
            }
        }
        return optionMap;
    }
    @future(callout=true)
    public static void postContent(String contentId){
        Map<Id, Content__c> mapOfContent = new Map<Id, Content__c>([SELECT Id, Header__c, Footer__c, Plateform__c,Schedule_Date_Time__c  FROM Content__c WHERE Id=:contentId]);
        InstagramPostIntegration.postContentOnInstagram(mapOfContent);
    }
    
}