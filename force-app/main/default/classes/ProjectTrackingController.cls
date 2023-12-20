global class ProjectTrackingController {
    public static User userList{get;set;}
    public static Visit__c visituser{get;set;}
    public static String visitLocation{get;set;}
    public static String complatedVisit{get;set;}
    public static String visitLocationperDate{get;set;}
    public Static String userId{get;set;}
    public Static String visitListTobePending{get;set;}
    public Static String visitListTobeCompleted{get;set;}
    public Static boolean dayplanCreated{get;set;}
    global class datewiseVisitWrp{
        String visitstr;
        String visitCompstr;
        List<Visit__c> visitList;
        List<Visit__c> visitCompList;
    }
    global ProjectTrackingController(){
        system.debug('userList.id');
        userId = UserInfo.getUserId();
        getVisitonPageload(userId);
    }
    global static void getVisitonPageload(String usrId){
        system.debug('userId::'+usrId);
        List<Visit__c> visitPendingList = new List<Visit__c>();
        List<Visit__c> visitComplatedList = new List<Visit__c>();
        list<Day_Visit_Plan__c> isDayvisitPlanCreated = new list<Day_Visit_Plan__c>();
        Map<String,Double> mapuser=new Map<String,Double>();
        List<Map<String,Double>> listmapusertrack= new List<Map<String,Double>>();
        
        visitPendingList = [SELECT id,Job_Status__c,Project__r.city__c,Project__r.Project_Lat__longitude__s,Project__r.name,Project__r.Project_Lat__latitude__s,Account__r.Phone,Planned_visit_date__c,lead__r.name,lead__r.phone FROM Visit__c WHERE Assigned_User__c =: usrId AND Check_Out__Latitude__s = null AND Planned_visit_date__c = :system.today()];
        visitComplatedList = [SELECT id,Job_Status__c,Project__r.city__c,Project__r.Project_Lat__longitude__s,Project__r.Project_Lat__latitude__s,Project__r.name,Planned_visit_date__c,lead__r.name,lead__r.phone FROM Visit__c WHERE Assigned_User__c =: usrId AND Check_Out__Latitude__s != null AND Planned_visit_date__c = :system.today()];
        isDayvisitPlanCreated = [select id,createddate from Day_Visit_Plan__c where CreatedDate <= TODAY limit 1];
        if(!isDayvisitPlanCreated.isEmpty())
            dayplanCreated = true;
        else 
            dayplanCreated = false;
        visitListTobePending = JSON.serialize(visitPendingList);
        visitListTobeCompleted = JSON.serialize(visitComplatedList);
        system.debug('visitPendingList::'+visitPendingList);
        visitLocation = JSON.serialize(visitPendingList);
        system.debug('visitLocation::'+visitLocation);
        complatedVisit = JSON.serialize(complatedVisit);
        system.debug('complatedVisit::'+complatedVisit);
        
        for(Visit__c vst : visitPendingList){
            system.debug('vst::'+vst);
            mapuser=new Map<String,Double>();
            mapuser.put('lat',vst.Project__r.Project_Lat__latitude__s);  
            mapuser.put('lng',vst.Project__r.Project_Lat__longitude__s);
            system.debug('mapuser::'+mapuser);
            listmapusertrack.add(mapuser);
        }
        
        
        system.debug('listmapusertrack::'+listmapusertrack);
        visitLocation = JSON.serialize(listmapusertrack);
        system.debug('visitLocation::'+visitLocation);
        listmapusertrack = new List<Map<String,Double>>();
        for(Visit__c vst : visitComplatedList){
            system.debug('vst::'+vst);
            mapuser=new Map<String,Double>();
            mapuser.put('lat',vst.Project__r.Project_Lat__latitude__s);  
            mapuser.put('lng',vst.Project__r.Project_Lat__longitude__s);
            system.debug('mapuser::'+mapuser);
            listmapusertrack.add(mapuser);
        }
        complatedVisit = JSON.serialize(listmapusertrack);
        system.debug('complatedVisit:'+complatedVisit);
        system.debug('visitLocation::'+visitLocation);
    }
    @RemoteAction
    global static datewiseVisitWrp userPopulated(string visitDate,String usrId){
        datewiseVisitWrp datewiseVisitWrapper = new datewiseVisitWrp();
        system.debug('userId::'+usrId);
        system.debug('visitDate::'+visitDate);
        string temp = '';
        String[] arrTest = visitDate.split('T');
        string[] dateArray = arrTest[0].split('-');
        
        Integer year = Integer.valueOf(dateArray[0]);
        Integer month = Integer.valueOf(dateArray[1]);
        Integer day = Integer.valueOf(dateArray[2]);
        date newDate = date.newInstance(year, month, day);
        system.debug(newDate);
        List<Visit__c> visitPendingList = new List<Visit__c>();
        List<Visit__c> visitComplatedList = new List<Visit__c>();
        Map<String,Double> mapuser=new Map<String,Double>();
        List<Map<String,Double>> listmapusertrack= new List<Map<String,Double>>();
        visitPendingList = [SELECT id,Job_Status__c,Project__r.city__c,Project__r.name,Project__r.Project_Lat__longitude__s,Project__r.Project_Lat__latitude__s,Planned_visit_date__c,lead__r.name,lead__r.phone FROM Visit__c WHERE Assigned_User__c =: usrId AND Check_Out__Latitude__s = null AND Planned_visit_date__c = :newDate];
        visitComplatedList = [SELECT id,Job_Status__c,Project__r.city__c,Project__r.name,Account__r.Name,Project__r.Project_Lat__longitude__s,Project__r.Project_Lat__latitude__s,Planned_visit_date__c,lead__r.name,lead__r.phone FROM Visit__c WHERE Assigned_User__c =: usrId AND Check_Out__Latitude__s != null AND Planned_visit_date__c = :newDate];
        system.debug('visitPendingList::'+visitPendingList);
        temp = JSON.serialize(visitPendingList);
        system.debug('visitLocation::'+visitLocation);
        complatedVisit = JSON.serialize(complatedVisit);
        system.debug('complatedVisit::'+complatedVisit);
        
        for(Visit__c vst : visitPendingList){
            system.debug('vst::'+vst);
            mapuser=new Map<String,Double>();
            mapuser.put('lat',vst.Project__r.Project_Lat__latitude__s);  
            mapuser.put('lng',vst.Project__r.Project_Lat__longitude__s);
            system.debug('mapuser::'+mapuser);
            listmapusertrack.add(mapuser);
        }
        
        
        system.debug('listmapusertrack::'+listmapusertrack);
        datewiseVisitWrapper.visitstr = JSON.serialize(listmapusertrack);
        
        listmapusertrack = new List<Map<String,Double>>();
        for(Visit__c vst : visitComplatedList){
            system.debug('vst::'+vst);
            mapuser=new Map<String,Double>();
            mapuser.put('lat',vst.Project__r.Project_Lat__latitude__s);  
            mapuser.put('lng',vst.Project__r.Project_Lat__longitude__s);
            system.debug('mapuser::'+mapuser);
            listmapusertrack.add(mapuser);
        }
        if(newDate < system.today())
            datewiseVisitWrapper.visitCompstr = JSON.serialize(listmapusertrack);
        datewiseVisitWrapper.visitList = visitPendingList;
        datewiseVisitWrapper.visitCompList = visitComplatedList;
        system.debug('temp::'+temp);
        
        RETURN datewiseVisitWrapper;
    }
    
    @RemoteAction
    global static String changePlannedVisitdate(String newVisitdate,String visitId){
        try{
            visit__C vstRec = new visit__c();
            vstRec.Id = visitId;
            vstRec.Planned_visit_date__c = date.valueOf(newVisitdate);
            UPDATE vstRec;
            RETURN 'Visit date has been changed successfully.';
        }catch(Exception e){
            system.debug('Exception trace::'+e.getStackTraceString());
            RETURN 'Something went wrong';
        }
        
        
    }
    
    @RemoteAction
    global static String createVisitPlanAcrossUser(Decimal startLat,Decimal startLang,String userId){
        system.debug('startLat::'+startLat);
        system.debug('startLang::'+startLang);
        List<Visit__c> visitListTobeTag = new List<Visit__c>();
        visitListTobeTag = [SELECT id,Visit_Plan__c,Assigned_User__c FROM Visit__c WHERE Assigned_User__c =: userId and Planned_visit_date__c =: system.today()];
        try{
            if(visitListTobeTag.isEmpty()){
                Return 'No visit Planned for day.';
            }
            Day_Visit_Plan__c vstPlan = new Day_Visit_Plan__c();
            vstPlan.Service_Executive__c = userId;
            vstPlan.Start_Location__Latitude__s = startLat;
            vstPlan.Start_Location__Longitude__s = startLang;
            
            INSERT vstPlan;
            
            for(Visit__c vst : visitListTobeTag){
                vst.Visit_Plan__c = vstPlan.Id;
            }
            
            UPDATE visitListTobeTag;
            
            RETURN 'Your visit plan has been generated.';
            
        }catch(Exception e){
            System.debug('Exception Trace::'+e.getStackTraceString());
            RETURN 'Something went wrong.';
        }
        
        
    }
}