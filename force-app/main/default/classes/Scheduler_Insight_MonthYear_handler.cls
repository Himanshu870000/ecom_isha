public class Scheduler_Insight_MonthYear_handler {

    @AuraEnabled
    public static Monthly_Beat_Plan__c getMonthBeatPlan(String month,string year){
        Monthly_Beat_Plan__c getAllMBPList = [Select Id,Name,Sales_User__c,Sales_User__r.Name,CreatedDate,Month__c,Month_Name__c,Year__c,Status__c From Monthly_Beat_Plan__c Where Sales_User__c =: userInfo.getUserId() AND Month_year__c=:year AND Month_Name__c=:month LIMIT 1];
        System.debug('getAllMBPList ==>'+getAllMBPList.Sales_User__r.Name);
         System.debug('getAllMBPList ==>'+getAllMBPList);
        return getAllMBPList;
    }
    
    @AuraEnabled
    Public static List<Day_Visit_Plan__c> getMonthlyRecord(String month,string year){
        List<Day_Visit_Plan__c> getAllDayVisitPlanRecList = [Select Id,Start_Date__c,End_Date__c,Total_Distance__c, Total_Covered_Distance__c,CreatedDate From Day_Visit_Plan__c where Service_Executive__c =: userInfo.getUserId() AND Month_year__c=:year AND Month_Name__c=:month];
        
        return getAllDayVisitPlanRecList;
    }
    
    @AuraEnabled
    Public static Id saveFilesUnderMTE(String month,string year){
        Id currentUserId = UserInfo.getUserId();
        Integer yearNumber = system.today().Year();
        System.debug('yearNumber before ==> ' + yearNumber);
        if(year!= null && year != ''){
            yearNumber = Integer.valueOf(year);
        }
        System.debug('yearNumber after ==> ' + yearNumber);
        Monthly_Travel_Expense__c mteRec = [SELECT Id, Name FROM Monthly_Travel_Expense__c WHERE Month_Name__c =: month AND CALENDAR_YEAR(Start_Date__c)=:yearNumber AND Sales_User__c =: currentUserId LIMIT 1];
        if(mteRec.id != null){
            return mteRec.id;
        }
        return null;
    }
}