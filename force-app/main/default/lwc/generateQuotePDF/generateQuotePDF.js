import { LightningElement,api,track } from 'lwc';
import GenerateQuotePDFAttachement from '@salesforce/apex/AlsGlobalQuotePDFController.GenerateQuotePDFAttachement';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CloseActionScreenEvent } from 'lightning/actions';
export default class GenerateQuotePDF extends LightningElement {
@api recordId;
     @track result;
     @track error;

     connectedCallback() {
          debugger;
           setTimeout(() => {
           this.calllMethod();
           }, 300);
           }
          
     calllMethod() {
          debugger;
          GenerateQuotePDFAttachement({ recordId: this.recordId })
                   .then(result => {
                        this.result = result;
                        if (this.result == 'SUCCESS') {
                         this.dispatchEvent(new CloseActionScreenEvent());
                         this.dispatchEvent(
                             new ShowToastEvent({
                                 title: 'SUCCESS',
                                 message: 'Quote PDF Download Successfully !',
                                 variant: 'success'
                             })
                         );
                        } else {
                         this.dispatchEvent(new CloseActionScreenEvent());
                         this.dispatchEvent(
                             new ShowToastEvent({
                                 title: 'ERROR',
                                 message: 'Something went wrong!',
                                 variant: 'error'
                             })
                         );
                        }
                   })
                   .catch(error => {
                    this.error = error;
              })
           }
}