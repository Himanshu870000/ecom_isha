import { LightningElement, api, track, wire } from 'lwc';
import lookUp from '@salesforce/apex/recommendSchoolHelper.search';
import fetchDefaultRecord from '@salesforce/apex/recommendSchoolHelper.fetchDefaultRecord';

export default class SchoolLookup extends LightningElement {

    @api objName;
    @api index;
    @api selectedId;
    @api name;
    @api iconName;
    @api recordId;
    @api searchPlaceholder='Search';

    @track selectedName;
    @track records;
    @track isValueSelected;
    @track blurTimeout;

    @api searchTerm;
    @api defaultRecordId = '';
    //css
    selectedRecord = {};
    @track boxClass = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus';
    @track inputClass = '';

        connectedCallback(){
            debugger;
            if(this.defaultRecordId != ''){
                fetchDefaultRecord({ recordId: this.defaultRecordId , myObject : 'School__c' })
                .then((result) => {
                    if(result != null){
                        this.isValueSelected = true;
                        this.selectedRecord = result;
                        this.selectedName=this.selectedRecord.Name;
                        console.log('this.selectedName--',this.selectedName);
                        //this.handelSelectRecordHelper(); // helper function to show/hide lookup result container on UI
                    }
                })
                .catch((error) => {
                    this.error = error;
                    this.selectedRecord = {};
                });
            }
        }

    @wire(lookUp, {searchTerm : '$searchTerm', myObject : '$objName'})
    wiredRecords({ error, data }) {
        debugger;
        if (data) {
            this.error = undefined;
            this.records = data;
        } else if (error) {
            this.error = error;
            this.records = undefined;
        }
    }

    handleClick() {
        this.searchTerm = '';
        this.inputClass = 'slds-has-focus';
        this.boxClass = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus slds-is-open';
    }

    onBlur() {
        this.blurTimeout = setTimeout(() =>  {this.boxClass = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus'}, 300);
    }

    onSelect(event) {
        debugger;
        this.selectedId = event.currentTarget.dataset.id;
        this.name = event.currentTarget.dataset.name;
        const valueSelectedEvent = new CustomEvent('lookupselected', {
            detail:  {
            'selectedId' : this.selectedId,
            'index'      : this.index,
            'name'       : this.name
            }
        });
        this.dispatchEvent(valueSelectedEvent);
        this.isValueSelected = true;
        this.selectedName = this.name;
        if(this.blurTimeout) {
            clearTimeout(this.blurTimeout);
        }
        this.boxClass = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus';
    }

    handleRemovePill() {
        this.isValueSelected = false;
    }

    onChange(event) {
        this.searchTerm = event.target.value;
    }
}