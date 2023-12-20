@RestResource(urlMapping='/create_opp')
global without sharing class WebToOpportunityService {
	@HttpPost
    global static void createOpportunity(){
        RestRequest req = RestContext.request;
        Blob body = req.requestBody;
        String requestString = body.toString();
        system.debug('requestString===>'+requestString);
            
        OppWrapper wrapper = (OppWrapper) JSON.deserialize(requestString,OppWrapper.class);
        
        try{
        	List<Account> accounts = [Select Id,Name From Account Where Email__c=:wrapper.email limit 1];
            Account acc;
            if(accounts.isEmpty()){
                 acc = createAccount(wrapper);
            }else{
                acc = accounts[0];
            }
            createOpportunity(wrapper,acc);
            
            String responseBody = JSON.serialize(new APIResponseWrapper('Success', 'Submitted successfully!'));
            RestContext.response.statusCode = 200;
            RestContext.response.responseBody = Blob.valueOf(responseBody);
        }catch(Exception e){
            System.debug('Exception----'+e.getMessage());
            String responseBody = JSON.serialize(new APIResponseWrapper('Failure', 'Submition went fail!'));
            RestContext.response.statusCode = 400;
            RestContext.response.responseBody = Blob.valueOf(responseBody);
        }
    }
    
    global static Account createAccount(OppWrapper wrapper){
        Account acc = new Account();
        acc.Name = wrapper.name;
        acc.Email__c = wrapper.email;
        acc.Phone = wrapper.phone;
        acc.ShippingState = wrapper.state;
        acc.ShippingCity = wrapper.city;
        acc.ShippingCountry = wrapper.country;
        acc.ShippingPostalCode = wrapper.pinCode;
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        
        acc.Geo_Location__Latitude__s = Double.valueOf(wrapper.lat);
        acc.Geo_Location__Longitude__s = Double.valueOf(wrapper.longitude);
        insert acc;
        return acc;
    }
    
    global static Opportunity createOpportunity(OppWrapper wrapper, Account acc){
        List<Coupon__c> c = [Select Id From Coupon__c Where Name =:wrapper.coupon];
        
        Opportunity opp = new Opportunity();
        
        opp.Name = acc.Name+'_opportunity';
        opp.AccountId = acc.Id;
        
        opp.CloseDate = System.today();
        opp.StageName = 'Awaiting Pickup';
        opp.Quantity__c = Double.valueOf(wrapper.quantity);
        
        if(!c.isEmpty()){
        	opp.Coupon__c = c[0].Id;    
        }
        
        opp.ForecastCategoryName = 'Pipeline';
        opp.Quantity_unit__c = 'KG';
        opp.Opportunity_Type__c = wrapper.service;
        opp.Pickup_DateTime__c = DateTime.parse(wrapper.pickupDateTime);
        insert opp;
        return opp;
    }
    
    global class OppWrapper{
        public String name;
        public String phone;
        public String email;
        public String state;
        public String city;
        public String country;
        public String pinCode;
        public String service;
        public String pickupDateTime;
        public String lat;
        public String longitude;
        public String quantity;
        public String coupon;
    }
    
     global class APIResponseWrapper{
        public String message;
        public String status;

        global APIResponseWrapper(String status, String message) {
            this.status = status;
            this.message = message;
        }
    }
}