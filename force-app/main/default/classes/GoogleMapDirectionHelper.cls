public with sharing class GoogleMapDirectionHelper {
    
    @AuraEnabled
    public static VisitWrpper GetVisitdetails(String AccrecordId){
        VisitWrpper visitwrap = new VisitWrpper();

        try {
            String Destlatitude;
            String Destlongitude;
            String CurrentUserRecId = userInfo.getUserId();
            System.debug('CurrentUserRecId ====> ' + CurrentUserRecId);
            /*List<visit__c> visitrecord = [SELECT Account__c,Actual_visit_date__c,CheckIn__Latitude__s,CheckIn__Longitude__s,Check_Out__Latitude__s,Check_Out__Longitude__s,Geo_Location__c,Geo_Location__Latitude__s,Geo_Location__Longitude__s,Planned_visit_date__c 
                                            FROM Visit__c where Account__c=:AccrecordId And Actual_visit_date__c = TODAY order by createdDate LIMIT 1];
            System.debug('visitrecord ====> ' + visitrecord);
            visitwrap.CurrentVisitRec = visitrecord[0];*/

            Account acc = [SELECT Id,Name,Geo_Location__Latitude__s,Geo_Location__Longitude__s,BillingStreet,BillingCity,BillingState,BillingPostalCode,BillingCountry 
                            FROM Account
                            Where Id =: AccrecordId];
                            
            String address = acc.BillingStreet + ', '+acc.BillingCity+ ', '+acc.BillingState+ ', '+acc.BillingPostalCode + ', '+acc.BillingCountry;

            Map<String, String> GoogleLatlongMap = getLongandLat(address);
            //Map<String, Decimal[]> addressToLatLngMap = getLatLngByAddress(addresses);
            
            if (GoogleLatlongMap.containsKey('lat')) {

                Destlatitude = GoogleLatlongMap.get('lat');
                visitwrap.destLat = Destlatitude;

            }
            if (GoogleLatlongMap.containsKey('lang')) {

                Destlongitude = GoogleLatlongMap.get('lang');
                visitwrap.destLong = Destlongitude;
            }

            List<Day_Visit_Plan__c> dayvisitPlanList = [SELECT CreatedDate,End_Location__c,End_Location__Latitude__s,End_Location__Longitude__s,Id,Monthly_Travel_Expense__c,Name,Service_Executive__c,Start_Day__c,Start_Location__c,Start_Location__Latitude__s,Start_Location__Longitude__s,Total_Covered_Distance__c,Total_Distance__c FROM Day_Visit_Plan__c
                                    Where Service_Executive__c =:CurrentUserRecId AND CreatedDate = TODAY order by createdDate LIMIT 1];

            if (dayvisitPlanList.size() >0) {
                visitwrap.DayvisitPlanRec = dayvisitPlanList[0];
            }
            

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return visitwrap;
    }

    /*public static Map<String, Decimal[]> getLatLngByAddress(List<String> addresses) {
        Map<String, Decimal[]> addressToLatLngMap = new Map<String, Decimal[]>();
        
        for (String address : addresses) {
            String formattedAddress = address.replace(' ', '+');
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            String apiKey = ''; //YOUR_GOOGLE_MAPS_API_KEY
            String url = 'https://maps.googleapis.com/maps/api/geocode/json?address=' + formattedAddress + '&key=' + apiKey;
            
            request.setEndpoint(url);
            request.setMethod('GET');
            
            HttpResponse response = http.send(request);
            if (response.getStatusCode() == 200) {
                Map<String, Object> jsonResponse = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                if (jsonResponse.containsKey('results')) {
                    List<Object> results = (List<Object>) jsonResponse.get('results');
                    if (!results.isEmpty()) {
                        Map<String, Object> location = (Map<String, Object>) ((Map<String, Object>) results[0]).get('geometry');
                        Map<String, Decimal> latLng = (Map<String, Decimal>) location.get('location');
                        Decimal latitude = latLng.get('lat');
                        Decimal longitude = latLng.get('lng');
                        addressToLatLngMap.put(address, new Decimal[]{ latitude, longitude });
                    }
                }
            }
        }
        
        return addressToLatLngMap;
    }*/

    public class VisitWrpper{
        //public visit__c CurrentVisitRec;
        @auraEnabled
        public Day_Visit_Plan__c DayvisitPlanRec;
        @auraEnabled
        public String destLat;
        @auraEnabled
        public string destLong;
    }

    @auraenabled
    public Static Map<String,String> getLongandLat(String Addresss){
        if(!String.isBlank(Addresss)){
            Map<String,String> responseMap = new Map<String,String>();
            String apikey = Label.GoogleApiKey;	 
            String baseURL = Label.GooglemapBaseURL; 
            
            String encodedAddresss = EncodingUtil.urlEncode(Addresss, 'UTF-8');
            String url = baseURL+encodedAddresss+'&key='+apikey;
            System.debug('encoded url ::'+url);
            Http ht =new Http();
            HttpRequest req = new HttpRequest();
            req.setEndpoint(url);
            req.setMethod('POST');
            req.setHeader('Content-Length', '0');
            HttpResponse res = ht.send(req);
            String response = (res.getBody());
            System.debug('response ::'+response);
            
            //locationparser parsedJson = JSON.deserialize(res.getBody(), LocationParser.Class);
            //system.debug('parsedJson ====> ' + parsedJson);
            
            LocationParser parsedJson = LocationParser.parse(res.getBody());
            system.debug('parsedJson ====> ' + parsedJson);
            system.debug('parsedJson results ====> ' + parsedJson.results);
            
            LocationParser.Results parserResult = parsedJson.results[0];
            LocationParser.Geometry parserGeometry = parserResult.geometry;
            LocationParser.Location parserLocation = parserGeometry.location;
            Double lat = parserLocation.lat;
            Double lang = parserLocation.lng;
            
            responseMap.put('lat',String.valueOf(lat));
            responseMap.put('lang',String.valueOf(lang));
            
            System.debug('responseMap---'+String.valueOf(responseMap));
            
            return responseMap;
        }
        return null;
    }
}