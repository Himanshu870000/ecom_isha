@RestResource(urlMapping='/uploadFile/*')
global class UploadFileRestController {

    @HttpPost
    global static String uploadFile() {
        RestRequest req = RestContext.request;
        Blob fileBody = req.requestBody;
        String fileName = req.params.get('fileName');
        String linkedEntityId = req.headers.get('linkedEntityId');
        String fileExt = req.headers.get('FileExtension');
        String contentType = req.headers.get('Content-Type');

        // Insert the file as a ContentVersion record
        ContentVersion cv = new ContentVersion(
            Title = fileName,
            PathOnClient = fileName+'.'+fileExt,
            VersionData = fileBody
        );
        insert cv;
        String conDocId = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =: cv.Id].ContentDocumentId;
        system.debug('conDocId -- ' + conDocId);
        system.debug('linkedEntityId -- ' + linkedEntityId);
        
        ContentDocumentLink cdl = new ContentDocumentLink(
            ContentDocumentId = conDocId,
            LinkedEntityId = linkedEntityId,
            Visibility = 'AllUsers'
        );
        
        insert cdl;
                
        return 'File uploaded successfully';
    }
}