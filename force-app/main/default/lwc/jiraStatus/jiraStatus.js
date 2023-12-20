import { LightningElement,api,wire } from 'lwc';
import getJIRAStatus from '@salesforce/apex/CurrentRecordsControllerToCase.getJIRAStatus'

export default class JiraStatus extends LightningElement {
    @api recordId;
    statuses=[];
    connectedCallback(){
        getJIRAStatus({caseID:this.recordId}).then(result=>{
            console.log(result);
            this.statuses=result;
        })
    }
}