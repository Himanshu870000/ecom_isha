<script>

const addressFields = [
"tfa_alias", // Street Address Field ID
"tfa_alias", // City/State Field ID
"tfa_alias", // Zip Code Field ID
]

const outputFields = {
  lat: "tfa_alias", // Latitude Field ID
  lng: "tfa_alias"  // Longitude Field ID
}

// Google Maps API Endpoint
const baseUrl = 'https://maps.googleapis.com/maps/api/geocode/json?address=';
// Your Google Maps API Key
const apiKey = 'AIzaSyB4SPqkO0ZQbxT-EU4l886H9Y3ipf1NMW0';

// Get the Lat/Lng Values
function updateGeolocation() {

  // Generates request URL
  const requestURL = addressFields.map(function (item) {
    // Get value of field
    const val = document.getElementById(item).value;

    // Replace spaces with +, for Google Maps API
    return val.split(' ').join('+')
  });

  const finalUrl = baseUrl + requestURL.join(',') + '&key=' + apiKey;

  fetch(finalUrl)
  .then(response => response.json())
  .then(data => {
    const latLng = (data.results[0].geometry.location);
    document.getElementById(outputFields.lat).value = latLng.lat
      document.getElementById(outputFields.lng).value = latLng.lng
  });
}

document.addEventListener("DOMContentLoaded", function(event) {
    addressFields.forEach( (element) => 
    {
      let input = document.getElementById(element);
      input.addEventListener('change', updateGeolocation)
    });
  });

</script>