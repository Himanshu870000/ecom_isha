/**
* @author [Dinesh B]
* @email dinesh.b@utilitarianLab.com
* @create date 2023-03-20 18:27:29
* @modify date 2023-03-20 18:27:29
* @desc [description]
*/

public class VisitSchedulerController {
    
    @RemoteAction
    public static Map<String,Object> fetchPageData() {
        try {
            Map<String, Object> pageData = new Map<String,Object>();
            pageData.put('salesRepList', [SELECT Id, FirstName, LastName, UserName FROM User]);
            system.debug('--- pageData '+ pageData);
            return pageData;
        } catch (Exception e) {
            printError(e);
        }
        return null;
    }
    
    // SELECT Id,Name,Assignment_Group__r.Name,Group_Member__r.Name FROM Assignment_Group_Member__c
    @RemoteAction
    public Static List<User> fetchGroupmemeber(String AssignementGropLocation){
        System.debug('AssignementGropLocation :'+AssignementGropLocation);
        try{
            List<User> getUserList = new List<User>();
            
            List<Assignment_Group_Member__c> getGMemList = [SELECT Id,Name,Assignment_Group__r.Name,Group_Member__r.Name FROM Assignment_Group_Member__c WHERE Assignment_Group__r.Name =: AssignementGropLocation];
            Set<String> gorupNameSet = new Set<String>();
            for(Assignment_Group_Member__c agm : getGMemList){
                gorupNameSet.add(agm.Group_Member__r.Name);
            }
            System.debug('gorupNameSet ->>>>>'+gorupNameSet);
            List<User> userList = [SELECT Id, FirstName, LastName, UserName FROM User WHERE Name IN: gorupNameSet];
            for(User use : userList){
                System.debug('use == >'+use);
                getUserList.add(use);
            }
            // getUserList.add( userList);
            System.debug('getUserList ::'+getUserList);
            return getUserList;
        }catch(Exception e){
            System.debug('The Error '+e.getMessage());
            System.debug('Erron Line '+e.getLineNumber());
        }
        return null;
    }
    
    // Showing Lead & Account in dropdown
    @RemoteAction
    public Static List<String> getAccountleadList(){
        
        return new List<String>{'Account','Lead'};
            }
    
    // Show Selected Location Record
    @RemoteAction
    public Static list<Location__c> getAllLocationRecords(){
        List<Location__c> getLocationList = [SELECT Id,Name FROM Location__c];
        System.debug('Location Record :'+getLocationList);
        return getLocationList;
    }
    
    // Show Record of Lead Based on Object & Location
    @RemoteAction
    public Static List<Lead> getSelectedObjectRecord(String objectName, String location){
        List<Lead> ledList = new List<Lead>();
        if(objectName == 'Lead'){
            ledList =[ SELECT Id,Name,Location__c FROM Lead Where   Location__c =: location];
        }
        System.debug('ledList Size ::'+ledList.Size()); 
        System.debug('ledList Record ::'+ledList);
        
        // if(objectName == 'Account'){
        //     System.debug('Account Method called');
        //     VisitSchedulerController.getSelectedAccountRecords(objectName,location); 
        // }
        return ledList;
    }
    
    // Show Record of Account Based on Object & Location
    @RemoteAction
    public Static List<Account> getSelectedAccountRecords(String objectName, string location){
        System.debug('location ::'+location);
        List<Account> accList = new List<Account>();
        if(objectName == 'Account'){
            accList= [SELECT Id,Name,Location__r.Name FROM Account WHERE Location__r.Name =:  location];
            System.debug('Account size :'+accList.size());
            System.debug('Account Record :'+accList);
        }
        return accList;
    }
    
    @RemoteAction
    public static String createVisits(List<Visit__c> visitList) {
        try{
            System.debug('--- visitList '+visitList);
            upsert visitList;
            return 'visits created successfully.';
        }catch(Exception e){
            printError(e);
        }
        return 'something went wrong.';
    }
    
