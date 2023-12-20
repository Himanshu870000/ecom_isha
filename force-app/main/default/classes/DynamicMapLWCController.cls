public without sharing class DynamicMapLWCController {
    
    @AuraEnabled
    public static List<SObject> getMapMarkerRecords(String query, String latitudeField, String longitudeField) {
        if(String.isBlank(query) || String.isBlank(latitudeField) || String.isBlank(longitudeField)) {
            System.debug('--- invalid query');
            return null;
        }
        return Database.query(query);
    }
}