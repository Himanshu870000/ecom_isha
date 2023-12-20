public without Sharing class BDAFullViewHelper{
    public static List<BDAActivityWrapper> GetAllRecord(String UserId, Date DateTobeQuery){
        List<BDAActivityWrapper> ActivityWrapperList = new List<BDAActivityWrapper>();
        try{
            List<Lead> Leadrecords = BDAFullViewModal.GetLead(UserID);
            list<task> TaskRecords = BDAFullViewModal.GetTask(UserId, DateTobeQuery);
            List<LeadHistory> LeadHistoryrecords = BDAFullViewModal.GetLeadHistoryChange(UserId, DateTobeQuery);
            list<User_Tracking__c> userTrackingRecords = BDAFullViewModal.GetUserTracking(UserId, DateTobeQuery);
            List<EmailMessage> SendEmailRecords = BDAFullViewModal.GetEmailSentList(UserId, DateTobeQuery);
            //Map<Id, task> CallRecordwithId = new Map<Id, task>();
            
            for (Task taskRec : TaskRecords){
                datetime StartDT;
                datetime EndDT;
                String ActivityRec;
                if (taskRec.Activity_Type__c == 'Talk to Us' || taskRec.Activity_Type__c == 'Stage Changed'){
                    ActivityRec = taskRec.Activity_Type__c;
                    StartDT = taskRec.CreatedDate;
                    string DescriptionDetails = taskRec.Description;
                    ActivityWrapperList.add(new BDAActivityWrapper(ActivityRec, null, StartDT, null, null, DescriptionDetails, null, null));
                } else if (taskRec.Activity_Type__c == 'Take Follow-up from Candidate'){
                    ActivityRec = taskRec.Activity_Type__c;
                    StartDT = taskRec.CreatedDate;
                    DateTime ActualFollowUpActivityDT = DateTime.newInstance(StartDT.year(), StartDT.month(), StartDT.day(), StartDT.hour() + 5, StartDT.minute() + 30, StartDT.second());
                    string DescriptionDetails = 'Follow-Up Activity is Created at - ' + ActualFollowUpActivityDT;
                    ActivityWrapperList.add(new BDAActivityWrapper(ActivityRec, null, StartDT, null, null, DescriptionDetails, null, null));
                    
                } else if (taskRec.Subject.Contains('Received') || taskRec.Subject.Contains('Missed')){
                    
                    ActivityRec = 'Inbound Call Activity';
                    StartDT = taskRec.CreatedDate;
                    DateTime CallActualDT = DateTime.newInstance(taskRec.CreatedDate.year(), taskRec.CreatedDate.month(), taskRec.CreatedDate.day(), taskRec.CreatedDate.hour() + 5, taskRec.CreatedDate.minute() + 30, taskRec.CreatedDate.second());
                    string DynamicDescription = 'Call Activity is performed by this Agent at - ' + CallActualDT + ' with call Duration :: ' + taskRec.CallDurationInSeconds;
                    ActivityWrapperList.add(new BDAActivityWrapper(ActivityRec, null, StartDT, null, null, DynamicDescription, null, null));
                } else if (taskRec.Activity_Type__c != 'Call'){
                    DateTime StartDTSendToUI;
                    DateTime EndDTSendToUI;
                    if (taskRec.Activity_Type__c == Null){
                        ActivityRec = 'Dialed Call';
                    }
                    decimal callduration = decimal.valueOf(taskRec.tdc_cti__Call_Duration__c);
                    string DescriptionDetails = 'Call is made by this Agent at - ' + StartDT + ' with call Duration :: ' + callduration;
                    ActivityWrapperList.add(new BDAActivityWrapper(ActivityRec, EndDTSendToUI, StartDTSendToUI, callduration, null, DescriptionDetails, null,null));
                }
                //system.debug('CallRecordwithId :: ' + CallRecordwithId);
            }
            
            for (LeadHistory LeadHistoryRec : LeadHistoryrecords){
                if (LeadHistoryRec.Field != 'Owner' && LeadHistoryRec.Field != null && LeadHistoryRec.OldValue != null && LeadHistoryRec.NewValue != null){
                    String FieldLabelName = fetchLeadFieldLabelName.FetchLabelName(LeadHistoryRec.Field);
                    if (FieldLabelName != 'Last Connected Date Time' || FieldLabelName != 'Payment DateTime' || FieldLabelName != 'Lead Created Date' || FieldLabelName != 'Lead Assigned Date' || 
                        FieldLabelName != 'Payment Success Date/Time' || FieldLabelName != 'Connected Call Time (in Seconds)' || FieldLabelName != 'Closed Lost Date Time' || FieldLabelName != 'First Connected Date Time' || 
                        FieldLabelName != 'Lead Assigned Time' || FieldLabelName != 'Re-Engagement Time' || FieldLabelName != 'Refurbished' || FieldLabelName != 'Re-Engagement Activity Time' || 
                        FieldLabelName != 'RM assigned Date/Time' || FieldLabelName != 'Is Remarketing Lead' || FieldLabelName != 'First Called Date Time' || FieldLabelName != 'FRT Connected Updated'){
                            string DynamicDescription = 'The ' + FieldLabelName + ' is Changed From ' + LeadHistoryRec.OldValue + ' to ' + LeadHistoryRec.NewValue;
                            datetime startDT = LeadHistoryRec.CreatedDate;
                            ActivityWrapperList.add(new BDAActivityWrapper('Lead Change History', null, startDT, null, null, DynamicDescription, null, null));
                            
                        }
                    
                    
                } else if (LeadHistoryRec.Field == 'Owner'){
                    
                }
            }
            for (User_Tracking__c userTrackRec : userTrackingRecords){
                BDAActivityWrapper ActivityWrapperInstance = new BDAActivityWrapper();
                ActivityWrapperInstance.UserTrackingInfo = userTrackRec;
                String ActivityRec;
                if (userTrackRec.Checkin_Detatime__c != Null){
                    ActivityRec = 'User Checkin Record';
                    string dynamicDescription = 'This BDA  checked-in at ::';
                    datetime startdDT = userTrackRec.Checkin_Detatime__c;
                    ActivityWrapperList.add(new BDAActivityWrapper(ActivityRec, null, startdDT, null, null, dynamicDescription, null, userTrackRec.Checkin_Detatime__c));
                }
                if (userTrackRec.Checkin_Detatime__c != Null && userTrackRec.Checkout_Datetime__c != Null){
                    ActivityRec = 'User CheckOut Record';
                    string dynamicDescription = 'This BDA  checked-out at ::';
                    datetime startdDT = userTrackRec.Checkout_Datetime__c;
                    ActivityWrapperList.add(new BDAActivityWrapper(ActivityRec, null, startdDT, null, null, dynamicDescription, null, userTrackRec.Checkout_Datetime__c));
                }
                
                
            }
            for (EmailMessage Em : SendEmailRecords){
                
                DateTime EmailActualDT = DateTime.newInstance(Em.MessageDate.year(), Em.MessageDate.month(), Em.MessageDate.day(), Em.MessageDate.hour() + 5, Em.MessageDate.minute() + 30, Em.MessageDate.second());
                string DynamicDescription = 'The BDA, ' + Em.FromName + ' have send Email to ' + Em.ToAddress + ' at :: ' + EmailActualDT + ' with subject name :: ' + Em.Subject;
                datetime startdDT = Em.MessageDate;
                datetime endDT = Em.MessageDate;
                ActivityWrapperList.add(new BDAActivityWrapper('User Sent Email Records', endDT, startdDT, null, null, DynamicDescription, null, null));
            }
            
            ActivityWrapperList.sort ();
            System.Debug('@@@@@ ActivityWrapperList => ' + ActivityWrapperList);
            for (integer i = 0; i < ActivityWrapperList.size(); i++){
                system.debug('ActivityWrapperList[i] :: ' + ActivityWrapperList[i]);
            }
            return ActivityWrapperList;
        } catch (Exception e){
            system.debug('The following exception has occurred: ' + e.getMessage() + 'at line Number : ' + e.getLineNumber());
            return null;
        }
    }
    
    public static DateTime getDateTimeFromString(String dtString){
        dtString = dtString.replace(' ', 'T');
        DateTime dt = (DateTime) JSON.deserialize('"' + dtString + '"', DateTime.class);
        //System.debug(dt);
        return dt;
    }
    
    //btach for idle time
    public static void BDAIdleTimeReport(String UserId, Date DateTobeQuery){
        
        list<task> TaskRecords = BDAFullViewModal.GetTask(UserId, DateTobeQuery);
        system.debug('TaskRecords :: ' + TaskRecords);
        Map<Id, task> CallRecordwithId = new Map<Id, task>();
        List<Idle_Time_Report__c> ITRRecordList = new List<Idle_Time_Report__c>();
        try{
            for (Task taskRec : TaskRecords){
                if (taskRec.Activity_Type__c != 'IVR Call'){
                    CallRecordwithId.put(taskRec.Id, taskRec);
                }
            }
            system.debug(' CallRecordwithId :: ' + CallRecordwithId);
            system.debug('CallRecordwithId.values() :: ' + CallRecordwithId.values());
            for (integer i = 0; i < CallRecordwithId.values().size(); i++){
                DateTime NextithStartTime;
                DateTime ithEndTime;
                integer idleTimeHours;
                integer idleTimeMinutes;
                system.debug('CallRecordwithId.values() size :: ' + CallRecordwithId.values().size());
                integer totalIdleTimeInTwoConsecutiveRecordInMinutes;
                ithEndTime = CallRecordwithId.values()[i].CreatedDate;
                system.debug('ithEndTime :: ' + ithEndTime);
                
                if ((i + 1) < CallRecordwithId.values().size()){
                    NextithStartTime = CallRecordwithId.values()[i+1].CreatedDate;
                    system.debug('NextithStartTime :: ' + NextithStartTime);
                }
                
                if (NextithStartTime != Null){
                    idleTimeHours = (CallRecordwithId.values()[i+1].CreatedDate).hour()-(CallRecordwithId.values()[i].CreatedDate.addMinutes(10)).hour();
                    system.debug('idleTimeHours :: ' + idleTimeHours);
                    idleTimeMinutes = (CallRecordwithId.values()[i+1].CreatedDate).minute() - (CallRecordwithId.values()[i].CreatedDate.addMinutes(10)).minute();
                    system.debug('idleTimeMinutes :: ' + idleTimeMinutes);
                    if (idleTimehours >= 1){
                        totalIdleTimeInTwoConsecutiveRecordInMinutes = idleTimeHours*60 + idleTimeMinutes;
                    } else{
                        totalIdleTimeInTwoConsecutiveRecordInMinutes = idleTimeMinutes;
                    }
                    system.debug('total Idle Time In Two Consecutive Record In Minutes :: ' + totalIdleTimeInTwoConsecutiveRecordInMinutes);
                    
                    //************************************************** change minimum idle time to check From here***********************************************************//
                    
                    if (totalIdleTimeInTwoConsecutiveRecordInMinutes >= 30){
                        Idle_Time_Report__c ITRRecord = new Idle_Time_Report__c();
                        ITRRecord.Report_Date__c = system.today();
                        ITRRecord.BDA__c = CallRecordwithId.values()[i].OwnerId;
                        dateTime UpdatedStartTimeafterMinutes = ithEndTime.addMinutes(-30);
                        dateTime UpdatedStartTimeafterHours = UpdatedStartTimeafterMinutes.addhours(-5);
                        system.debug('Updated Start Time after Hours :: ' + UpdatedStartTimeafterHours);
                        ITRRecord.Idle_Start_Time__c = UpdatedStartTimeafterHours;
                        
                        dateTime UpdatedEndTimeafterMinutes = NextithStartTime.addMinutes(-30);
                        dateTime UpdatedEndTimeafterHours = UpdatedEndTimeafterMinutes.addhours(-5);
                        system.debug('Updated End Time after Hours :: ' + UpdatedEndTimeafterHours);
                        ITRRecord.Idle_End_Time__c = UpdatedEndTimeafterHours;
                        ITRRecord.Total_Idle_Time__c = totalIdleTimeInTwoConsecutiveRecordInMinutes;
                        ITRRecordList.add(ITRRecord);
                    }
                }
                
            }
            if (!ITRRecordList.isempty()){
                Daily_Idle_View__c divInstance = new Daily_Idle_View__c(BD_User__c = UserId);
                insert divInstance;
                if (divInstance.Id != null){
                    for (Idle_Time_Report__c itrRec : ITRRecordList){
                        itrRec.Daily_Idle_View__c = divInstance.Id;
                    }
                    insert ITRRecordList;
                }
            }
           // DateTime.newInstance(ithEndTime.year(), ithEndTime.month(), ithEndTime.day(), ithEndTime.hour(), ithEndTime.minute(), ithEndTime.second());
            system.debug('ITR Record List :: ' + ITRRecordList);
            
        } catch (Exception e){
            System.debug('An exception occurred: ' + e.getMessage() + 'At line number :: ' + e.getLineNumber());
        }
    }
    
}