import { LightningElement,api, track } from 'lwc';
import revenue_track from '@salesforce/apex/GoarTracking.revenueTrack';
export default class Revenuetracking extends LightningElement {
    @api recordId = 'a27N0000001HS2CIAW';
    @api objectApiName;
    @api goalTrackData= [];
    @track achived_percentage;
    constructor(){
        super();
        //console.log('recordid::'+this.recordId);
       // console.log('objectname:'+this.objectApiName);
    }
    connectedCallback(){
        debugger;
        revenue_track({goalId:this.recordId}).then(result=>{
            debugger;
            console.log('result::'+result);
            this.goalTrackData = result;
            console.log('this.goalTrackData::'+this.goalTrackData);
            
            this.achived_percentage = (this.goalTrackData.Achieved_Target__c * 100) / this.goalTrackData.Target__c;
            //this.Subject=result[0].Subject;
            //this.Description=result[0].Description;
        }).catch(error=>{
            console.log('error::'+error);
        })
    }
}