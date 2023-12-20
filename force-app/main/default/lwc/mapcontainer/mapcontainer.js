import { LightningElement,api,track } from 'lwc';
import getAccountDetails from '@salesforce/apex/MapcontainerController.getAccountDetails';
import GoogleMapReverseGeocodeCallout from '@salesforce/apex/MapcontainerController.GoogleMapReverseGeocodeCallout';
import baseURL from '@salesforce/label/c.orgBaseURLforVFPages';
export default class Mapcontainer extends LightningElement {
    debugger;
 @api recordId;
  @track accData;
   billingStreet = '';
   currentLocation = '';
   dataArray = {
       'accAddress' : '',
       'currentAddress': ''
   }
    vfHost = baseURL + 'apex/GoogleMapIframe';
    origin = baseURL;
    currentAddress = '';
    connectedCallback(){
        debugger;
        setTimeout(() => {
           this.getLocationDetails();
           // this.sendData();
        }, 2000);
      this.sendData();
    }


// function one(){
//     console.log(1);
// }
// function two(callback){
//     setTimeout(()=>{
//         console.log(2);
//     },2000);
//     callback();
// }
// two(one);


getLocationDetails(){
    debugger;
 if (navigator.geolocation) {
            navigator.geolocation.getCurrentPosition(position => {
                // Get the Latitude and Longitude from Geolocation API
                var latitude = position.coords.latitude;
                var longitude = position.coords.longitude;
                 GoogleMapReverseGeocodeCallout({lat : latitude,lng: longitude})
                .then(result =>{
                   if(result){
                       this.currentAddress = result;
                       this.sendData();
                   }
                })
                .catch(error =>{
          console.log("ERROR")
       })
      });
        }
    }

     sendData(){ 
      debugger;
       getAccountDetails({ recordId : this.recordId })
       .then(result =>{
        this.accData = result;
        this.billingStreet = result.BillingStreet;
        this.dataArray.accAddress = this.billingStreet;
        this.dataArray.currentAddress = this.currentAddress;
        
        this.template.querySelector('iframe').contentWindow.postMessage(this.dataArray, this.origin);
       })
       .catch(error =>{
          console.log("ERROR")
       })
 }
}