import { LightningElement,api} from 'lwc';
import { wire} from 'lwc';
import { createRecord } from 'lightning/uiRecordApi';
import objectName from '@salesforce/schema/ExpenseT__Expense_Item__c';
import expenItemName from '@salesforce/schema/ExpenseT__Expense_Item__c.Name';
import transDate from '@salesforce/schema/ExpenseT__Expense_Item__c.ExpenseT__Expense_Item_Transaction_Date__c';
import amount from '@salesforce/schema/ExpenseT__Expense_Item__c.ExpenseT__Expense_Item_Amount__c';
import category from '@salesforce/schema/ExpenseT__Expense_Item__c.ExpenseT__Expense_Item_Category__c';
import expense from '@salesforce/schema/ExpenseT__Expense_Item__c.ExpenseT__Expense__c';

import getParentRecordName from '@salesforce/apex/ExpenseItemController.getRecordName';
import uploadNotesAndAttachment from '@salesforce/apex/ExpenseItemController.uploadFile';
import {NavigationMixin} from 'lightning/navigation';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class ExpenseItem extends NavigationMixin (LightningElement) {
    expenseItemName = '';
    amount = '';
    categoryValue= '';
    transactionDate='';
    expense='';
    @api expenseRecordId;
    parentRecordName;
    expenseItemRecordId;
    fileData;
    attachmentId;
    parentRecordLink;
    lstAllFiles;
    connectedCallback(){
        let newURL=window.location.href;
        let splitURL=newURL.toString().split("/");
        this.parentRecordLink='https://'+splitURL[2]+'/'+this.expenseRecordId;
    }
    @wire(getParentRecordName,{ recordId: '$expenseRecordId'})
    wiredRecord({ error, data }) {
        if (data) {
            this.parentRecordName = data;
            console.log('parentRecordID::'+this.parentRecordName);
            this.error = undefined;
        } else if (error) {
            this.error = error;
        }
    }
    /**This Method basically capture the change values of fields**/
    changeValue(event) {   
        if(event.target.label=='Expense Item Name'){
            this.expenseItemName = event.target.value;
        }
        if(event.target.label=='Transaction Date'){
            this.transactionDate = event.target.value;
        }            
        if(event.target.label=='Amount'){
            this.amount = event.target.value;
        } 
        
    }
    /** This Method basically used to create record of expense Item **/
    insertExpenseItemAction(){
        const fields = {};
        fields[expenItemName.fieldApiName] = this.expenseItemName;
        fields[transDate.fieldApiName] = this.transactionDate;
        fields[amount.fieldApiName] = this.amount;
        fields[category.fieldApiName] = this.categoryValue;
        fields[expense.fieldApiName] = this.expenseRecordId;
       
        const recordInput = { apiName: objectName.objectApiName, fields };
        createRecord(recordInput)
            .then(data=> {
                this.expenseItemRecordId = data.id;
                this.fileData.expenseItemRecordId=data.id;
                this.uploadFiles();
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Expense Item  has been created',
                        variant: 'success',
                    }),
                );
               /*Start Navigation*/
                this[NavigationMixin.Navigate]({
                    type: 'standard__recordPage',
                    attributes: {
                        recordId: this.expenseRecordId,
                        objectApiName: 'ExpenseT__Expense__c',
                        actionName: 'view'
                    },
                });
            /*End Navigation*/
 
 
 
            })
            .catch(error => {
                console.log('error::'+error);
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error creating record',
                        message: error.body.message,
                        variant: 'error',
                    }),
                );
            });
    }
    /**This method handles the event which is fired from customPicklist component.**/
    handlecategoryChangeValue(event){
        this.categoryValue=event.detail;
    }
    openfileUpload(event) {
        const file = event.target.files[0]
        var reader = new FileReader()
        reader.onload = () => {
            var base64 = reader.result.split(',')[1]
            this.fileData = {
                'filename': file.name,
                'base64': base64,
                'expenseItemRecordId': this.expenseItemRecordId
            }
            console.log(this.fileData)
        }
        reader.readAsDataURL(file)
    }
    uploadFiles(){
       const {base64, filename, expenseItemRecordId} = this.fileData
        uploadNotesAndAttachment({ base64, filename, expenseItemRecordId }).then(result=>{
            this.fileData = null;
            this.attachmentId = result;
            this.error = undefined;
        }).catch((error) => {
            console.log('error::'+error);
            this.error = error;
            this.attachmentId = undefined;
        });
      
    }
    get acceptedFormats() {
        return ['.pdf','.png','.jpg','.doc','.xlsx','.xls','.csv','.docx'];
    }
     
        
 
}