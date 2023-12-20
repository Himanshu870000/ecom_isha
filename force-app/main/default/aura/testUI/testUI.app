<aura:application extends="force:slds" >
    
    
    <aura:html tag="style">
        .cuf-content {
        padding: 0 0rem !important;
        }
        .slds-p-around--medium {
        padding: 0rem !important;
        }       
        
        .slds-modal__container{
        max-width: 174rem !important;
        width: 60% !important
        
        }
        
        
        
        .circle {
        border-radius: 50%;
        width: 34px;
        background: #D5ECD5;
        height: 34px;
        padding: 10px;
        
        
        display: inline-block;
        text-align: center;
        text-color: white;
        font: 21px Arial, sans-serif;
        }
        
    </aura:html> 
    
    
    
    <div class="slds-m-around--xx-large" style="font-family: Noto Sans,Helvetica,sans-serif">
        <div class="container-fluid">
            
            
            <div style="background: #D5ECD5;" class="slds-p-around_small">
                <td><lightning:icon iconName='action:record' alternativeText='record' size='large' title='record'></lightning:icon></td>
                <td> <h2 style="text-align:center;font-size: 2rem;"><b>Question Line item</b></h2></td>
            </div>
            <br/>
            <div class="form-group" style="font-weight:bold">
                <span class="circle"> 1 </span>    <lightning:input  type="text"  maxlength="100" disabled="true" label="Section Name" value="Testing 1" />
            </div>
            
            <div class="form-group" style="font-weight:bold">
                <label class="slds-form-element__label" for="form-element-01">{!index + 1}. Question </label>
                <lightning:input style="margin-top:-13px;" type="text"  disabled="true"  value="Dinesh" />
            </div>
            
            <div class="form-group" style="font-weight:bold"  >
                <lightning:textarea value="Testing" label="Answer" />     
            </div>
            
            
            <tr>
                <td>
                        <lightning:input type="radio" name="options" label="Family/Friends" value="Option1"  onchange="{!c.handleOptionChange}"/>
                </td>
                <td>
                        <lightning:input type="radio" name="options" label="Family/Friends" value="Option1"  onchange="{!c.handleOptionChange}"/>
                </td>
                <td>
                        <lightning:input type="radio" name="options" label="Family/Friends" value="Option1"  onchange="{!c.handleOptionChange}"/>
                </td>
                <td>
                        <lightning:input type="radio" name="options" label="Family/Friends" value="Option1"  onchange="{!c.handleOptionChange}"/>
                </td>
            </tr>
            
            <br/>
            
        </div>
        
        <div class="modal-footer slds-modal__footer slds-size_1-of-1" style="width: 100%; ">
            <div class="forceChangeRecordTypeFooter">
                <ui:button class="slds-button slds-float_left  slds-button_neutral" label="Cancel"
                           press="{! c.hideQuickAction}" />
                <ui:button class="slds-button slds-button--brand" label="Save" press="{!c.createQuestionLineItemSave}" />
            </div>    
        </div>
        
    </div> 
    
</aura:application>