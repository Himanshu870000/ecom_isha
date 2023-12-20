global without Sharing class BDAActivityWrapper	implements Comparable{
    @auraEnabled
    global String ActivityType {get; set;}
    @auraEnabled
    global DateTime Enddatetime {get; set;}
    @auraEnabled
    global DateTime Startdatetime {get; set;}
    @auraEnabled
    global decimal ActivityDuration {get; set;}
    //public Lead LeadRecord {get; set;} 
    @auraEnabled
    global Task TaskRecord {get; set;}
    @auraEnabled
    global String Description {get; set;}
    @auraEnabled
    global DateTime Descriptiondt {get; set;}
    @auraEnabled
    global User_Tracking__c UserTrackingInfo {get; set;}
    global BDAActivityWrapper (){}
    
    global BDAActivityWrapper (String ActivityType,DateTime Enddatetime,DateTime Startdatetime, decimal ActivityDuration, Task TaskRecord, String Description, User_Tracking__c UserTrackingInfo,DateTime Descriptiondt){
        this.ActivityType = ActivityType;
        this.Enddatetime = Enddatetime;
        this.Startdatetime =Startdatetime;
        this.ActivityDuration = ActivityDuration;
        //this.LeadRecord = LeadRecord;
        this.TaskRecord = TaskRecord;
        this.Description = Description;
        this.UserTrackingInfo = UserTrackingInfo;
        this.Descriptiondt=Descriptiondt;
    }
    Public Integer compareTo (Object compareTo) {
        BDAActivityWrapper BDAactiveInstance = (BDAActivityWrapper)compareTo;
        Integer returnValue = 0;
        If (Startdatetime > BDAactiveInstance.Startdatetime) {
            returnValue = 1;
        } else if (Startdatetime < BDAactiveInstance.Startdatetime) {
            returnValue = -1;
        }
        Return returnValue; 
    }
}