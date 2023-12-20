import { LightningElement,api,track,wire } from 'lwc';
import UpadteOpportunity from '@salesforce/apex/OpportunityController.UpadteOpportunity';
import { CurrentPageReference } from 'lightning/navigation'; 	
import myResource from '@salesforce/resourceUrl/ItwUpdatedLogo';

export default class CustomerRequirementForm extends LightningElement {

     ItwLogo=myResource;

    @api recordId;
    @track richtext;
    @track resultType;
    @track filename;
    @track Base64data;
    @track buttonDisable=false;
    @track urlId = null;
    @track urlLanguage = null;
    @track urlType = null;

    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
       if (currentPageReference) {
          this.urlId = currentPageReference.state?.id;
          this.urlLanguage = currentPageReference.state?.lang;
          this.urlType = currentPageReference.state?.type;
       }
    }
   
    handleChange(e) {
        debugger;
        this.richtext = e.detail.value;
    }

    fileData
    handleInputChange(event) {
        debugger;
        const file = event.target.files[0]
        var reader = new FileReader()
        reader.onload = () => {
            var base64 = reader.result.split(',')[1]
            this.fileData = {
                'filename': file.name,
                'base64': base64
            }
            console.log(this.fileData)
        }
        reader.readAsDataURL(file)
    }
  
    HandleSumbit() {
        debugger;
        this.buttonDisable=true;
        this.filename=this.fileData.filename;
        this.Base64data=this.fileData.base64;
        
        UpadteOpportunity({recordId: this.recordId,requirementDetail:this.richtext,filename:this.filename,attachmentBody:this.Base64data})
            .then((result) => {
                if(result=='success'){
                    location.replace("https://www.itwglobal.com/")
                }
            })
            .catch((error) => {
                
            });
    }
}