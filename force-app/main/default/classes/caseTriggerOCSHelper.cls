public class caseTriggerOCSHelper {
    
    public static void assignCaseToActiveUser(List<Case> caseList){
        
        List<Id> ownerIds = new List<Id>();
        List<Case> newCaseList = new List<Case>();
        List<String> activeValue = new List<String>();
        
        activeValue.add('Available_Chat');
        activeValue.add('Available_Case');
        activeValue.add('Available_Phone');
        //activeValue.add('Available_Social_Cases');
        //activeValue.add('Available_Chat');
        //activeValue.add('Available_Chat');
        
        for(Case caseRec : caseList){
            
            ownerIds.add(caseRec.OwnerId);
        }
        
        List<UserServicePresence> omniUserList = [SELECT Id, Name, ServicePresenceStatus.DeveloperName, UserId, User.Name ,CreatedDate 
                                                  FROM UserServicePresence WHERE UserId IN: ownerIds];
        
        List<UserServicePresence> activeOmniUserList = [SELECT Id, Name, ServicePresenceStatus.DeveloperName, UserId, User.Name ,CreatedDate 
                                                        FROM UserServicePresence WHERE ServicePresenceStatus.DeveloperName IN: activeValue];
        
        for(UserServicePresence usp : omniUserList){
            
            if(activeValue.contains(usp.ServicePresenceStatus.DeveloperName)){
                
            }
            else{
                for(Case caseRec : caseList){
                    
                    caseRec.OwnerId = activeOmniUserList[0].UserId;
                    
                    newCaseList.add(caseRec);
                }
            }
        }
        
        update newCaseList;
    }
    
}