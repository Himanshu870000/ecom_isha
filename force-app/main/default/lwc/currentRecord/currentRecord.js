import { LightningElement, api,wire } from 'lwc';
import add_jira_issue from '@salesforce/apex/CurrentRecordsControllerToCase.add_jira_issue';
import getAllCases from '@salesforce/apex/CurrentRecordsControllerToCase.getCaseDetails';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class CurrentRecord extends LightningElement {
    @api recordId;
    Subject;
    Description;
    connectedCallback(){
        getAllCases({caseID:this.recordId}).then(result=>{
            console.log(result);
            this.Subject=result[0].Subject;
            this.Description=result[0].Description;
        })
    }
    addIssue(){
        
        add_jira_issue({caseID: this.recordId}).then(result=>{
            console.log(result)
            if(result==true){
                const event = new ShowToastEvent({
                title: 'JIRA Issue',
                message: 'Issue is created',
                variant: 'success',
                mode: 'dismissable'
            });
            this.dispatchEvent(event);
            }
            else{
                console.log(' d')
            }
        });
    }
}