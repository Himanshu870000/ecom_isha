public class JSONEditorForAddComments {
    public static String strJson='';
    public static string jsonGenerator(string commentBody){
        JSONGenerator jsGen = JSON.createGenerator(true);
		jsGen.writeStartObject();
        jsGen.writeStringField('body', commentBody);
        jsGen.writeEndObject();
        strJson=jsGen.getAsString();
        return strJson;
    }
}