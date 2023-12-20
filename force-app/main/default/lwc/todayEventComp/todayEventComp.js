import { LightningElement,wire, api } from 'lwc';
import getRecordList from '@salesforce/apex/CallBatchController.getTodayEvent';

export default class TodayEventComp extends LightningElement {

    recList = [];
    @api url = 'https://sales-production--fsldemo.sandbox.lightning.force.com/lightning/r/Account/001N000002AUr3AIAT/view';

    @wire(getRecordList,{})
    wiredResponse(result){
        debugger;
        if(result.data){
            console.log('Events-------',result.data);
            this.recList = result.data;
                        
        }else{
            console.log("Error to fetch Events",result);
        }
    }

}