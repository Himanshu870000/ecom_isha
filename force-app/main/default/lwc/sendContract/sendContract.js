import { LightningElement,wire,track,api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import sendEmail from '@salesforce/apex/SendContractEmail.sendEmail';
import { CloseActionScreenEvent } from 'lightning/actions';
import { updateRecord } from 'lightning/uiRecordApi';
export default class SendContract extends LightningElement {

   // @track tempVisible = true;

      @api recordId;
connectedCallback() {
    debugger;
     setTimeout(() => {
        this.handle();  
        },300);
}

   handle(){
    sendEmail({ schoolId: this.recordId })
        .then((result) => {
            debugger;
            if(result == 'SUCCESS')
            {
              //  this.tempVisible = false;
                debugger;
                console.log('result---->',result);  
                this.showSuccessToast();
               this.closeQuickAction();
               updateRecord({ fields: { Id: this.recordId } });
            }
            else{
                this.showErrorToast() ;
                this.closeQuickAction();
            }
        })
        .catch((error) => {
            console.log('error--->',error);
        });

}
    closeQuickAction() {
        this.dispatchEvent(new CloseActionScreenEvent());
    }

    showSuccessToast() {
    const evt = new ShowToastEvent({
    title: 'Success',
    message: 'Email Successfully Sent!!',
    variant: 'success',
    mode: 'dismissable'
});
this.dispatchEvent(evt);
}

showErrorToast() {
const evt = new ShowToastEvent({
    title: 'Error',
    message: 'Some unexpected error',
    variant: 'error',
    mode: 'dismissable'
});
this.dispatchEvent(evt);
}



}