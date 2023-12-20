public with sharing class VisaLeadAPIWrapper {
    public String Mobile;	
    public String Visa_Type;	
    public String Visa_Purpose;	

    public static VisaLeadAPIWrapper parse(String json){
		return (VisaLeadAPIWrapper) System.JSON.deserialize(json, VisaLeadAPIWrapper.class);
	}
    
}