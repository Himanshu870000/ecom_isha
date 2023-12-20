public without Sharing class fetchLeadFieldLabelName{
    
    public static string FetchLabelName(string fieldApiname){

        String mylabel;
        String type = 'lead';  // Say,this is my object
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType leadSchema = schemaMap.get(type) ;
        Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();
        for (String fieldName : fieldMap.keySet()){
            if (fieldName == fieldApiname){
                
                //It provides to get the object fields label.
                mylabel = fieldMap.get(fieldName).getDescribe().getLabel();
                system.debug('myLabel :: ' + mylabel);
            }
        }
        return mylabel;
    }
}