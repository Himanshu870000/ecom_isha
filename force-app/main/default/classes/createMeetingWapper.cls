public class createMeetingWapper{
    Public String topic {get;set;}
    Public Integer type {get;set;}
    Public String start_time {get;set;}
    Public Integer duration {get;set;}
    Public String timezone {get;set;}
    Public String password {get;set;}
    public Boolean  email_notification{get;set;}
    public Boolean  pre_schedule{get;set;}
    public Settings settings;
    public class Settings {
        public List<MeetingInvitee> meeting_invitees;
        public String alternative_hosts;
        public Boolean alternative_hosts_email_notification;
        public Boolean registrants_email_notification;
        public Boolean registrants_confirmation_email;
    }
    public class MeetingInvitee {
        public String email;
    }
}