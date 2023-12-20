import {api, LightningElement, wire } from 'lwc';
import getRecordList from '@salesforce/apex/CallBatchController.getRecommendedAccounts';

export default class RecommendedClientsComp extends LightningElement {
    recList = [];

    @wire(getRecordList,{})
    wiredResponse(result){
        if(result.data){
            console.log('Recommended Clients Data-------',result.data);
            this.recList = result.data;
        }else{
            console.log("Error to fetch data of Recommended Clients",result);
        }
    }

    handleClick2p2(event) {
        debugger;
        console.log('tyuio' + event.currentTarget.dataset.name);
        this.recName = event.currentTarget.dataset.name;
    }
}