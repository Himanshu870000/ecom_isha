import { LightningElement, track, wire, api } from 'lwc';
import newDropColor from '@salesforce/label/c.New_Status';
import getMapMarkerRecords from "@salesforce/apex/DynamicMapLWCController.getMapMarkerRecords";

export default class NewDynamicMap extends LightningElement {
    @api queryString =
    "SELECT Id, Name, Status__c, BillingLatitude, BillingLongitude FROM Account WHERE BillingLatitude != null AND Status__c = 'New'";
  @api latitudeFieldAPI = "BillingLatitude";
  @api longitudeFieldAPI = "BillingLongitude";
  @api icon = "standard:account";
  @api titleFieldAPI = "Name";
  @api status = "Status__c";

  zoomLevel = 15;
  listview = "visible";

  connectedCallback() {
    debugger;
    if (this.queryString) {
      getMapMarkerRecords({
        query: this.queryString,
        latitudeField: this.latitudeFieldAPI,
        longitudeField: this.longitudeFieldAPI
      })
        .then((result) => {
          if (result && result.length > 0) {
            let markers = [];
            this.center.location.Latitude = result[0][this.latitudeFieldAPI];
            this.center.location.Longitude = result[0][this.longitudeFieldAPI];
            result.forEach((record) => {
            
              markers.push({
                  location: {
                    Latitude: record[this.latitudeFieldAPI],
                    Longitude: record[this.longitudeFieldAPI]
                  },
                  title: record[this.titleFieldAPI],
                  icon: this.icon,
                    mapIcon : {
                        path: 'M 0,0 C -2,-20 -10,-22 -10,-30 A 10,10 0 1,1 10,-30 C 10,-22 2,-20 0,0 z',
                        fillColor: newDropColor,
                        fillOpacity: 1,
                        strokeColor: '#000',
                        strokeWeight: 1,
                        scale: 1
                    }
                });
            });
            console.log(markers);
            this.mapMarkers = markers;
          }
        })
        .catch((error) => {
          this.error = error;
        });
    }
  }

  @track mapMarkers = [
    {
      location: {
        Latitude: "21.7679° N",
        Longitude: "78.8718° E"
      },
      icon: "standard:account",
      title: "All Accounts"
    }
  ];

  center = {
    location: {
      Latitude: "21.7679° N",
      Longitude: "78.8718° E"
    }
  };
}