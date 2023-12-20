import { LightningElement,api,wire,track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getData from '@salesforce/apex/recommendSchoolHelper.getAllVisits';
import doSave from '@salesforce/apex/recommendSchoolHelper.saveVisits';
import { CloseActionScreenEvent } from 'lightning/actions';
import { NavigationMixin } from 'lightning/navigation';
import { loadStyle } from "lightning/platformResourceLoader";  

export default class RecommendSchoolOnOpportunity extends NavigationMixin(LightningElement) {
    
    @api recordId;
    @api masterId ;
    @api valueId ;

    @track mtrlSpecList = [];
    @track keyIndex = 1;
    value = '';

    connectedCallback(){
        debugger;
        //loadStyle(this, modal);
        setTimeout(() => {
           this.getAllData(); 
        },300);
    }
    getAllData(){
        debugger;
        console.log('recordId--',this.recordId);
        getData({oppId : this.recordId}).then(result => {
            console.log("result -- ",result);
            if(result.length!=0 || result.length > 0){
                for(let i=0;i<result.length;i++){
                   result[i].index=i+1; 
                }
                this.mtrlSpecList = result;
            }
            else{
                this.keyIndex=this.keyIndex;
                var keyindexvalue=this.keyIndex;
                let obj={
                    Id:null,
                    index:keyindexvalue,
                    School__c :null,
                    Description__c :null,
                    Visit_Date_Time__c :null
                }
                this.mtrlSpecList.push(obj);
            }
            console.log("mtrlSpecList -- ",this.mtrlSpecList);
            console.log("mtrlSpecList Length -- ",this.mtrlSpecList.length);
            
        }).catch(error => {
            console.log("Error -- ",error);
        })
    }
     handleSpecSelection(event){
        debugger;
        var Index=event.detail.index;
        console.log('index--',Index);
        var Id=event.detail.selectedId;
        console.log('Id--',Id);
        if(event.detail.selectedId != undefined){
            this.masterId =  event.detail.selectedId;
            console.log(' this.masterId---->', this.masterId);
            console.log('this.mtrlSpecList[Index]--',this.mtrlSpecList[Index]);
            for(let i=0;i<this.mtrlSpecList.length;i++){
                if(this.mtrlSpecList[i].index==Index){
                    this.mtrlSpecList[i].School__c=this.masterId;
                    console.log('Inside If Condition');
                    break;
                }
            }
        }
        console.log('this.mtrlSpecList--'+JSON.stringify(this.mtrlSpecList));
    }
 addRow() {
        debugger;
        if(this.mtrlSpecList.length!=0 || this.mtrlSpecList.length>0){
            for(let i=1;i<this.mtrlSpecList.length;i++){
                this.keyIndex=this.mtrlSpecList[i].index;
            }
        }
        this.keyIndex=this.keyIndex+1;
        var keyindexvalue=this.keyIndex;
        this.mtrlSpecList.push({
                    Id:null,
                    index:keyindexvalue,
                    School__c :null,
                    Description__c :null,
                    Visit_Date_Time__c :null
        });
    }
    removeRow(event) {
        debugger;
        var IndexKey=parseInt(event.target.accessKey);
        console.log('IndexKey--',IndexKey);
        if (this.mtrlSpecList.length > 1) {
            //this.mtrlSpecList.splice(event.target.accessKey,1);
             this.mtrlSpecList = this.mtrlSpecList.filter(function (element) {
                return parseInt(element.index) !== parseInt(event.target.accessKey);
            });
             console.log("mtrlSpecList After Splice Length -- ",this.mtrlSpecList.length);
            //this.keyIndex-1;
        }
        for(let i=0;i<this.mtrlSpecList.length;i++){
                this.mtrlSpecList[i].index=i+1;
        }
    }
     handleChange(event) {
        debugger;
        var AccessKey=parseInt(event.target.accessKey);
        for(let i=0;i<this.mtrlSpecList.length;i++){
            if(this.mtrlSpecList[i].index==AccessKey){

                     if (event.target.name === 'expDate') {
                        this.mtrlSpecList[i].Visit_Date_Time__c = event.target.value;
                    }
                    else if (event.target.name === 'desc') {
                        this.mtrlSpecList[i].Description__c = event.target.value;
                    }
            }
        }
        }
        doSubmit() {
        debugger;
        var mtrlSpecListss = this.mtrlSpecList;
        var mtrlSpecList= [];
        for(var i in mtrlSpecListss){
            mtrlSpecList.push({
            Id:mtrlSpecListss[i].Id,
            Opportunity__c : this.recordId,
            School__c: mtrlSpecListss[i].School__c,
            Visit_Date_Time__c : mtrlSpecListss[i].Visit_Date_Time__c,
            Description__c: mtrlSpecListss[i].Description__c
            });
        }

    doSave({visitRecList : JSON.stringify(mtrlSpecList), parentObjId : this.recordId}).then(result => {
            if(result){
                console.log('Result -->',result);
                this.showNotification('Success','Visit Records are created successfully!!','success');
                this.closeAction();
            }
       }).catch(error=>{
            console.log("Error",error);
            this.showNotification('Error',error.body.message,'error');
        });
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