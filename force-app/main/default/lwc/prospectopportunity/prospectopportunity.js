import { LightningElement ,api,track} from 'lwc';
import prospect_opportunity from '@salesforce/apex/GoarTracking.prospectOpprtunity';
export default class Prospectopportunity extends LightningElement {
    @api recordId = 'a27N0000001HS2CIAW';
    porpectOpportunity = [];
    
    constructor(){
        super()

    }
    connectedCallback(){
        prospect_opportunity({goalId : this.recordId}).then(result =>{
            debugger;
            console.log('result::'+result);
            this.porpectOpportunity = result;
            console.log('this.porpectOpportunity::'+this.porpectOpportunity);
        }).catch(error =>{
            console.log('error::'+error);
        })
    }


}