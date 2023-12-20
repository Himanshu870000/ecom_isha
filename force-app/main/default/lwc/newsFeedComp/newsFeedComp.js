import { LightningElement, api, wire } from 'lwc';
import getRecordList from '@salesforce/apex/CallBatchController.getNewsFeed';

export default class NewsFeedComp extends LightningElement {
    @api slides = [];
    @wire(getRecordList,{})
    wiredResponse(result){
        if(result.data){
            console.log('News Feed-------',result.data);
            this.slides = result.data;
        }else{
            console.log("Error to fetch account",result);
        }
    }
}