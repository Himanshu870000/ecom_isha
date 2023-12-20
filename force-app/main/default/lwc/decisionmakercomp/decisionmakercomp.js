import { LightningElement ,track,api } from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';
import insertAccounts from '@salesforce/apex/DecisionMakerCompHandler.insertEmployees'
import {ShowToastEvent} from "lightning/platformShowToastEvent";
export default class Decisionmakercomp extends LightningElement {
    @track listOfAccounts;
    @api recordId;
    //@track tempRec = this.recordId
    connectedCallback() {
        this.initData();
    }

    initData() {
        let listOfAccounts = [];
        this.createRow(listOfAccounts);
        this.listOfAccounts = listOfAccounts;
    }

    createRow(listOfAccounts) {
        let accountObject = {};
        if(listOfAccounts.length > 0) {
            accountObject.index = listOfAccounts[listOfAccounts.length - 1].index + 1;
        } else {
            accountObject.index = 1;
        }
        accountObject.FirstName = null;
        accountObject.LastName = null;
        accountObject.Phone = null;
        accountObject.Email = null;
        listOfAccounts.push(accountObject);
    }

    /**
     * Adds a new row
     */
    addNewRow() {
        this.createRow(this.listOfAccounts);
    }

    /**
     * Removes the selected row
     */
    removeRow(event) {
        let toBeDeletedRowIndex = event.target.name;

        let listOfAccounts = [];
        for(let i = 0; i < this.listOfAccounts.length; i++) {
            let tempRecord = Object.assign({}, this.listOfAccounts[i]); //cloning object
            if(tempRecord.index !== toBeDeletedRowIndex) {
                listOfAccounts.push(tempRecord);
            }
        }

        for(let i = 0; i < listOfAccounts.length; i++) {
            listOfAccounts[i].index = i + 1;
        }

        this.listOfAccounts = listOfAccounts;
    }

    /**
     * Removes all rows
     */
    removeAllRows() {
        let listOfAccounts = [];
        this.createRow(listOfAccounts);
        this.listOfAccounts = listOfAccounts;
    }

    handleInputChange(event) {
        let index = event.target.dataset.id;
        let fieldName = event.target.name;
        let value = event.target.value;

        for(let i = 0; i < this.listOfAccounts.length; i++) {
            if(this.listOfAccounts[i].index === parseInt(index)) {
                this.listOfAccounts[i][fieldName] = value;
            }
        }
    }

    createAccounts() {
        debugger;
        insertAccounts({
            jsonOfListOfAccounts: JSON.stringify(this.listOfAccounts),
            recordId            : this.recordId
        })
            .then(data => {
                this.initData();
                let event = new ShowToastEvent({
                    message: "Contacts successfully created!",
                    variant: "success",
                    duration: 2000
                });
                this.dispatchEvent(event);
                this.dispatchEvent(new CloseActionScreenEvent());
            })
            .catch(error => {
                console.log(error);
                 this.dispatchEvent(new CloseActionScreenEvent());
            });
    }
}