import { LightningElement,api,track,wire} from 'lwc';
import getAllProduct from '@salesforce/apex/ProductBundleHelper.GetAllProduct'
import getAllBundle from '@salesforce/apex/ProductBundleHelper.GetAllProductBundle'
import submitProductBundle from '@salesforce/apex/ProductBundleHelper.submitProductBundle'


import {CloseActionScreenEvent} from 'lightning/actions';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

const columns = [
    { label: 'Name', fieldName: 'Name' },
    {label:'Quantity',fieldName:'Quantity__c',editable:true},
    { label: 'Price', fieldName: 'Price__c' },
    { label: 'Recommended', fieldName: 'Recommended__c',type:"boolean",editable:true},
    { label: 'Description', fieldName: 'Description__c'}
];

export default class InitiateProductBatch extends LightningElement {

    columns = columns;

    @api recordId;
    @track isLoading = false;
    @track productSelected;
    @track products = [];
    @track productBundle = [];
    @track disableSubmitBtn = true;
    @track draftValues = [];

    @wire(getAllProduct,{recordId:'$recordId'})
    wiredResponse(result){
        if(result.data){
            let prodList = [];
            result.data.forEach(item=>{
                let obj = {
                    label:item.Name,
                    value:item.Id
                };
                prodList.push(obj);
            });

            this.products = prodList;
            console.log('RecordId---',this.recordId);
            console.log('Result data----',this.products);
        }
    }

    handleChange(event) {
        this.productSelected = event.detail.value;
        this.fetchProductBatch();
    }


    @track showBatches = false
    fetchProductBatch(){
        this.showBatches = false;
        getAllBundle({productId:this.productSelected}).then(result=>{
            result.forEach(item=>{
                let obj = {...item};
                obj.checked = false;
            })
            this.productBundle = result;
            this.showBatches = true;
            console.log('Product Bundle-----',this.productBundle);
            if(this.productBundle.length==0){
                this.showToast('Empty','Product Batches are empty!','warning');
            }
        }).catch(error=>{
            console.log('Error to get Bundle');
        })
    }

    @track selectedProdBundle = [];
    getSelectedName(event) {
        const selectedRows = event.detail.selectedRows;
        
        this.selectedProdBundle = selectedRows;
        console.log('ProductSelected----',this.selectedProdBundle);
        console.log('draftValues',event.detail.draftValues);
        this.disableSubmitBtn = this.selectedProdBundle.length==0
    }

    closePopup(){
        this.dispatchEvent(new CloseActionScreenEvent());
    }


    submitBundle(){
        
        this.isLoading = true;

        let prodList = []
        this.productBundle.forEach(item=>{
            let obj = {...item};
            if(obj.checked){
                delete obj.checked;
                prodList.push(obj);
            }
        })


        const obj = {productId:this.productSelected,oppId:this.recordId,prodBundle:prodList}

        console.log('Object',obj);
        
        submitProductBundle(obj).then(result=>{
            this.isLoading = false;
            if(result=='Success'){
                this.showToast('Success','Product Batch submitted Succesfully!','success');
                this.closePopup();
            }
        }).catch(error=>{
            console.log('Error');
            this.showToast('Error',error,'error');
        })
    }


    showToast(title,message,variant){
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });
        this.dispatchEvent(evt);
    }

    inputHandler(event){
        debugger;
        let eventName = event.currentTarget.dataset.name;
        let eventId = event.currentTarget.dataset.id;
        let value = event.target.value;

        let obj = this.productBundle.find(item=>item.Id==eventId);
        let objIndex = this.productBundle.findIndex(item=>item.Id==eventId);

        if(eventName=='checkbox2'){
            obj.Recommended__c = !obj.RecRecommended__c;
        }

        if(eventName=='checkbox1'){
            obj.checked = !obj.checked;
        }

        if(eventName=='input'){
            obj.Quantity__c = parseInt(value);
        }


        this.productBundle[objIndex] = obj;


        console.log('PRODUCTBUNDLE---',this.productBundle);

        
        // let isChecked = false;
        // this.productBundle.forEach(item=>{
        //     if(item.checked){
        //         isChecked = true;
        //         this.disableSubmitBtn = false;
        //     }
        // })

        this.disableSubmitBtn = this.productBundle.find(item=>item.checked)==null;


    }
}