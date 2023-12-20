import { LightningElement,api,track,wire } from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';
import apexMethodName from '@salesforce/apex/CreateLeadViaQRCodeHelper.clonedOpp';
export default class StanleyReplacement extends LightningElement {
    @api recordId; // 
    formInput = {};
    @track checked = true;
    cloneOpportunity() {
        // Fetch the Opportunity record data
        debugger;
        apexMethodName({ recordId:this.recordId})
            .then(result => {
                alert('Success');
                this.dispatchEvent(new CloseActionScreenEvent());
            })
            .catch(error => {
                // Handle error, e.g., show an error message
                console.error('Error fetching Opportunity data:', error.body.message);
            });
    }

   
    changeToggle(event){
        this.checked = !this.checked;
    }
}