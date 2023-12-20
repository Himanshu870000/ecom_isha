trigger VisitTrigger on Visit__c (after insert,before insert) {
    
    if(trigger.isAfter && trigger.isInsert){
        visitGeoHelper.getGeoCoordinatesFromAccount(trigger.new);
    }
   /* if(trigger.isAfter && trigger.isInsert){
        String dayvisitId;
        List<Visit__c> vsList = new List<Visit__c>();
        set<Id> visitId = new Set<Id>();
        for(Visit__c vs : trigger.new){
            visitId.add(vs.id);
            System.debug('vs ===== >'+vs);
            Day_Visit_Plan__c day = new Day_Visit_Plan__c();
            day.Service_Executive__c = vs.Assigned_User__c;
            day.Start_Location__Latitude__s = vs.Geo_Location__Latitude__s;
            day.Start_Location__Longitude__s = vs.Geo_Location__Longitude__s;
            insert day;
            dayvisitId = day.id;
            system.debug('Day Visit Record Created');
        }
        List<Visit__c> vsListToUpdate = new List<Visit__c>();
        for(Visit__c vs : [sELECT Id,name,Visit_Plan__c FROM Visit__c WHERE Id IN:visitId]){
            vs.Visit_Plan__c = dayvisitId;
            vsListToUpdate.add(Vs);
        }
        update vsListToUpdate;
    } */
    
    if(trigger.isBefore && trigger.isInsert){
      //  visitGeo.getGeoCoordinates(trigger.new);
        Set<Id> VsRecIdSet = new Set<Id>();
        for(Visit__c vs : trigger.new){
            VsRecIdSet.add(vs.id);
           /* if(String.isNotBlank(vs.Street__c) || vs.Street__c ==null ){
                vs.Street__c = 'Jp Nagar 7th Phase';
            }
             if(String.isNotBlank( vs.City__c) || vs.City__c ==null){
                 vs.City__c = 'Bangalore';
            }
             if(String.isNotBlank( vs.State__c) || vs.State__c ==null){
                 vs.State__c = 'Karnataka';
            }
             if(String.isNotBlank( vs.Country__c) || vs.Country__c ==null){
                vs.Country__c = 'India';
            } */
           // if(vs.AccountAddress__c != null){
              //  vs.Geo_Location__Latitude__s = GeocodingService.getCoordinates(vs.AccountAddress__c).get('latitude');
              //  vs.Geo_Location__Longitude__s = GeocodingService.getCoordinates(vs.AccountAddress__c).get('longitude');
           // }
            
        }
        System.debug('VsRecIdSet === >'+VsRecIdSet);
        if(VsRecIdSet.size()>0){
           // visitGeo.getGeoCoordinates(VsRecIdSet);
        }
    }
}