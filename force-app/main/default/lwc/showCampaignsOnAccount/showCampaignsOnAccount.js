import { LightningElement,wire,api,track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CloseActionScreenEvent } from 'lightning/actions';
import getCampaignsRecords from '@salesforce/apex/showCampaignsOnAccountController.getCampaigns';
import sendEmail from '@salesforce/apex/showCampaignsOnAccountController.sendEmailToAccount';
	
import myResource from '@salesforce/resourceUrl/Assured';
import myResource1 from '@salesforce/resourceUrl/Admission';
import myResource2 from '@salesforce/resourceUrl/Spotlight';

export default class ShowCampaignsOnAccount extends LightningElement {
    assuredCamp = myResource;
    admissionCamp = myResource1;
    spotlightCamp = myResource2;

    @api recordId;
    @track listOfCampaigns = [];
    @track campName;

    @wire(getCampaignsRecords)
    wiredResponse(result){
        if(result.data){
            console.log('Campaign Records-------',result.data);
          
            this.listOfCampaigns = result.data;
        }else{
            console.log("Error to fetch Campaigns Records :: ",result);
        }
    }

    handleClickSelectedCamp(event){
        debugger;
        this.campName = event.currentTarget.dataset.name;

        sendEmail({
            campaignName: this.campName,
            accountId: this.recordId
        }).then(result =>{
            console.log('Result:', result);
            this.showNotification('Success','Email has been sent successfully..','success');
            this.closeAction();
        })
    }

    showNotification(title,message,variant){
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(evt);
    }

    closeAction(){
        this.dispatchEvent(new CloseActionScreenEvent());
    }
}