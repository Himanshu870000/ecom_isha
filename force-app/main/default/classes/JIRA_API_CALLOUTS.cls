public class JIRA_API_CALLOUTS {
	private static String Email='kishan.p@utilitarianlab.com';
    private static String API_TOKEN='XiD88q5h0ijaSgRhKCkD6A3B';
    private static string jira_project='SJC';
    private static string endpoint='https://utilitarianlabs.atlassian.net/rest/api';
    private static string V2='/2/';
    private static string V3='/3/';
    
    class jiraWrapper{
        public string id {get;set;}
        public string key {get;set;}
        public string self {set;get;}
    }
    
    
    public static Boolean add_jira_issue(Id caseID){
        Http http = new Http();
        HttpRequest request= new HttpRequest();
        request.setEndpoint(JIRA_API_CALLOUTS.endpoint + JIRA_API_CALLOUTS.V2 +'issue');
        request.setHeader('Accept', 'application/json');
        Blob headerValue = Blob.valueOf(JIRA_API_CALLOUTS.Email + ':' + JIRA_API_CALLOUTS.API_TOKEN);
        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
        
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('Authorization', authorizationHeader);

        String JSONData = JSONEditor.jsonGenerator(caseID); //JSON.serialize(CreateIssueJsonJIra); 
        System.debug(JSONData);
        request.setBody(JSONData);
        
        try{
        HttpResponse response= http.send(request);
        System.debug(response.getBody());
        System.debug(response.getStatusCode());
        System.debug(response.getStatus());
        if(response.getStatusCode()==201)
        {
        	System.debug(response.getBody());
           	jiraWrapper JIRA_ISSUE=(jiraWrapper)JSON.deserialize(response.getBody(), jiraWrapper.Class);
            System.debug(JIRA_ISSUE);
            
            createJiraissuewithCase(caseID,JIRA_ISSUE);
            return TRUE;
        }
            else{
        		return FALSE;        
            }
        
        }
        catch(Exception ex){
            System.debug(ex.getMessage());
            return FALSE;
        }
    }
    public static void createJiraissuewithCase(string csId,jiraWrapper JIRA_ISSUE){
        Jira_issue__c JIRA=new Jira_issue__c();
        JIRA.Issue_Id__c=JIRA_ISSUE.id;
        JIRA.Jira_Issue_Key__c=JIRA_ISSUE.key;
        JIRA.Jira_Issue_URL__c=JIRA_ISSUE.self;
        JIRA.Case__c=csId;
        System.debug(JIRA);
        insert JIRA;
    }
    
    public static Boolean add_jira_comment(string description,string Issue_key){
		Http http=new Http();
        HttpRequest request=new HttpRequest();
       
        request.setHeader('Accept', 'application/json');
        
        request.setEndpoint(JIRA_API_CALLOUTS.endpoint + JIRA_API_CALLOUTS.V2 +'issue/'+Issue_key+'/comment');
        Blob headerValue = Blob.valueOf(JIRA_API_CALLOUTS.Email + ':' + JIRA_API_CALLOUTS.API_TOKEN);
        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
        
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('Authorization', authorizationHeader);
        String JSONData = JSONEditorForAddComments.jsonGenerator(description);
        
        request.setBody(JSONData);
        try{
            HttpResponse response= http.send(request);
        System.debug(response.getStatusCode());
            if(response.getStatusCode()==201){
                System.debug(response.getBody());
                return TRUE;
            }
            else{
                return FALSE;
            }
        }
        catch(Exception ex){
            System.debug(ex.getCause());
            return FALSE;
        }
        
    }
    public static List<jiraIssueStatusWrapper> get_jira_issue_by_case(Id caseID){
        List<Jira_issue__c> Jira_Issues= [SELECT Id, Case__c, Issue_Id__c,Jira_Issue_Key__c,Jira_Issue_URL__c,Case__r.Subject,Case__r.Description FROM Jira_issue__c where Case__c=:caseID];
        
        Http http = new Http();
        HttpRequest request= new HttpRequest();
        Blob headerValue = Blob.valueOf(JIRA_API_CALLOUTS.Email + ':' + JIRA_API_CALLOUTS.API_TOKEN);
        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
        
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('Accept', 'application/json');
        request.setHeader('Authorization', authorizationHeader);
        request.setMethod('GET');
        List<jiraIssueStatusWrapper> jiraIssuesList=new List<jiraIssueStatusWrapper>();
        
        for(Jira_issue__c jira_issue:Jira_Issues){
			System.debug(jira_issue);
            request.setEndpoint(jira_issue.Jira_Issue_URL__c);
            request.setHeader('Content-Type', 'application/json');
            //request.setBody(body)
            System.debug(JIRA_API_CALLOUTS.endpoint);
            
            HttpResponse response= http.send(request);
            try{
            if(response.getStatusCode()==200)
            {
                System.debug('response:::'+response.getBody());
                System.debug(JSON.deserialize(response.getBody(), jiraIssueStatusWrapper.Class));
                jiraIssueStatusWrapper wrapper=(jiraIssueStatusWrapper)JSON.deserialize(response.getBody(), jiraIssueStatusWrapper.Class);
                wrapper.caseSubject=jira_issue.Case__r.Subject;
                wrapper.caseDescription=jira_issue.Case__r.Description;
                jiraIssuesList.add(wrapper);
            }
            }
            catch(Exception ex){
                System.debug(ex.getLineNumber());
            }
         }
        System.debug('Wrapper'+jiraIssuesList);
        return jiraIssuesList;
    }
    
    public static string get_jira_issues(){
        Http http = new Http();
        HttpRequest request= new HttpRequest();
        request.setEndpoint(JIRA_API_CALLOUTS.endpoint+ JIRA_API_CALLOUTS.V3 +'search');
        request.setHeader('Content-Type', 'application/json');
        Blob headerValue = Blob.valueOf(JIRA_API_CALLOUTS.Email + ':' + JIRA_API_CALLOUTS.API_TOKEN);
        String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
        
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('Authorization', authorizationHeader);
        request.setMethod('GET');
        //request.setBody(body)
        System.debug(JIRA_API_CALLOUTS.endpoint);
        
        HttpResponse response= http.send(request);
        if(response.getStatusCode()==200)
        {
        	System.debug(response.getBody());
            return response.getBody();
        }
        return response.getBody();
    }
    
    public class commentsWrapper{
        @auraEnabled
        public List<Comments> comments {get; set;}
    }    
    
    class Comments{
        @auraEnabled
        public string created {get;set;}
        @auraEnabled
        public string self {get;set;}
        @auraEnabled
        public Author author {get;set;}
        @auraEnabled
        public Body body {get;set;}
    }
    class Author {
        @auraEnabled
        public string displayName {get;set;}
    }
    class Body{
        @auraEnabled
        public string type {get;set;}
        @auraEnabled
        public List<Content> content {get;set;}
    }
    class Content{
        @auraEnabled
        public string type {get;set;}
        @auraEnabled
        public List<MainContent> content {get;set;}
    }
    class MainContent {
        @auraEnabled
        public string type {get;set;}
        @auraEnabled
        public string text {get;set;}
    }
    public static commentsWrapper get_jira_commnets(Id caseID,string Issue_key){
        List<Jira_issue__c> jiraIssue=[SELECT Id, Case__c, Issue_Id__c,Jira_Issue_Key__c,Jira_Issue_URL__c FROM Jira_issue__c where Case__c=:caseID];
        System.debug(jiraIssue);
        if(jiraIssue.size()>0){
           
        Http http = new Http();
        HttpRequest request= new HttpRequest();
        Blob headerValue = Blob.valueOf(JIRA_API_CALLOUTS.Email + ':' + JIRA_API_CALLOUTS.API_TOKEN);
        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
        
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('Accept', 'application/json');
        request.setHeader('Authorization', authorizationHeader);
        request.setMethod('GET');
        
        request.setEndpoint(JIRA_API_CALLOUTS.endpoint+ JIRA_API_CALLOUTS.V3+'/issue/'+jiraIssue[0].Jira_Issue_Key__c+'/comment');
        System.debug(request.getEndpoint());
        request.setHeader('Content-Type', 'application/json');
        //request.setBody(body)
        
        
        HttpResponse response= http.send(request);
        try{
            if(response.getStatusCode()==200)
            {
                System.debug(response.getBody());
                commentsWrapper commentWrap=(commentsWrapper)JSON.deserialize(response.getBody(), commentsWrapper.Class);
                System.debug(commentWrap);
                return commentWrap;
           }
        }
        catch(Exception ex){
            System.debug(ex.getMessage());
        }
        return null;
             
        }
        else{
            return null;
        }
    }
    
  
}