public without sharing class CreateLeadViaQRCodeHelper {
    public Campaign campaignRecord {get;set;}
    public String campaignRecordString{get;set;}
    public String LeadRecordString{get;set;}
    public string Industry {get;set;}
    public String leadSubSource {get;set;}
    public String leadSourceType {get;set;}
    
    Public CreateLeadViaQRCodeHelper() {
        String recordId = Apexpages.currentPage().getParameters().get('id'); 
        Lead leadRecord = new Lead();
        campaignRecord = [SELECT Id,Name FROM Campaign WHERE ID =:recordId];
        System.debug('campaignRecord ::'+campaignRecord);
        campaignRecordString=JSON.serialize(campaignRecord);
        LeadRecordString = JSON.serialize(leadRecord);
       Industry = JSON.serialize(UtilityPickListClass.getPicklistValues('Lead', 'Industry'));
        //leadSubSource = JSON.serialize(UtilityPickListClass.getPicklistValues('Lead', 'leadSubSource'));
        //leadSourceType = JSON.serialize(UtilityPickListClass.getPicklistValues('Lead', 'leadSubSource'));
    }
    
    @RemoteAction
    public Static string insertLeadDetails(String campaignId,String name,String email, String phone, String Industry ){ 
        system.debug('campaign ID====> ' + campaignId);
        system.debug('Industry--->'+Industry);
       // system.debug('leadSubSource--->'+leadSubSource);
       // system.debug('leadSourceType--->'+leadSourceType);
        
        
        Lead leadRecordToInsert = new Lead ();
        leadRecordToInsert.FirstName = name;
        leadRecordToInsert.Email =email;
        leadRecordToInsert.Phone = phone;
         leadRecordToInsert.Industry = Industry;
        leadRecordToInsert.Campaign__c = campaignId;
        
        Insert leadRecordToInsert;
        System.debug('Lead Record ==>'+leadRecordToInsert);
        //CampaignMember member = new CampaignMember(LeadId=led.Id,CampaignId=leadId);
        //insert member; 
        //system.debug('member Record ==>>'+member);
        return 'SUCCESS';
    }
    
    @auraEnabled
    Public Static void clonedOpp(string recordId){
        case findOpp =[select id,Opportunity__c from case where id=:recordId limit 1];
        system.debug('findOpp--'+findOpp);
        Opportunity opportunityRec=[SELECT AccountId,Action_done__c,Age_Bracket__c,Amount,Annual_Fee_Range__c,Approval_Status__c,Asset_Target__c,Basement_Completion_Amount__c,Batch_No__c,Bid_Branding_Asset__c,Booking_Amount__c,Branding_Asset_Line_Item__c,CampaignId,City__c,Class__c,Client_Note__c,Clinic__c,CloseDate,ContactId,Coupon__c,CreatedById,CreatedDate,DB_Competitor__c,Delivery_Agent__c,Delivery_Date__c,Description,Discounted_Amount__c,Discount__c,Done__c,Due_Amount__c,Event_Schedular__c,Factory__c,Finalized_School__c,Finance_Sub_Status__c,Finance_Team__c,Fiscal,FiscalQuarter,FiscalYear,ForecastCategory,ForecastCategoryName,Foundation_Completion_Amount__c,Franchise_Associated_To__c,HasOpenActivity,HasOpportunityLineItem,HasOverdueTask,Higher_Level_Requirement__c,Initiated_Amount__c,Interestd_Product__c,IsClosed,IsDeleted,IsWon,LastActivityDate,LastAmountChangedHistoryId,LastCloseDateChangedHistoryId,LastModifiedById,LastModifiedDate,LastReferencedDate,LastStageChangeDate,LastViewedDate,LeadSource,Legal_Sub_Status__c,Legal_Team__c,Lost_Reason__c,Name,NextStep,No_of_Invoices__c,No_of_Returns__c,No_of_StockOuts__c,Offer_No__c,Opportunity_Type__c,Opp_reference_Field__c,Opted_For_Parking__c,Order_Growth__c,OwnerId,O_C__c,Parent_Oppotunity__c,Parking_Amount__c,Payment_Captured__c,Payment_Status__c,Pickup_DateTime__c,Preferred_Area__c,Preferred_Board__c,Pricebook2Id,Probability,Product_Team__c,Project__c,PushCount,PushCount__c,Quantity_unit__c,Quantity__c,Realized_Amount__c,ringdna__HasOptedOutOfSms2__c,ringdna__Opportunity_Source__c,Sales_Note__c,Sales_Team_Member__c,StageName,State__c,Status__c,Sub_Stage__c,SyncedQuoteId,SystemModstamp,tdc_tsw__SMS_Opt_out__c,Total_Amount__c,Total_Project_Expanse__c,Total_Requisition_Cost__c,Trial_End_Date__c,Type,Unique__c,Unit__c,Verticle_Head__c,Visa_Inquiry__c,X30_Days_From_Booking_Amount__c FROM Opportunity where id=: findOpp.Opportunity__c limit 1];
        system.debug('opportunityRec--'+opportunityRec);
 		Opportunity opportunityRecCloned = opportunityRec.clone(false, true, true, true);
        system.debug('opportunityRecCloned--'+opportunityRecCloned);
        insert opportunityRecCloned;
        opportunityRecCloned.Parent_Oppotunity__c=opportunityRec.id;
        update opportunityRecCloned;
		
    }
    
}