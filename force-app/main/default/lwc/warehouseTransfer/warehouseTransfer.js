import { LightningElement, api,track } from 'lwc';
import getproductWarehouseRecords from '@salesforce/apex/TransferWarehouseProducts.getproductWarehouseRecords';
import insertWarehouseTransferLog from '@salesforce/apex/TransferWarehouseProducts.insertWarehouseTransferLog';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class WarehouseTransfer extends LightningElement {

    @api recordId;
    @track saveDraftValues =[];
      Textval ;
      rowid;
      whList = [];

    @api qtyToTransfer;
    @api currentInven;

    @track recList = [];
    @track SaveDisable=true;
    @track showErrorPopUp=true;

    connectedCallback(){
        this.handleSearch();
    }
    
    @track selectedRecord=[];
    @track warehouseProductList=[];
    @track searchKey;
    @track pageLength = 10;
    @track page = 0;
    @track searchable=[];
    @api selectedwareHouseId;

    handleSearch() {
        debugger;
        getproductWarehouseRecords({ recid: this.recordId })
            .then((result) => {
                this.recList=[];
                for(let i =0; i<result.length; i++){
                   let rec = {...result[i]};
                   rec.onSelectEnable=true;
                   rec.qtyToTransfer = '';
                   rec.currentInven = rec.Current_Inventory__c;;
                   this.recList[i] = rec;
                   this.warehouseProductList[i]=rec;
                   console.log('this.data[i].url -- ' , rec );
                }
                for(let i = 0; i < this.pageLength; i++){
                    this.searchable.push(this.recList[i]);
                }
            })
            .catch((error) => {
                this.error = error;
            });
            
    }
    getSelectedName(event) {
        debugger;
        const selectedRows = event.detail.selectedRows;
        console.log('selectedRows',selectedRows);
        this.selectedRecord=selectedRows;
    }

    @track pushToApexFromJs=[];

    handleInputChange(event){
        debugger;

        var currenttypedvalue =  event.detail.value;                  //parseInt(event.detail.value);
        var currentRecId = event.target.dataset.id;
        
        let SelectedRecord = this.recList.find(eachProdRec => eachProdRec.Id === currentRecId);

        let tempFieldWrapperArray = [...this.recList];
        let tempData = [];
        
        console.log('tempFieldWrapperArray--->',tempFieldWrapperArray);

        tempFieldWrapperArray.forEach(fieldWrapper => {
            if (fieldWrapper.Id == event.target.dataset.id) {
                // if (name == 'input1' && currenttypedvalue != NaN) {
                //     fieldWrapper.qty = currenttypedvalue;
                //     console.log('fieldWrapper====>', fieldWrapper);
                // }

                if(Number(event.target.value) > fieldWrapper.currentInven){
                    fieldWrapper.qtyToTransfer = 0;
                    alert('Should Not Be Greater Than Current Inventory');
                }
                else{
                    //alert('inside');
                    fieldWrapper.qtyToTransfer = Number(event.target.value);
                    fieldWrapper.Current_Inventory__c = fieldWrapper.currentInven - Number(event.target.value);
                    fieldWrapper.In_Transit_Inventory__c = fieldWrapper.In_Transit_Inventory__c != undefined ? fieldWrapper.In_Transit_Inventory__c + Number(event.target.value) : Number(event.target.value);  
                    fieldWrapper.checkedvalue = true;      
                    tempData.push(fieldWrapper); // push only changed modification
                }
            }
        });
        //this.recList.push(tempData);
        if(tempData != []){
            for(var i in tempData){            
                this.pushToApexFromJs.push({
                    pWHId:tempData[i].Id,
                    Quantity: tempData[i].In_Transit_Inventory__c
                });
            }

            // if(this.pushToApexFromJs.length == 0){
            //     this.pushToApexFromJs = tempData;
            // }
            // else{
            //     this.pushToApexFromJs.push(tempData);
            // }
        }
         // 109 - 156 in comment
         
        // let getSLIs = tempData;
        // var pushToApex = [];

        // //if(this.selectRecord.find(record => record.Id === currentRecId)){
        //     for(var i in tempData){
        //         pushToApex.push({
        //             Id: tempData[i].Id,
        //             Current_Inventory__c:  tempData[i].Current_Inventory__c,
        //             In_Transit_Inventory__c : tempData[i].In_Transit_Inventory__c
        //         });
        //         alert(pushToApex);
        //     }
        // //}
        // //this.selectRecord = pushToApex;

        // this.pushToApexFromJs.push(pushToApex);




        // this.rowid = event.target.dataset.id;
        // for(let i=0; i<this.recList.length; i++){
        //     if(this.rowid == this.recList[i].Id){
        //         if(this.recList[i].Current_Inventory__c!=null  ){
        //             if(Number(event.target.value) > this.recList[i].currentInven){
        //                 this.recList[i].qtyToTransfer = 0;
        //                 alert('Should Not Be Greater Than Current Inventory');
        //             }
        //             else{
        //                 this.recList[i].qtyToTransfer = Number(event.target.value);
        //                 this.recList[i].Current_Inventory__c = this.recList[i].currentInven - Number(event.target.value);
        //                 this.recList[i].In_Transit_Inventory__c = this.recList[i].In_Transit_Inventory__c != undefined ? this.recList[i].In_Transit_Inventory__c + Number(event.target.value) : Number(event.target.value);                        
        //             }
        //         }
        //     }

        //     if(this.selectRecord.find(record => record.Id === this.rowid)){
        //         let record=this.selectRecord.filter(record => record.Id !== this.rowid);
        //         this.selectRecord = this.selectRecord.filter(record => record.Id !== this.rowid);
        //         if((record!=null || record!=undefined) && record.checkedvalue==true){
        //             this.recList[i].checkedvalue=true;
        //             this.selectRecord.push(this.recList[i]);
        //         }
        //         else{
        //             this.selectRecord.push(this.recList[i]);
        //         }
        //     }            
        // }

        console.log('recList--',JSON.stringify(this.recList));
        console.log('selectRecord--',JSON.stringify(this.selectRecord));
    } 

    @track selectRecord =[];   
    changeHandler(event) {
        debugger;
        const recId = event.target.dataset.id;
        console.log('RECiD===>',recId);
        if (event.target.checked){
            for(let i=0; i<this.recList.length; i++) {
                if(this.recList[i].Id == recId) {
                    this.recList[i].onSelectEnable=false;  

                    if(this.selectRecord.find(record => record.Id === recId)){
                        this.recList[i].checkedvalue = true;
                        console.log('This Record Exist');
                    }
                    else{
                        this.recList[i].checkedvalue = true;
                        this.selectRecord.push(this.recList[i])
                    } 

                    if(this.selectRecord.length>0){
                        this.SaveDisable=false;
                    }
                }
            }
        }
        else{
            for(let i=0; i<this.recList.length; i++){
                if(this.recList[i].Id == recId){
                    this.recList[i].onSelectEnable=true;  
                    this.recList[i].checkedvalue = false; 
                }
            }
            this.selectRecord = this.selectRecord.filter(record => record.Id !== recId);
            if(this.selectRecord.length>0){
                this.SaveDisable=false;
            }
            else{
                this.SaveDisable=true; 
            }
        }
        console.log('selectRecord--',JSON.stringify(this.selectRecord));
    }


    ONSave(){
        debugger;
        let booleanValue=false;
        let count=0;
        for(let i=0;i<this.pushToApexFromJs.length;i++){
            if(this.pushToApexFromJs[i].qtyToTransfer>0){
                //booleanValue=true;
                count=count+1; 
                
            }else{
                booleanValue=false;  
            }
        }
        if(this.pushToApexFromJs.length==count){
            booleanValue=true;
        }
        else{
            booleanValue=true;
        }
        console.log('recordId--',this.recordId);
        console.log('SelectedWareHouse--',this.selectedwareHouseId);
        if(booleanValue==true){
            insertWarehouseTransferLog({ prodList:this.pushToApexFromJs,warehouseMasterId:this.recordId,SelectedWareHouseId:this.selectedwareHouseId})
            .then((result) => {
                debugger
                console.log('result---->',result);
                if(result ==='success'){
                    this.showToast();
                    this.closeModal();
                    console.log('result==>',result);
                }
            })
            .catch((error) => {
                console.log('error===>',error);
                
                // this.closeModal();
            });
        }
        else{
            window.alert('Error Provide Quantity Transfer');
        }
    }
   
   
    @track records=[];
    @track tempArray=this.searchable;
    handleKeyChange(event){
        debugger;
        this.searchKey = event.target.value;
        const searchKey = event.target.value.toLowerCase();  
        console.log( 'Search Key is ' + searchKey );

        if ( searchKey ) {  
            this.records = this.searchable;

                if ( this.records ) {
                let recs = [];
                    for (let rec of this.records) {

                        if ((rec.Name).toLowerCase().includes(searchKey)) {
                            recs.push(rec);
                            //break;
                        }
                        console.log('Rec is ' + JSON.stringify(rec));
                        /*let valuesArray = Object.values( rec );
                        console.log( 'valuesArray is ' + valuesArray );
                        for ( let val of valuesArray ) {
                            if ( val ) {
                                if ( val.toLowerCase().includes( searchKey ) ) {
                                    recs.push( rec );
                                    break;
                                }
                            }
                        }*/
                    }
                console.log( 'Recs are ' + JSON.stringify( recs ) );
                this.searchable = recs;
                }
        }  else {
            this.searchable = this.tempArray;
        }

    }


    nextpage(){
        debugger;
        let results = [];
        if(this.page <= (Math.floor(this.recList.length/this.pageLength))){
            this.page = this.page + 1;
            for(let i = 0; i < this.pageLength; i++){
                if((i + (this.page * this.pageLength)) < this.recList.length){
                    results.push(this.recList[i + (this.page * this.pageLength)]);
                }
            }
            this.searchable = results;
            console.log('searchable--',this.searchable);
        }
        // if(this.page==this.recList.length){
        //     this.disable=true;
        // }
        if(results.length == 0){
            this.disable=true;
        }
    }   

    prevpage(){
        debugger;
        let results = [];
        if(this.page >= 1){
            this.page = this.page - 1;
            for(let i = 0; i < this.pageLength; i++){
                if((i + (this.page * this.pageLength)) < this.recList.length){
                    results.push(this.recList[i + (this.page * this.pageLength)]);
                }            
            }
            this.searchable = results;
            console.log('searchable--',this.searchable);
        }
        if(this.page == this.recList.length){
            this.disable=true;
        }
    }
    
    showToast() {
        const event = new ShowToastEvent({
            title: 'Transfer Product Warehouse',
            message: 'Successfully Transfered',
            variant: 'success',
            mode: 'dismissable'
        });
        this.dispatchEvent(event);
    }

    closeModal() {
        debugger;
        this.dispatchEvent(new CustomEvent('close')) 
    }

}