    @RemoteAction
    public static Map<String,Object> getUserVisits(String userId) {
        Map<String, Object> pageData = new Map<String,Object>();
        if(!String.isBlank(userId)) {
            pageData.put('accountList', [SELECT Id,Name FROM Account WHERE OwnerId = :userId LIMIT 15]);//Parent_Visit__c
            pageData.put('visitList', [Select Id, Name, Account__c, Account__r.Name, Planned_visit_date__c, CheckIn__c, Check_Out__c FROM Visit__c WHERE Account__c != null AND Assigned_User__c = :userId AND Actual_Visit_Date__c = null]);
        }
        System.debug('User Data ::'+pageData);
        return pageData;
    }
    
    @RemoteAction
    public static void deleteEvent(String eventID) {
        if(!String.isBlank(eventID))
            delete new Visit__c(Id = eventID);
    }
    
    // Get Search Result as Account
    @RemoteAction
    public static List<Account> getRepAccounts(String repId, String location) {
        List<Account> accList = new List<Account>();
        System.debug('repId ::'+repId);
        //System.debug('searchString ::'+searchString);
        //  String searchPattern = '%'+String.escapeSingleQuotes(searchString)+'%';
        accList = [SELECT Id, Name,Location__r.Name,owner.name FROM Account WHERE owner.name = :repId AND  Location__r.Name =: location AND owner.name !='jain'  LIMIT 15];
        System.debug('accList ::'+accList);
        return accList;
    }
    
    // Get Search Result as Lead
    @RemoteAction
    public Static List<Lead> getRepLeads(String repId,  String location){
        System.debug('repId ::'+repId);
        
        System.debug('location ::'+location);
        List<Lead> ledList = new List<Lead>();
        
        ledList = [SELECT Id,Name,Location__c,owner.LastName FROM Lead WHERE owner.LastName =: repId AND Location__c =:location  LIMIT 10];
        System.debug('leadList ::'+ledList);
        return ledList;
    }
    
    
    // Creare Visit Record on Account & Lead Drag
    @RemoteAction
    public Static String createVisitObjectType(Id SobjectId, String AssignedUserId, string datestring, String geolatitude, String geolongitude){
        
        System.debug('datestring =====> ' + datestring);
        System.debug('SobjectId :'+SobjectId);
        String sObjName = SobjectId.getSObjectType().getDescribe().getName();
        System.debug('Object Name ::'+sObjName);
        if(sObjName == 'Lead'){
            Visit__c vs = new Visit__c();
            vs.Lead__c = SobjectId;
            vs.Assigned_User__c = AssignedUserId;
            vs.Planned_visit_date__c = Date.valueOf(datestring);
            // vs.Geolocation__Latitude__s = Decimal.valueOf(geolatitude);
            vs.Geo_Location__Latitude__s = Decimal.valueOf(geolatitude);
            vs.Geo_Location__Longitude__s =  Decimal.valueOf(geolongitude);
            insert vs;
            System.debug('Visit Record  for Lead ::'+vs);
            
        }else if(sObjName == 'Account'){
            Visit__c vs = new Visit__c();
            vs.Account__c = SobjectId;
            vs.Assigned_User__c = AssignedUserId;
            vs.Planned_visit_date__c = Date.valueOf(datestring);
            vs.Geo_Location__Latitude__s = Decimal.valueOf(geolatitude);
            vs.Geo_Location__Longitude__s =  Decimal.valueOf(geolongitude);
            insert vs;
            System.debug('Visit Record  for Account ::'+vs);
        }       
        return 'SUCCESS';
    }
    
    
    static void printError(Exception e) {
        System.debug('--- ErrorMsg :'+e.getMessage());
        System.debug('--- ErrorLineNo :'+e.getMessage());
    }
    
    
    @RemoteAction
    public static Sobject getleadGeolocation(String recordId){
        if(!String.isBlank(recordId)){
            Id myId = Id.valueOf(recordId);
            String sObjName = myId.getSObjectType().getDescribe().getName();
            if(sObjName == 'Lead'){
                System.debug('Lead Found');
                Lead led = [SELECT Id,Name,Geolocation__Latitude__s,Geolocation__Longitude__s FROM Lead WHERE Id =: recordId];
                System.debug('Lead Record :::'+led);
                return led;
            }else if(sObjName == 'Account'){
                System.debug('Account Found'); 
                Account acc = [SELECT Id,Name,Geo_Location__Latitude__s,Geo_Location__Longitude__s FROM Account WHERE Id =: recordId];
                System.debug('Account Record :::'+acc);
                return acc;
            }
            return null;
            
        }else{
            return null;
        }
    }
    
