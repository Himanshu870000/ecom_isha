import { LightningElement,api,wire,track} from 'lwc';
import icclogo from '@salesforce/resourceUrl/IccLogo';
import dashboardbutton from '@salesforce/resourceUrl/DashboardButton';
import backgroundBlue1 from '@salesforce/resourceUrl/BackgroundBlue';
import groupImage1 from '@salesforce/resourceUrl/GroupImage';
import playingImage1 from '@salesforce/resourceUrl/PlayingImage';
import playingImage11 from '@salesforce/resourceUrl/PlayingImage1';
import iCCButton1 from '@salesforce/resourceUrl/ICCButton';
import indiaLogo1 from '@salesforce/resourceUrl/IndiaLogo';
import australia1 from '@salesforce/resourceUrl/Australia';
import englandLogio1 from '@salesforce/resourceUrl/EnglandLogio';
import getBoardsdeatails from '@salesforce/apex/IccCricketBordsEvents.getBoardsName' ;
import getEventsType from '@salesforce/apex/IccCricketBordsEvents.getEvents' ;
//import { getPicklistValues } from 'lightning/uiObjectInfoApi';
//import getEvents from '@salesforce/schema/Event_Master__c.Events__c';

 
export default class ICCEventPage extends LightningElement {

    @track picklistval;
    icclogo1 = icclogo;
    DashboardButton1 = dashboardbutton;
    BackgroundBlue1 = backgroundBlue1;
    GroupImage1 = groupImage1;
    PlayingImage1 = playingImage1;
    PlayingImage11 = playingImage11
    ICCButton1 = iCCButton1;
    IndiaLogo1 = indiaLogo1;
    Australia1 = australia1;
    EnglandLogio1 = englandLogio1;
    


    @track boardList;
    @wire(getBoardsdeatails) boardslist;
     debugger;
         
    @api areDetailsVisible =false;
    debugger;
    clickHandler1(event) {
        debugger;
        this.areDetailsVisible =true;
        console.log('boardslist---',boardslist);
    }
    clickHandler2(event) {
      debugger;
        this.areDetailsVisible =false;
    }

   
    // @wire(getPicklistValues,{fieldApiName: getEvents}) 
    // eventpicklistvalue;
    
    
    handleOnClick(event){
        debugger;
        let selectedId = event.currentTarget.dataset.id;
        let label=event.target.label;
        console.log('label---',label);
        
         let objIndx = this.records.findIndex((item => item.Id == selectedId));
        this.boardslist[objIndx];
        this.picklistval = event.target.value;
    }

    @track data;

    @wire(getEventsType)
    wiredResponse({data,error}){
        if(data){
            console.log('data--',data);
            this.data=data;
        }else{
            console.log('error---',error);
        }
    }
}