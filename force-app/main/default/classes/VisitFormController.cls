public class VisitFormController {
    
    @RemoteAction
    public static Lead searchLead(string searchkey){
        try{
            system.debug('searchkey--->'+searchkey);
            if(searchkey != null){
                string phonestring = '%' +searchkey;
                List<Lead> leadList = [select Id,FirstName,LastName,Email,Phone From Lead where Email =:searchkey OR Phone LIKE :phonestring order by lastModifiedDate Desc limit 1];
                if(!leadList.isEmpty()){
                    return leadList[0];
                }else{
                    return null;
                }
            }
           return null;
        }catch(Exception e){
            return null;
        }
    }

}