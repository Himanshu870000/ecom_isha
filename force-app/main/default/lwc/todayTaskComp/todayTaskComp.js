import { LightningElement,wire } from 'lwc';
import getRecordList from '@salesforce/apex/CallBatchController.getTodayTask';

export default class TodayTaskComp extends LightningElement {
    recList = [];
    @wire(getRecordList,{})
    wiredResponse(result){
        if(result.data){
            console.log('Tasks-------',result.data);
            this.recList = result.data;
        }else{
            console.log("Error to fetch Tasks",result);
        }
    }
}