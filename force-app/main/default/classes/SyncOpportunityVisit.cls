public class SyncOpportunityVisit {
	
    public static void syncVisit(List<Opportunity> oppList,String type){
    	List<VisitWrapper> visitList = new List<VisitWrapper>();
        
        for(Opportunity opp : oppList){
           	VisitWrapper visit = new VisitWrapper();
            visit.email = opp.Delivery_Agent__r.Email;
            visit.oppId = opp.Id;
            visit.sDate = String.valueOf(opp.CloseDate);
            visit.name = opp.Name;
            visit.type = type;
            visit.street = opp.Account.ShippingStreet;
            visit.city = opp.Account.ShippingCity;
            visit.state = opp.Account.ShippingState;
            visit.country = opp.Account.ShippingCountry;
            visit.status = 'New';
            visit.phone = opp.Delivery_Agent__r.Phone;
            visit.distance = getDistance(opp.Account.Geo_Location__Latitude__s,opp.Account.Geo_Location__Longitude__s,opp.Franchise_Associated_To__r.Geo_Location__Latitude__s,opp.Franchise_Associated_To__r.Geo_Location__Longitude__s) + ' KM Away';
            visit.destinationLat = String.valueOf(opp.Account.Geo_Location__Latitude__s);
            visit.destinationLong = String.valueOf(opp.Account.Geo_Location__Longitude__s);
            
           visitList.add(visit);
        }
        
        
        String reqBody = JSON.serialize(visitList);
        reqBody = reqBody.replace('sDate', 'date');
        
        System.debug('Request Body----'+reqBody);
        
        String endpoint = 'https://fieldvisit-7wth.onrender.com/api/myVisit';
        
        HttpRequest req = new HttpRequest();
        req.setHeader('Accept', 'application/json');
        req.setMethod('POST');
        req.setEndpoint(endpoint);
        req.setHeader('Content-type', 'application/json');
        req.setBody(reqBody);
        Http http = new Http();
        HttpResponse res = http.send(req);
        
        System.debug('Response----'+res.getBody());
    }
    
    public static String getDistance(Decimal sLat, Decimal sLong, Decimal dLat, Decimal dLong){
        Location loc1 = Location.newInstance(sLat,sLong);
        Location loc2 = Location.newInstance(dLat,dLong);
        Decimal dist = Location.getDistance(loc1, loc2, 'km');
        Double amount = dist.setScale(2);
        return String.valueOf(amount);
    }
    
    public class VisitWrapper{
        public String email;
        public String oppId;
        public String sDate;
        public String name;
        public String street;
        public String city;
        public String state;
        public String country;
        public String status;
        public String phone;
        public String type;
        public String distance;
        public String destinationLat;
        public String destinationLong;
    }
}