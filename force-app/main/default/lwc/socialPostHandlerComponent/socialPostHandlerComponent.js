import { LightningElement, track, wire} from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CloseActionScreenEvent } from 'lightning/actions';
import createContent from '@salesforce/apex/SocialPostHandlerCtrl.createContent'; 
import getPicklistValue from '@salesforce/apex/SocialPostHandlerCtrl.getPickListValue'

export default class SocialPostHandlerComponent extends LightningElement {
    file;
    _headerText;
    _footerText;
    @track picklistOptions = [];
    @track selectedValues = [];
    _isPostNow = false;
    _scheduleDateTime;
    
    @wire(getPicklistValue, {Object_Api_Name: 'Content__c', field_Api_Name : 'Plateform__c'})
    retrievePicklistValues({ error, data }) {
        if (data) {
            this.picklistOptions = [];
            for(let key in data){
                this.picklistOptions.push({label:data[key], value:key});
            }
        } else if (error) {
            console.error('Error while retrieving picklist values:', error);
        }
    }

    //Capture text change
    handleChange(event){
        if(event.target.name === 'headerText'){
            this._headerText = event.target.value;
        }else if(event.target.name === 'footerText'){
            this._footerText = event.target.value;    
        }else if(event.target.name === 'postNow'){
            this._isPostNow = event.target.checked;    
        }else if(event.target.name === 'scheduleDate'){
            this._scheduleDateTime = event.target.value;    
        }
    }
    //Capture file change
    handleFileChange(event){
        this.file = event.target.files[0];
    }
    handleCancel(event) {
        this.dispatchEvent(new CloseActionScreenEvent());
    }
    handleSelectionChange(event){
        this.selectedValues = event.target.value;
    }
    handleSave(){
        if(!this.file || this.file.type !== 'image/jpeg'){
            this.showToastMessage('Error', 'Please select a JPEG file', 'error');
            return;
        }else if(!this.selectedValues || this.selectedValues.length === 0){
            this.showToastMessage('Error', 'Please choose Social Palteform', 'error');
            return;
        }else if(!this._scheduleDateTime && this._isPostNow === false){
            this.showToastMessage('Error', 'Please choose Social Post schedule time', 'error');
            return;
        }
        let fileReader = new FileReader();
        fileReader.onloadend = () => {
            let fileContents = fileReader.result.split(',')[1];
            this.createRecordWithAttachament(fileContents);
        };
        fileReader.readAsDataURL(this.file);
    }
    createRecordWithAttachament(fileContents){
        createContent(
            { 
                header:this._headerText, footer: this._footerText, fileContents : fileContents,
                plateforms: this.selectedValues, scheduledate:this._scheduleDateTime, isPostNow: this._isPostNow

            }).then(() => {
            this.showToastMessage('Success', 'Social Post is created successfully!', 'success');
            this.handleCancel();
        }).catch((error)=> {
            this.showToastMessage('Error', 'Something went wrong. Please connect System Admin.', 'error');
        });
    }

    showToastMessage(titleStr, messageStr, variantStr){
        this.dispatchEvent(
            new ShowToastEvent({
                title: titleStr,
                message: messageStr,
                variant: variantStr
            })
        );
    }
    
}