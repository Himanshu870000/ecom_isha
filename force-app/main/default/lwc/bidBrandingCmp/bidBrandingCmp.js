import { LightningElement,wire,track, api } from 'lwc';
import BidAssetList from '@salesforce/apex/bidBrandingCmpClass.BidAssetList';

export default class BidBrandingCmp extends LightningElement {
    @track recList = [];
    @api url = '';
    @wire(BidAssetList,{})
    wiredResponse(result){
        if(result.data){
            debugger;
            console.log('Contacts-------',result.data);
            this.recList = [];
            for(let i =0; i<result.data.length; i++){
                let rec = {...result.data[i]};
                rec.url = 'https://sales-production--fsldemo.sandbox.lightning.force.com/lightning/r/Bid_Branding_Asset__c/'+rec.Id+'/view';
                this.recList[i] = rec;
                console.log('this.recList[i].url -- ' , rec );
            }
             
        }else{
            console.log("Error to fetch Fund",result);
        }
    }
}