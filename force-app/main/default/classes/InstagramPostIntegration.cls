public class InstagramPostIntegration {
    
    // Post content on Instagram
    public static void postContentOnInstagram(Map<Id,Content__c> mapOfContent) {
        
        Social_Post_API_Settings__mdt apiSetting = Social_Post_API_Settings__mdt.getInstance('Instagram');
        
        // Instagram API endpoints
        String MEDIA_UPLOAD_URL = apiSetting.Base_Url__c + apiSetting.Page_Id__c + apiSetting.Upload__c;
        String MEDIA_POST_URL = apiSetting.Base_Url__c + apiSetting.Page_Id__c + apiSetting.Post__c;
        
        Map<Id,Attachment> mapOfAttachment = new Map<Id,Attachment>();
        List<String> listBlobReq = new List<String>();
        Map<String,String> requestMap = new Map<String,String>();
        
        for(Attachment attacObj : [SELECT Id, Body,ParentId, ContentType FROM Attachment WHERE Parent.Type ='Content__c' AND ParentId IN: mapOfContent.keySet()]){
        	mapOfAttachment.put(attacObj.ParentId, attacObj);				   
        }
        
        // Prepare the request body
        if(!mapOfAttachment.isEmpty()){
            for(Content__c contObj : mapOfContent.values()){
             	String header = contObj.Header__c;
                String footer = contObj.Footer__c;
				String imageFileType = mapOfAttachment.get(contObj.Id).ContentType.substringAfter('/');
				//String imageUrl = baseUrl + '/' + attachment.ParentId + '/e/' + attachmentId + '.' + imageFileType;
                String image_url = URL.getSalesforceBaseUrl().toExternalForm() + '/'+contObj.Id +'/e/' + mapOfAttachment.get(contObj.Id)?.Id +'.'+imageFileType;
                System.debug('image_url @@@'+ image_url);
                String caption = header + '\n\n' + footer;
                requestMap.put('image_url',image_url);
                requestMap.put('caption', caption);
            }    
        }
        
        HttpRequest request = new HttpRequest();
        request.setEndpoint(MEDIA_UPLOAD_URL);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'pplication/json');
        request.setHeader('Authorization', 'Bearer ' + apiSetting.Access_Token__c);
        request.setBody(JSON.serialize(requestMap));
        
        try{
            HttpResponse response = new Http().send(request);
            System.debug('response @@'+ response);
            if (response.getStatusCode() == 200) {
                System.debug('response getBody()@@@@ '+ response.getBody());
                Map<String,Object> mapOfString = (Map<String,Object>)JSON.deserializeUntyped(response.getBody());
                String mediaId = (String)mapOfString.get('id');
                
                // Post the content with caption
                HttpRequest postRequest = new HttpRequest();
                postRequest.setEndpoint(MEDIA_POST_URL);
                postRequest.setMethod('POST');
                postRequest.setHeader('Content-Type', 'application/json');
                postRequest.setHeader('Authorization', 'Bearer ' + apiSetting.Access_Token__c);
                //postRequest.setBody('creation_id=' + mediaId + '&caption=' + caption);
                
                HttpResponse postResponse = new Http().send(postRequest);
                if (postResponse.getStatusCode() == 200) {
                    System.debug('Content posted on Instagram successfully.');
                } else {
                    System.debug('Failed to post content on Instagram. Error: ' + postResponse.getBody());
                }
            } else {
                System.debug('Failed to upload media file to Instagram. Error: ' + response.getBody());
            } 
        }catch(Exception ex){
            System.debug('Exception :'+ ex.getMessage());
        }
        
    }
    
}