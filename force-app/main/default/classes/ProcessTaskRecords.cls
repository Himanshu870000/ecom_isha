public  class ProcessTaskRecords {
    
    public List<Task> selTaskLst;
    public String TaskIds;
    
    public ProcessTaskRecords(ApexPages.StandardSetController cntlr){
        selTaskLst = cntlr.getSelected(); //get selected records from account list view
        
        system.debug('selTaskLst :: ' + selTaskLst);
        TaskIds = '';  
        for(Task ld : selTaskLst){
            TaskIds += ld.Id + ','; //build list of ids string concatenated with comma                         
        }
        system.debug('TaskIds :: ' + TaskIds);
        TaskIds = TaskIds.removeEnd(','); 
    }
    
    public PageReference redirectToLC(){
        String returnUrl = '/lightning/cmp/c__ProcesssLeadRecordsToUsrToAssign?c__listofTasks='+TaskIds;
        PageReference pgReturnPage = new PageReference(returnUrl);
        pgReturnPage.setRedirect(true);
        return pgReturnPage;
    }
    
    @AuraEnabled
    public static AssignUserGroupWrapper QueryAssignmentGroup(){
        AssignUserGroupWrapper AGWrap = new AssignUserGroupWrapper();
        try{
            
            Map<Id, User> AssignGroupMap = new Map<Id, User>();
            List<User> AssignGroup =[SELECT Id,Name FROM User];
            
            for(User AG : AssignGroup){
                AssignGroupMap.put(AG.id, AG);
            }
            AGWrap.AssignGroupMapWrap = AssignGroupMap;
            ListView listviews =[SELECT Id, Name FROM ListView WHERE SobjectType = 'Task' and name = 'All Task'];
            System.debug('listviews ::'+listviews);
            AGWrap.AllTasklistview = listviews;
            system.debug('AGWrap :: ' + AGWrap);
            return AGWrap;
        }
        catch(DmlException e) {
            System.debug('The following exception has occurred: ' + e.getMessage() + ' at lin number :: ' + e.getLineNumber());
        }
        return AGWrap;
    }
    
     @AuraEnabled
    public static String TransferTask(List<String> TaskListId, String SelectedAssignUserGroup){
        try{
            if(!TaskListId.isEmpty()){
                List<Task> taskListTobeUpdate = [select id,OwnerId from task where id in: TaskListId];
                for(Task ts : taskListTobeUpdate){
                    ts.ownerId = SelectedAssignUserGroup;
                }
                update taskListTobeUpdate;
            }
        }catch(Exception e){
            system.debug('Exception::'+e.getStackTraceString());
            return e.getStackTraceString();
        }
        return 'SUCCESS';
    }
    
      public class AssignUserGroupWrapper{
        
        @AuraEnabled
        public Map<Id, User> AssignGroupMapWrap {get; set;}
        @AuraEnabled
        public ListView AllTasklistview {get; set;}
        
    }
    
   
}