import { LightningElement, wire, api, track } from 'lwc';
import getRecordList from '@salesforce/apex/CallBatchController.getContacts';

export default class ConversationWithDMComp extends LightningElement {
    @track recList = [];
    @api url = '';
    @wire(getRecordList,{})
    wiredResponse(result){
        if(result.data){
            debugger;
            console.log('Contacts-------',result.data);
            this.recList = [];
            for(let i =0; i<result.data.length; i++){
                let rec = {...result.data[i]};
                rec.url = 'https://web.whatsapp.com/send?phone=+'+rec.Phone+'&text='+rec.Predefined_Message__c;
                this.recList[i] = rec;
                console.log('this.recList[i].url -- ' , rec );
            }
             
        }else{
            console.log("Error to fetch Contacts",result);
        }
    }
}