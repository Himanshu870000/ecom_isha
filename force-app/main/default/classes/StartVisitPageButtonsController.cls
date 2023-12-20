public class StartVisitPageButtonsController {
@AuraEnabled
    public static void saveTask(Task taskRec){
        try{
                if(taskRec !=null){
                    System.debug('taskRec === >'+taskRec);
                    taskRec.OwnerId = userInfo.getUserId();
                    insert taskRec;
                }
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
        }
    }
    
            @AuraEnabled
    public static void saveLogCall(Task taskRec){
        try{
                if(taskRec !=null){
                    System.debug('taskRec === >'+taskRec);
                    taskRec.OwnerId = userInfo.getUserId();
                    insert taskRec;
                }
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
        }
    }
    
                @AuraEnabled
    public static void saveOpportunity(Opportunity oppRec){
        try{
                if(oppRec !=null){
                    System.debug('oppRec === >'+oppRec);
                    insert oppRec;
                }
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
        }
    }
    
                    @AuraEnabled
    public static void saveCase(Case caseRec){
        try{
                if(caseRec !=null){
                    System.debug('caseRec === >'+caseRec);
                    insert caseRec;
                }
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
        }
    }
}