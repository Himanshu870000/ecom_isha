import { LightningElement, wire, api, track } from 'lwc';
import GetLeadandChildDetails from '@salesforce/apex/StudentProfileCardController.GetLeadandChildDetails';

export default class StudentProfileCard extends LightningElement {
@api recordId;
LeadRec;

@wire(GetLeadandChildDetails, { LeadId: '$recordId' }) 
wiredLead ({ error, data }) {
    debugger;
       if (data) {
           this.LeadRec = data; 
      } else if (error) { 
          this.error = error;  
     }   }
    
}