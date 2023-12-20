import { LightningElement,api } from 'lwc';
import goal_tracking from '@salesforce/apex/GoarTracking.createGoalTracking'

export default class Goaltrackinglwc extends LightningElement {
    @api recordId;
    constructor(){
        super();
        //console.log('this:record::'+this.recordId);
        //this.goaltracking_execution();
    }
    connectedCallback(){
        console.log('this:record::'+this.recordId);
        this.goaltracking_execution();
    }
    goaltracking_execution(){
        console.log('goalexecution');
        goal_tracking({goalId:this.recordId}).then(result =>{

        }).catch(error =>{
            console.log('error::'+error);
        })
    }
}