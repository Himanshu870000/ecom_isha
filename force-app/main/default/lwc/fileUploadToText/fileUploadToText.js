import { LightningElement, track, api } from 'lwc';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import covertImageText from '@salesforce/apex/FileToTextConvertercontroller.covertImageText'

export default class FileUploadToText extends LightningElement {
    @api recordId; // ID of the record where the image will be saved
    @api objectApiName; // API name of the object where the image will be saved
    @track imageData1
    @track imageData;
    @track imgTxt =''
    handleFileSelect(event) {
        const file = event.target.files[0];
        if (file.type.match('image.*')) {
            const reader = new FileReader();
            reader.onload = () => {
                this.imageData = reader.result;
                this.imageData1= reader.result.split(',')[1];
            };
            reader.readAsDataURL(file);
        } else {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: 'File must be an image',
                    variant: 'error'
                })
            );
        }
    }

     saveImage() {
       
        if (this.imageData1) {
            // const fields = {};
            // fields[FIELD_NAME] = this.imageData;
            // const recordInput = { id:this.recordId, apiName: this.objectApiName, fields };
            // console.log('recordInput>>'+ JSON.stringify(recordInput));
            // try {
            //     await updateRecord()
            //     await createRecord(recordInput);
            //     this.dispatchEvent(
            //         new ShowToastEvent({
            //             title: 'Success',
            //             message: 'Image uploaded successfully',
            //             variant: 'success'
            //         })
            //     );
            //     this.imageData = null;
            // } catch (error) {
            //     console.log(JSON.stringify(error.message));
            //     this.dispatchEvent(
            //         new ShowToastEvent({
            //             title: 'Error',
            //             message: error.message,
                        
            //             variant: 'error'
            //         })
            //     );
            // }
            try {
            covertImageText({recordId: this.recordId, img:  this.imageData1}).then(data=>{
                console.log('imgdataa'+ data);
                if(data){
                    location.reload();
                }
             })
            } catch(error){
                this.dispatchEvent(
                            new ShowToastEvent({
                                title: 'Error',
                                message: error.message,
                                
                                variant: 'error'
                            })
                        );

            }
             reader.readAsDataURL(file);
        }
    }
}