global class MultipleGeolocationController {
    
    global class datewiseVisitWrp{
        @AuraEnabled
        global  List<Map<String,Object>> markerLocationList;
       // @AuraEnabled
      //  global  List<Visit__c> visitList;
      //  @AuraEnabled
     //   global  List<Visit__c> visitCompList;
    }
    @AuraEnabled
    global static datewiseVisitWrp getAllVisitDetails(string visitDate, double currentPosLat, double currentPosLng){
        datewiseVisitWrp datewiseVisitWrapper = new datewiseVisitWrp();
        String[] arrTest = visitDate.split('T');
        string[] dateArray = arrTest[0].split('-');
        Integer year = Integer.valueOf(dateArray[0]);
        Integer month = Integer.valueOf(dateArray[1]);
        Integer day = Integer.valueOf(dateArray[2]);
        date newDate = date.newInstance(year, month, day);
        List<Visit__c> visitByDateList = new List<Visit__c>();
        List<Visit__c> pendingVisitList = new List<Visit__c>();
        List<Visit__c> completedVisitList = new List<Visit__c>();
        Map<String,Object> mapuser=new Map<String,Object>();
        List<Map<String,Object>> markerLocationsList = new List<Map<String,Object>>();
        if(currentPosLat != null && currentPosLng != null)
            visitByDateList = [SELECT id, Visit_Status__c, City__c, Country__c, State__c, Street__c, Postal_Code__c, Geo_Location__latitude__s, Geo_Location__longitude__s, Lead__c, Lead__r.Name ,Account__r.Name,Account__r.Phone,Planned_visit_date__c,Visit_Plan__c,CheckIn__c,Check_Out__c,Visit_Plan__r.End_Location__Latitude__s FROM Visit__c WHERE Planned_visit_date__c = :newDate AND Geo_Location__latitude__s !=null LIMIT 5];
        System.debug('visitByDateList Size === >'+visitByDateList.size());
        for(Visit__c vst : visitByDateList) {
            if(vst.Geo_Location__latitude__s != null && vst.Geo_Location__longitude__s != null) {
                mapuser=new Map<String,Object>();
                mapuser.put('lat',vst.Geo_Location__latitude__s);  
                mapuser.put('lng',vst.Geo_Location__longitude__s);
                markerLocationsList.add(mapuser);
            }
        }
        datewiseVisitWrapper.markerLocationList = markerLocationsList;
        system.debug('datewiseVisitWrapper === >'+datewiseVisitWrapper);
        return datewiseVisitWrapper; 
    }
}