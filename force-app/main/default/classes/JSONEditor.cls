public class JSONEditor {
    public static String strJson = '';
    public static string jsonGenerator(Id caseID){
        Case caseDetail=[SELECT Id,Subject,Description from Case WHERE Id=:caseID];
        JSONGenerator jsGen = JSON.createGenerator(true);
        jsGen.writeStartObject();
        jsGen.writeFieldName('fields');
        jsGen.writeStartObject();
        
        jsGen.writeFieldName('issuetype');
        jsGen.writeStartObject();
        jsGen.writeStringField('id', '10056');
        jsGen.writeEndObject();
        jsGen.writeFieldName('project');
        jsGen.writeStartObject();
        jsGen.writeStringField('key', 'SJC');
        jsGen.writeEndObject();
        jsGen.writeStringField('summary', caseDetail.Subject);
        jsGen.writeStringField('description', caseDetail.Description);
        jsGen.writeEndObject();
        jsGen.writeEndObject();
        strJson = jsGen.getAsString();
        system.debug('jsGen::'+strJson);
        return strJson;
        
    }
}