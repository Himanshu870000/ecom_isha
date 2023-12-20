public class SalesCloudQueryHandler {

    // Get All Contacts
    public static List<sObject> getAllChildDetails(String accId, String returnRecords){
        try{

            if(accId != null){
                if(returnRecords.containsIgnoreCase('CONTACTS') ){
                    return [Select Id,name,(Select id,Name,FirstName,LastName from Contacts) from Account where Id=:accId].Contacts;
                }else if(returnRecords == 'OPPORTUNITIES'){
                    return [Select Id,name,(Select id,Name,StageName,CloseDate from OPPORTUNITIES) from Account where Id=:accId].OPPORTUNITIES;
                }else{
                    return null;
                }
            }else{
                return null;
            }            
        }catch(Exception e){
            System.debug(' Exception'+e.getMessage() + ' AT '+e.getLineNumber() + ' STACKTRACE STRING' + e.getStackTraceString());
            return null;
        }
    }
}