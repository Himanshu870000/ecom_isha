public with sharing class IccCricketBordsEvents {
     @AuraEnabled(cacheable=true)
    public static list<Sports_Board__c> getBoardsName(  ){
       list<Sports_Board__c> boardsRec =  [  select   Name ,Board_Logo__c  from  Sports_Board__c where Sport__c =: 'a5vN000000017szIAA' ] ;
        system.debug('boardsRec:::' +boardsRec );
         return boardsRec;
    }
    @AuraEnabled(cacheable=true)
    public static List<String> getEvents(){
        List<String> options = new List<String>();
        Schema.DescribeFieldResult fieldResult = Event_Master__c.Events__c.getDescribe();
        List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry p: pList) {
            options.add(p.getLabel());
        }
        system.debug('Events Picklist Value is '+options);
        return options;
        
    }
    @AuraEnabled
     public static List<Event_Master__c> getEventMasters(){
         
   List<Event_Master__c> eventlist = [Select Name From Event_Master__c];
         system.debug('eventlist===>> '+eventlist);
      return eventlist;  
}
}