public without sharing class CaseWrapper {
    
    public String orgid;	
    public cls_case caseCls;
    
    public class cls_case {
        public string subject;
        public string status;
        public string priority;
        public string type; 
        public string description;
    }    
    
    public static CaseWrapper parse(String json){
        return (CaseWrapper) System.JSON.deserialize(json, CaseWrapper.class);
    }
    
}