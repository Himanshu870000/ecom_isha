public class createDailyVisitOnFiveAccounts implements Schedulable {

    public void execute(SchedulableContext sc) {
        Date visitDate = Date.today().addDays(1); // Visit scheduled for the next day
        Integer visitMonth = visitDate.Month();
        Integer visitYear = visitDate.Year();
        String visitYearString = String.valueOf(visitYear);
        List<User> systemAdmins = [SELECT Id, Name, ProfileId, Profile.Name FROM USER WHERE Profile.Name = 'System Administrator' AND IsActive = true];
		List<Visit__c> visitsToCreate = new List<Visit__c>();
        List<Account> AccountsList = [SELECT Id, Name FROM Account WHERE BillingStreet != null AND BillingCity != null AND BillingState != null AND BillingPostalCode != null LIMIT 50];
        for(User userRec : systemAdmins){
            List<Monthly_Beat_Plan__c> MBPList =[SELECT id,Year__c,Status__c,Start_Date__c,OwnerId,Sales_User__c,Name,Month__c,End_Date__c,Month_Name__c,(SELECT id,Year__c,Name,Week_Identifier__c,Start_Day_of_Week__c,End_Day_of_Week__c,OwnerId,Monthly_Beat_Plan__c FROM Weekly_Beat_Plans__r) FROM Monthly_Beat_Plan__c WHERE Year__c=:visitYearString AND Month__c=:visitMonth AND Sales_User__c=:userRec.Id LIMIT 1];
       		Id WBPrecIdToTag;
            Monthly_Beat_Plan__c MBPrec = new Monthly_Beat_Plan__c();
            if(MBPList.isEmpty()){
                List<Weekly_Beat_Plan__c> WBPList=new List<Weekly_Beat_Plan__c>();
                
                MBPrec.Sales_User__c = userRec.Id;
                MBPrec.Start_Date__c = visitDate.toStartOfMonth();
                MBPrec.End_Date__c = visitDate.toStartOfMonth().addMonths(1).addDays(-1);
                insert MBPrec;
                
                Datetime startDateTime=visitDate.toStartOfMonth();
       			Datetime endDateEndDateTime=visitDate.toStartOfMonth().addMonths(1).addDays(-1);
                Integer weeksBetween = 0;
                if(MBPrec.Id!=null){
                Date NextWeekStartDate;
                 //Creating Weekly Beat Plan
                
              
                Date WeekStartDate=visitDate.toStartOfMonth();
                //WBP.Start_Day_of_Week__c=WeekStartDate;
                //system.debug('WBP.Start_Day_of_Week__c==='+WBP.Start_Day_of_Week__c);
                integer i= 0;
                date lastWeekEndDate;
                while (startDateTime <= endDateEndDateTime) {
                    System.debug('startDateTime ====> ' + startDateTime);
                    System.debug('endDateEndDateTime ====> ' + endDateEndDateTime);
                        Weekly_Beat_Plan__c WBP=new Weekly_Beat_Plan__c();
                        WBP.Monthly_Beat_Plan__c=MBPrec.Id;
                        date previousWeekEnddate;
                    //date lastDateOfMonth = (Date.valueOf(startDateTime)).toStartOfMonth();
                    system.debug('Date.valueOf(startDateTime)==> ' + Date.valueOf(startDateTime));
                        // if (WBP.End_Day_of_Week__c != null && previousWeekEnddate > Date.valueOf(startDateTime)) {
                        //     WBP.Start_Day_of_Week__c=Date.valueOf(startDateTime);
                        // }
                                
                        if (string.valueof(startDateTime.format('E')) == 'Sun'){   
                            weeksBetween++;    
                            WBP.End_Day_of_Week__c=Date.valueOf(startDateTime);
                            if (weeksBetween == 1) {

                                WBP.Start_Day_of_Week__c = visitDate.toStartOfMonth();
                            }
                            else {
                                WBP.Start_Day_of_Week__c = (WBP.End_Day_of_Week__c).addDays(-6);
                            }
                            
                            previousWeekEnddate = WBP.End_Day_of_Week__c;
                            lastWeekEndDate = WBP.End_Day_of_Week__c;
                            system.debug('WBP.Start_Day_of_Week__c==='+WBP.Start_Day_of_Week__c);
                            WBPList.add(WBP);
                            System.debug('WBPList =====> ' + WBPList);
                        } else if(Date.valueOf(startDateTime) == visitDate.toStartOfMonth().addMonths(1).addDays(-1)){
                        WBP.Start_Day_of_Week__c = lastWeekEndDate.addDays(1);
                        WBP.End_Day_of_Week__c = Date.valueOf(startDateTime);
                            if(WBP.Start_Day_of_Week__c != WBP.End_Day_of_Week__c){
                                WBPList.add(WBP);
                                lastWeekEndDate = WBP.End_Day_of_Week__c;
                            }
                    }
                        
                     startDateTime = startDateTime.addDays(1);
                    
                }
            }
            system.debug('WBPList---'+WBPList);
            if(!WBPList.isEmpty()){
                Insert WBPList;
            }
            }else{
                MBPrec = MBPList[0];
            }
            
        for(Weekly_Beat_Plan__c WBPrec :  MBPrec.Weekly_Beat_Plans__r){
            if(WBPrec.Start_Day_of_Week__c <= visitDate && WBPrec.End_Day_of_Week__c >= visitDate){
                WBPrecIdToTag = WBPrec.Id;
            }
        }
        for(Integer i = 0; i<5; i++){
            Integer randomNumber = Integer.valueof((Math.random() * 4));
            Account accRec = AccountsList.get(randomNumber);
            
            Visit__c visit = new Visit__c();
            visit.Account__c = accRec.Id;
            visit.Planned_visit_date__c = visitDate;
            visit.Actual_visit_date__c = visitDate;
            visit.Assigned_User__c = userRec.Id;
            visit.Weekly_Beat_Plan__c = WBPrecIdToTag;
            visit.Visit_Status__c = 'Assigned';
            visitsToCreate.add(visit);
            
        }       
        }
        if (!visitsToCreate.isEmpty()) {
            insert visitsToCreate;
            System.debug('visitsToCreate==> ' + visitsToCreate);
        }
    }
}