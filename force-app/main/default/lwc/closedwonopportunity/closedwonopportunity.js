import { api, LightningElement,track } from 'lwc';
import closedwon_opportunity from '@salesforce/apex/GoarTracking.closedWonOpprtunity';
export default class Closedwonopportunity extends LightningElement {
    @api recordId = 'a27N0000001HS2CIAW';
    closedwonOpportunity = [];
    constructor(){
        super()

    }
    connectedCallback(){
        closedwon_opportunity({goalId : this.recordId}).then(result =>{
            debugger;
            console.log('result::'+result);
            this.closedwonOpportunity = result;
            console.log('this.porpectOpportunity::'+this.closedwonOpportunity);
        }).catch(error =>{
            console.log('error::'+error);
        })
    }
}