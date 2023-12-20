import { LightningElement,track,api } from 'lwc';
import addJiraComment from '@salesforce/apex/CurrentRecordsControllerToCase.addJiraComment';
import getJiraCommnets from '@salesforce/apex/CurrentRecordsControllerToCase.getJiraCommnets';
import check_exist_jira_issue from '@salesforce/apex/CurrentRecordsControllerToCase.check_exist_jira_issue';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class AddDescription extends LightningElement {

     columns = [
        { label: 'Label', fieldName: 'name' },
        { label: 'Website', fieldName: 'website', type: 'url' },
        { label: 'Phone', fieldName: 'phone', type: 'phone' },
        { label: 'Balance', fieldName: 'amount', type: 'currency' },
        { label: 'CloseAt', fieldName: 'closeAt', type: 'date' },
    ];
    @track Descriptions;
    @track checkRecord=true;
    @track Issue_key=null;
    @api recordId;

    connectedCallback(){
        check_exist_jira_issue({caseID:this.recordId}).then(result=>{
            console.log(result);
            this.checkRecord=result.exist;
            console.log(this.recordId);
            this.Issue_key=result.Issue_key;
            if(!this.checkRecord){
            getJiraCommnets({caseID:this.recordId,Issue_key:result.Issue_key}).then(result=>{
                console.log(result.comments);
                if(result!==null){
                   
                    console.log(result.comments[0].body.content[0].content[0].text);
                    result.comments.forEach(comment => {
                        let date=new Date(comment.created);
                        // console.log(date.toLocaleDateString()+' '+date.toLocaleTimeString())
                        comment.created=date.toLocaleDateString()+' '+date.toLocaleTimeString();
                    });
                    this.Descriptions=result.comments;
                   console.log(this.Descriptions.length);
                   if(this.Description.length==0){
                       this.checkRecord=true;
                   }
                    console.log(result.comments[0].created);
                }
            })
            }
        })
        
       
    }
    addIssueDescription(){
        console.log(this.Description)
        addJiraComment({description:this.Description,caseID:this.recordId,Issue_key:this.Issue_key}).then(result=>{
            console.log(result);
            if(result){
                const event = new ShowToastEvent({
                    title: 'Comment added',
                    message: 'Comment added to issue',
                    variant: 'success',
                    mode: 'dismissable'
                });
                this.dispatchEvent(event);
            }
            else{
                const event = new ShowToastEvent({
                    title: 'Fail',
                    message: 'Comment add failed',
                    variant: 'Fail',
                    mode: 'dismissable'
                });
                this.dispatchEvent(event);
            }
        })
    }
    
    setDescription(event){
        this.Description=event.target.value;
    }
}