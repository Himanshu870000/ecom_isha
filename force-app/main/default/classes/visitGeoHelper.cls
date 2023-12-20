public class visitGeoHelper {
    
    // @future
    public static void getGeoCoordinatesFromAccount(List<Visit__c> VisitRecList){
        Set<id> vsRecIdList = new Set<id>();
        List<Visit__c> vsListToUpdate = new List<Visit__c>();
        for(Visit__c vs :VisitRecList ){
            vsRecIdList.add(vs.id);
        }
        
        for(Visit__c vs : [SELECT id,Name,Geo_Location__Latitude__s,Geo_Location__Longitude__s,AccountAddress__c,Account__r.Geo_Location__Latitude__s,Account__r.Geo_Location__Longitude__s FROM  Visit__c WHERE ID IN:vsRecIdList]){
            System.debug('vs === >'+vs.Account__r.Geo_Location__Latitude__s);
            // if(vs.AccountAddress__c != null){
            if( vs.Account__r.Geo_Location__Latitude__s !=null){
                vs.Geo_Location__Latitude__s = vs.Account__r.Geo_Location__Latitude__s;
            }
            if( vs.Account__r.Geo_Location__Longitude__s !=null){
                vs.Geo_Location__Longitude__s = vs.Account__r.Geo_Location__Longitude__s;   
            }
            vsListToUpdate.add(vs);
            // GeocodingService.getCoordinates(vs.AccountAddress__c).get('latitude');
            // vs.Geo_Location__Longitude__s = vs.Account__r.Geo_Location__Longitude__s;      //  GeocodingService.getCoordinates(vs.AccountAddress__c).get('longitude');
            // }
        }
        if(vsListToUpdate.size()>0){
            update vsListToUpdate;
        }
    }
}