import { LightningElement,api,track } from 'lwc';
import userwise_revenue from '@salesforce/apex/GoarTracking.userwiseRevenue';

export default class Revenuetraget extends LightningElement {
    @api test = 'kishan';
    @api recordId = 'a27N0000001HS2CIAW';
    userwise_revenue = {};
    @track userwiseAmount = [];
    @track username = [];
    @track total_amount = 0;
    constructor(){
        super()

    }
    connectedCallback(){
        userwise_revenue({goalId : this.recordId}).then(result =>{
            debugger;
            console.log('result::'+result);
            var conts = result;
            this.total_amount = result.total_amount;
            console.log('this.porpectOpportunity::'+this.userwise_revenue);
            for(var key in conts.opp_owner_amount){
                debugger;
                this.userwiseAmount.push({value:conts.opp_owner_amount[key],key:key})
                this.username.push({value:conts.opp_owner_name[key],key:key})
                console.log('userwiseAmount::'+this.userwiseAmount);
                console.log('userwiseAmount:'+this.userwiseAmount);
            }
        }).catch(error =>{
            console.log('error::'+error);
        })
    }
}