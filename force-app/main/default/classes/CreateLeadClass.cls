public class CreateLeadClass {
    
    public static void createLead( String fn,String ln,String phone){
        Lead leadRecord = new Lead();
        leadRecord.FirstName =fn;
        leadRecord.LastName =ln;
        leadRecord.Phone =phone;
		leadRecord.Company ='Util labs';        
        insert leadRecord;
    }

}