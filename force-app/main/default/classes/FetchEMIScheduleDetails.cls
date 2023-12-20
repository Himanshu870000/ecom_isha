public without sharing class FetchEMIScheduleDetails {
    
    @AuraEnabled
    public static List<EmicheduleWrapper> emiScheduleDetails(String conId){
        
        User thisUser = [SELECT ID,contactId FROM User WHERE Id =:userInfo.getUserId()];
        
        Date todaydate = system.today();
        //Integer todayDay = todayDate.day();
        Integer todayMonth = todayDate.month();					
        Integer todayYear= todaydate.year();
        date FirstDateOfMonth = todaydate.toStartOfMonth();
        Integer numberOfDaysInThisMonth = date.daysInMonth(todayYear, todayMonth);
        date LastDateOfMonth = FirstDateOfMonth.addDays(numberOfDaysInThisMonth);
        
        List<EmicheduleWrapper> EMIwrapperList = new List<EmicheduleWrapper>();
        List<Contact> conList = [Select id, LastName, FirstName, (Select id, Name, Payment_Schedule_sum__c, Total_Amount__c, Parking_Amount__c From Deals__r) 
                                 From Contact Where Id = :thisUser.contactId]; 
        
        Set<Id> DealsIds = new Set<Id>();
        
        if(conList !=NUll){
            for(Contact con : conList){
                for(Deal__c d : con.Deals__r){
                   DealsIds.add(d.Id);                     
                }
            }
        }
        
        List<Deal__c> dealList = [Select id, Name, Payment_Schedule_sum__c, Total_Amount__c, Parking_Amount__c, 
                                  (Select Name, Total_Amount__c, EMI_Amount__c, Deal__c, Start_Date__c, Due_Date__c From Emi_Schedules__r 
                                   WHERE (Start_Date__c >= : FirstDateOfMonth AND Start_Date__c <= : LastDateOfMonth) OR 
                                   (Due_Date__c >= : FirstDateOfMonth AND Due_Date__c <= : LastDateOfMonth)) 
                                  From Deal__c Where Id IN :  DealsIds];
        
        for(Deal__c d : dealList){
            EmicheduleWrapper EMIwrapperInstance = new EmicheduleWrapper();
            EMIwrapperInstance.DealsName = d.Name;
            EMIwrapperInstance.EMIList = d.Emi_Schedules__r;
            EMIwrapperList.add(EMIwrapperInstance);
        }
        return EMIwrapperList;
         
    }
    
    public class EmicheduleWrapper{
        @AuraEnabled public String DealsName{get;set;}
        @AuraEnabled public List<Emi_Schedule__c> EMIList{get;set;}
    }
    
}