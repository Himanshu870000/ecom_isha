public class GeocodingService {

    private static final String API_KEY = 'AIzaSyB4SPqkO0ZQbxT-EU4l886H9Y3ipf1NMW0';

    public static Map<String, Decimal> getCoordinates(String address) {
        // Encode the address to be included in the API request
        String encodedAddress = EncodingUtil.urlEncode(address, 'UTF-8');

        // Create the API request URL
        String apiUrl = 'https://maps.googleapis.com/maps/api/geocode/json?address=' + encodedAddress + '&key=' + API_KEY;

        // Make the HTTP request to the API
        HttpRequest request = new HttpRequest();
        request.setEndpoint(apiUrl);
        request.setMethod('GET');

        Http http = new Http();
        HttpResponse response = http.send(request);

        // Parse the JSON response
        Map<String, Decimal> coordinates = new Map<String, Decimal>();
        if (response.getStatusCode() == 200) {
            Map<String, Object> jsonResponse = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());

            if ('OK'.equals(jsonResponse.get('status'))) {
                List<Object> results = (List<Object>)jsonResponse.get('results');
                if (!results.isEmpty()) {
                    Map<String, Object> geometry = (Map<String, Object>)((Map<String, Object>)results[0]).get('geometry');
                    Map<String, Object> location = (Map<String, Object>)geometry.get('location');
                    coordinates.put('latitude', (Decimal)location.get('lat'));
                    coordinates.put('longitude', (Decimal)location.get('lng'));
                }
            }
        }
		System.debug('coordinates  ==> ' + coordinates);
        return coordinates;
    }
}