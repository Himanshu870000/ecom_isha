Public class ZoomApis {
    public String bodyprint{get;set;}
    public String pswrd{get;set;}
    
    public  Static String createMeeting(String Subject,String startSlot,Decimal Duration,String LeadEmail) {
        
        List<String> EmailList = new List<String>();
        EmailList.add(LeadEmail);
        Zoom_Api_Details__c Zoom_Details = [Select id,Endpoint_URL__c,JWT_Token__c from Zoom_Api_Details__c];
        system.debug('startSlot'+startSlot+'Duration'+startSlot);
        createMeetingWapper newWapper = new createMeetingWapper();
        newWapper.topic = Subject;
        newWapper.type = 2;
        newWapper.pre_schedule = false;
        newWapper.start_time = startSlot;//'2021-04-21T16:54:14Z';
        newWapper.duration = integer.valueOf(Duration);
        newWapper.timezone = 'Asia/Kolkata';
        newWapper.email_notification = true;
        List<createMeetingWapper.MeetingInvitee> attendeesList = new List<createMeetingWapper.MeetingInvitee>();
        createMeetingWapper.MeetingInvitee test= new createMeetingWapper.MeetingInvitee();
        test.email = LeadEmail;
        attendeesList.add(test);
        
        
        createMeetingWapper.Settings Attendees = new createMeetingWapper.Settings();
        
        Attendees.meeting_invitees = attendeesList;
        //Attendees.alternative_hosts = 'ajeet.kumar@utilitarianlab.com';
        //Attendees.alternative_hosts_email_notification = true;
        Attendees.registrants_email_notification = true;
        Attendees.registrants_confirmation_email = true;
        newWapper.Settings = Attendees;
        string jsonString = JSON.serialize(newWapper);
        System.debug('jsonString >>'+jsonString); 
        
        String endPoint = Zoom_Details.Endpoint_URL__c;
        HttpRequest req = new HttpRequest();
        req.setBody(jsonString);
        req.setMethod('POST');
        req.setHeader('Content-type', 'application/json');
        req.setHeader('Authorization', 'bearer '+Zoom_Details.JWT_Token__c);
        req.setEndpoint(endPoint); 
        Http http = new Http();
        HttpResponse res = http.send(req);
        
        if(res.getStatusCode() == 201){
            // bodyprint = res.getBody();
            ZoomResponseWrapper respWrapObj = ZoomResponseWrapper.parse(res.getBody());
            //bodyprint = respWrapObj.join_url.substringBefore('?');
            //pswrd = respWrapObj.join_url.substringAfter('?');
            //pswrd = pswrd.replace('pwd=', 'Password : ');
            System.debug('Meeting Link >>>' +respWrapObj.join_url);
            System.debug('res pass >>>' +res.getBody());         
            return respWrapObj.join_url;
        }else{
            System.debug('res fail >>>' +res.getBody());
            return 'res.getBody()';
        }
    }
   
}