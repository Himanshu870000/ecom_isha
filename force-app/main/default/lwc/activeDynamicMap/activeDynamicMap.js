import { LightningElement, track, wire, api } from 'lwc';
import activeDropColor from '@salesforce/label/c.Active';
import getMapMarkerRecords from "@salesforce/apex/DynamicMapLWCController.getMapMarkerRecords";

export default class ActiveDynamicMap extends LightningElement {

    @api queryString =
    "SELECT Id, Name, Status__c, BillingLatitude, BillingLongitude FROM Account WHERE BillingLatitude != null AND Status__c = 'Active' LIMIT 10";
  @api latitudeFieldAPI = "BillingLatitude";
  @api longitudeFieldAPI = "BillingLongitude";
  @api icon = "standard:account";
  @api titleFieldAPI = "Name";
  @api status = "Status__c";
  @track value = 'India';
  zoomLevel = 4;
  listview = "visible";
  
  get options() {
    return [
            { label: 'USA', value: 'USA' },
            { label: 'India', value: 'India' },
            { label: 'China', value: 'China' },
          ];
  }

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
            this.center.location.Latitude = "20.5937";
            this.center.location.Longitude = "78.9629";
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
                        fillColor: activeDropColor,
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

  handleChange(event) {
    debugger;
      this.value = event.detail.value;
      if(this.value === "USA"){
          let markers = [];
          //this.center.location.Latitude = "37.0902";
          //this.center.location.Longitude = "95.7129";
          markers.push({
              location: {       
                 Latitude: '37.790197',
                Longitude: '-122.396879',
              }
          });
          console.log(markers);
          this.mapMarkers = markers;
        }
  }

  @track mapMarkers = [
    {
      location: {
        Latitude: "37.0902",
        Longitude: "95.7129"
      },
      icon: "standard:account",
      title: "All Accounts"
    }
  ];

  center = {
    location: {
      Latitude: "20.5937",
      Longitude: "78.9629"
    }
  };

}