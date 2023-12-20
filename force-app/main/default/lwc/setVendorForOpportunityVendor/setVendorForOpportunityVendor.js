import { LightningElement,api,wire,track } from 'lwc';
import GetSuppliers from '@salesforce/apex/GetSupplierDetails.GetSuppliers';
import OpportunityProductStVendor from '@salesforce/apex/GetSupplierDetails.OpportunityProductStVendor';
import { CloseActionScreenEvent } from 'lightning/actions';
export default class SetVendorForOpportunityVendor extends LightningElement {

    @api recordId;
    @track record;
    @track error;
    @wire(GetSuppliers, { OppProductId: '$recordId'})
    wiredAccount({ error, data }) {
        if (data) {
            this.record = data;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.record = undefined;
        }
    }
    
    @track selectedRecords=[];
    changeHandler(event){

    const recordId = event.target.dataset.id;
                const recId = event.target.dataset.id;
        if (event.target.checked){
            for (let i = 0; i < this.record.length; i++) {
                if (this.record[i].Id == recId ) {
                    this.record[i].checkedvalue = true;
                    this.selectedRecords.push(this.data[i]);
                }
                else{
                    this.record[i].checkedvalue = false;
                    // if (this.selectedRecords.length >0) {
                        var recordfound = this.selectedRecords.find(record => record.Id === this.data[i].Id);
                        console.log('recordfound',recordfound);
                        if(recordfound != null && recordfound!= undefined){
                            this.selectedRecords = this.selectedRecords.filter(record => record.Id !== recordfound.Id);
                        }  
                    
                }   
            }

            }else{
            //this.checkedvalue=event.target.checked;
            

            }
    }

    onShowClickSalesforce(){

       OpportunityProductStVendor({ProductSupplierRec:this.selectedRecords,OppProductId:this.recordId})
       .then(result => {
              if(result=='SUCCESS'){
                  this.dispatchEvent(new CloseActionScreenEvent());
              }else{
                  this.dispatchEvent(new CloseActionScreenEvent());
              }
       })
       .catch(error => {
           this.dispatchEvent(new CloseActionScreenEvent());
           console.log('Errorured:- '+error.body.message);
       });
   }

}