    @future (callout= true)
    public static void updateLeadGeoLocation(Set<Id> ledIdSet){
        System.debug('ledIdSet :::'+ledIdSet);
        List<lead> ledListToUpdate = [SELECT Id,Name,Street__c,City__c,State_Province__c,Postal_Code__c,Country__c FROM Lead WHERE ID IN:ledIdSet];
        
        for(Lead led : ledListToUpdate){
            if(!String.isBlank(led.Street__c) && !String.isBlank(led.City__c) && !String.isBlank(led.State_Province__c) && !String.isBlank(led.Postal_Code__c) && !String.isBlank(led.Country__c)){
                String address = led.Street__c + ', '+led.City__c+ ', '+led.State_Province__c+ ', '+ led.Postal_Code__c + ', '+led.Country__c;
                System.debug('Lead Address :: '+address);
                Map<String,String> geoResponseMap = VisitSchedulerController.getLongandLat(address);
                Double lat = Double.valueOf(geoResponseMap.get('lat'));
                Double lang = Double.valueOf(geoResponseMap.get('lang'));
                led.Geolocation__Latitude__s = lat;
                led.Geolocation__Longitude__s = lang;
            }
        }
        
        update ledListToUpdate;
        System.debug('Updated GeoLocation '+ledListToUpdate);
        //  return ledLIst;
    }
    
    // 
    public Static Map<String,String> getLongandLat(String Addresss){
        System.debug('Addresss :::'+Addresss);
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
    
    
    //Shiva --------------------------------------------------------------------
    
    @RemoteAction
    Public static List<Route__c> showRoutes(){
        List<Route__c> routes =[SELECT id,Name,Sales_User__c,Route_Name_del__c,Predefined_Area__c FROM Route__c ];
        system.debug('routes-------------->'+routes);
        return routes;
    }
    
    @RemoteAction
    Public Static List<Monthly_Beat_Plan__c> BearPlannerOfMonth(){
        // Get the current date and time
        Datetime now = Datetime.now();
        // Extract month name
        String monthName = now.format('MMMM');
        // Extract year
        Integer year = now.year();
        // Extract date
        Integer day = now.day();
        System.debug('Month Name: ' + monthName);
        System.debug('Year: ' + year);
        System.debug('Date: ' + day);
        
        List<Monthly_Beat_Plan__c> MBPlist=[SELECT id,Year__c,Status__c,Start_Date__c,OwnerId,Sales_User__c,Name,Month__c,End_Date__c,(SELECT id,Year__c,Name,Week_Identifier__c,Start_Day_of_Week__c,End_Day_of_Week__c,OwnerId,Monthly_Beat_Plan__c FROM Weekly_Beat_Plans__r) FROM Monthly_Beat_Plan__c];
        system.debug('Monthly_Beat_Plan__c---------->'+MBPlist);
        
        set<id> weeklpmasId = new 	set<id>();
        for(Monthly_Beat_Plan__c mp:MBPlist){
            List<Weekly_Beat_Plan__c> newWPlIST =  mp.Weekly_Beat_Plans__r;
            for(Weekly_Beat_Plan__c wk :newWPlIST){
                weeklpmasId.add(wk.id);
            }  
        }
        
        List<Visit__c> getAllvisitRecordList = [Select Id,KPI_Target__r.Name,Account__c,Account__r.Name,Lead__c,Lead__r.Name,Start_Date_Time__c,Route__c,Route__r.Name,Visit_Status__c From Visit__c Where KPI_Target__c !=null AND Weekly_Beat_Plan__c IN:weeklpmasId];
        system.debug('getAllvisitRecordList-----------'+getAllvisitRecordList);
        return MBPlist;
        
        
        
        
    }
    
    
    
    
    
}