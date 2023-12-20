import { LightningElement, wire, api, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { encodeDefaultFieldValues } from 'lightning/pageReferenceUtils';
import getFieldFromFieldSet from '@salesforce/apex/GetFieldSet.getFieldFromFieldSet';

export default class RenewOpp extends NavigationMixin(LightningElement) {
    @api recordId;
    @track result;

    @wire(getFieldFromFieldSet, { oppId: '$recordId' })
    getOppRecords({ error, data }) {
        if (data != null) {
            console.log('Data',data);
            let d = {...data};
            d.Parent_Oppotunity__c = this.recordId;
            this.navigateToNewContactWithDefaults(d);
        } else {
        console.log('The Error --> ' + error);
        }
    }

    navigateToNewContactWithDefaults(datJSON) {
        // debugger;
         const defaultValues = encodeDefaultFieldValues(datJSON);
         this[NavigationMixin.Navigate]({
             type: 'standard__objectPage',
             attributes: {
                 objectApiName: 'Opportunity',
                 actionName: 'new'
             },
             state: {
                 defaultFieldValues: defaultValues
             }
         });
     }
}