public class propertyMgtController {
    
    @auraenabled
    public Static List<Property_Block__c> getavailableHostelRooms(String roomType,String studentId,String sharingType,String acNeeded){
        system.debug('roomType=====>'+roomType+'studentId=====>'+studentId+'sharingType=====>'+sharingType+'acNeeded=====>'+acNeeded);
        Boolean acRequired = acNeeded == 'Yes' ? True : False;
        List<Property_Block__c> HostelBlockList = [SELECT Id,Block__c,Name FROM Property_Block__c];
        return HostelBlockList;
    }
    @auraenabled
    public Static List<Property_Tower__c> getavailableTowers(String BlockId){
        List<Property_Tower__c> HostelTowerList = [SELECT Id,Name FROM Property_Tower__c where Property_Block__c = :BlockId order by name];
        return HostelTowerList;
        
    }
    @auraenabled
    public Static List<Property_Floor__c> getavailableFloors(String TowerId){
        List<Property_Floor__c > HostelFloorList = [SELECT Id,Name FROM Property_Floor__c WHERE Property_Tower__c = :TowerId order by name];
        return HostelFloorList;
    }
    @auraenabled
    public Static List<Property_Room__c> getavailableRooms(String FloorId){
        List<Property_Room__c > HostelFloorList = [SELECT Id,Name FROM Property_Room__c WHERE Property_Floor__c = :FloorId order by name];
        return HostelFloorList;
    }
    @auraenabled
    public Static String bookavailableRooms(String studentId,String roomId){
        String message = '';
        List<Property_Booking__c> ExistingBooking = [SELECT Id , Name FROM Property_Booking__c where Deal__c = :studentId];
        if(ExistingBooking.size() > 0){
            message = 'Sorry but You have already booked a room.';
        }else{
            Property_Booking__c hb = new Property_Booking__c();
            hb.Deal__c = 'aAI5f000000tSNaGAM';//studentId;
            hb.Deal__c = studentId;
            hb.Property_Room__c = roomId;
            insert hb;
            message = 'Conrgatulations Room Has been Succesfully Blocked.';
        }
        return message;
    }
    
}