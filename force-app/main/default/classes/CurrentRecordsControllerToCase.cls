public with sharing class CurrentRecordsControllerToCase {
		
    @AuraEnabled
    public static Boolean add_jira_issue(Id caseID){
        return  JIRA_API_CALLOUTS.add_jira_issue(caseID);
    }
    
    @AuraEnabled
    public static Boolean addJiraComment(string description,string Issue_key){
        System.debug(Issue_key);
        return JIRA_API_CALLOUTS.add_jira_comment(description,Issue_key);
    }
    
    @AuraEnabled
    public static List<Case> getCaseDetails(Id caseID){
        try {
            return [SELECT Id,Subject,Description from Case WHERE Id=:caseID];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled 
    public static List<jiraIssueStatusWrapper> getJIRAStatus(Id caseID){
        //JIRA_API_CALLOUTS.get_jira_issues();
        System.debug(JIRA_API_CALLOUTS.get_jira_issue_by_case(caseID)[0]);
        return JIRA_API_CALLOUTS.get_jira_issue_by_case(caseID);
    }
    
    @AuraEnabled
    public static JIRA_API_CALLOUTS.commentsWrapper getJiraCommnets(Id caseID,string Issue_key){
       // System.debug(JIRA_API_CALLOUTS.get_jira_commnets(caseID));
       // return JIRA_API_CALLOUTS.get_jira_commnets(caseID);
        return JIRA_API_CALLOUTS.get_jira_commnets(caseID,Issue_key);
    }
    class IssueStatus{
        @AuraEnabled
        public string Issue_key {get;set;}
        @AuraEnabled
        public Boolean exist {get;set;}
    }
    @AuraEnabled
    public static IssueStatus check_exist_jira_issue(Id caseID){
       	List<Jira_issue__c> issue=[SELECT Id,Case__c,Jira_Issue_Key__c from Jira_issue__c where Case__c=:caseID];
       
       // return (issue.size()>0)?FALSE:TRUE;
        IssueStatus issueStatus=new IssueStatus();
        if(issue.size()>0)
        {
            issueStatus.Issue_key=issue[0].Jira_Issue_Key__c;
            issueStatus.exist=FALSE;
            return issueStatus;
        }
        else{
            issueStatus.Issue_key=null;
            issueStatus.exist=TRUE;
            return issueStatus;
        }
        
       
    }
}