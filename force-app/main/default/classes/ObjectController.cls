public class ObjectController {
    
    public  void createField(String objectapiname,String fieldapiname,String fieldlabel,String fielddescription,String fieldType){
        
        Http http = new Http();
        HttpRequest requestinside = new HttpRequest();
        requestinside.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionID());
        requestinside.setHeader('Content-Type', 'application/json');
        requestinside.setEndpoint(URL.getSalesforceBaseUrl().toExternalForm()+'/services/data/v41.0/tooling/sobjects/CustomField/');
        requestinside.setMethod('POST');
        String fieldDef = '{"Metadata" : ';
        String metadef = '"type" : "'+fieldType+'","description" : "'+fielddescription+'", "inlineHelpText" : "","precision" : null,"label" : "'+fieldlabel+'","precision" : 18,"scale":1,"required" : false';
        fieldDef += '{'+metadef+'},';
        fieldDef += '"FullName" : "'+objectapiname+'.'+fieldapiname+'__c"}';
        system.debug(fieldDef);
        requestinside.setBody(fieldDef);
        HTTPResponse res = http.send(requestinside);
        System.debug(res.getBody());
        
    }
    
}