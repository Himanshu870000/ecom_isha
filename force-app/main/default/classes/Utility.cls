global class Utility {
    public static void calculateLeadNurtureScore(){
        try{
            List<Lead_Nurture_Step__c> leadNurtureSteps = [select id,Lead__c,Status__c from Lead_Nurture_Step__c where Lead__c != null];
            Map<Id,List<Lead_Nurture_Step__c>> mapofLeadIdByNurtureSteps = new Map<Id,List<Lead_Nurture_Step__c>>();
            Map<Id,Integer> mapofLeadIdByLeadScore = new Map<Id,Integer>();
            if(!leadNurtureSteps.isEmpty()){
                for(Lead_Nurture_Step__c lns : leadNurtureSteps){
                    if(mapofLeadIdByNurtureSteps.containsKey(lns.Lead__c)){
                        mapofLeadIdByNurtureSteps.get(lns.Lead__c).add(lns);
                    }else{
                        mapofLeadIdByNurtureSteps.put(lns.Lead__c,New list<Lead_Nurture_Step__c>{lns});
                    }
                    
                }
                List<Lead> leadListTobeUpdate = new List<Lead>();
                for(Id mapKey : mapofLeadIdByNurtureSteps.keySet()){
                    Lead ld = new Lead();
                    ld.Lead_Nurture_Score__c = 0;
                    ld.Id = mapKey;
                    for(Lead_Nurture_Step__c lns : mapofLeadIdByNurtureSteps.get(mapKey)){
                        if(lns.Status__C == 'Completed'){
                            
                            ld.Lead_Nurture_Score__c = ld.Lead_Nurture_Score__c + 100 / mapofLeadIdByNurtureSteps.get(mapKey).Size();
                        }
                    }
                    leadListTobeUpdate.add(ld);
                }
                
                if(!leadListTobeUpdate.isEmpty()){
                    update leadListTobeUpdate;
                }
            }
        }catch(Exception e){
            
        }
        
        
        
    }
    
    
    public static void createQuoteLineItems(string productId,String oppId,List<Product_Bundle__c> prodBundle){
        try{
            system.debug('prodBundle::'+prodBundle);
            Opportunity opp = [select id,name from opportunity where id =: oppId];
            Product2 prodDetail = [select id from product2 where id =: productId];
            list<OpportunityLineItem> qliListTobeInsert = new list<OpportunityLineItem>();
            if(!prodBundle.isEmpty()){
                for(Product_Bundle__c pb : prodBundle){
                    OpportunityLineItem qli = new OpportunityLineItem();
                    qli.Quantity =pb.Quantity__c;
                    if(pb.Recommended__c == true){
                        qli.UnitPrice = 0;
                    }else{
                        qli.UnitPrice = pb.Price__c;
                    }
                    
                    qli.Product2Id = pb.Bundle_Product__c;
                    //qli.Description = pb.Description__c;
                    qli.OpportunityId = oppId;
                    qliListTobeInsert.add(qli);
                }
                OpportunityLineItem qli = new OpportunityLineItem();
                qli.Quantity = 1;
                qli.UnitPrice = 20000;
                qli.Product2Id = prodDetail.Id;
                qli.OpportunityId = oppId;
                qliListTobeInsert.add(qli);
                if(!qliListTobeInsert.isEmpty()){
                    insert qliListTobeInsert;
                }
                
            }
        }catch(Exception e){
            system.debug('execption ::'+e.getStackTraceString());
        }
    }
    
    public static void syncQuote(List<Quote> quotes){
        for(quote qu : quotes){
            updateIsSyncingOnQuote(qu.id,qu.OpportunityId);
        }
    }
    
    @future
    public static void updateIsSyncingOnQuote(string q,string oppId){
        Opportunity opp = new Opportunity(Id = oppId);
        opp.SyncedQuoteId  = q;
        update opp;
    }
    
    public static void mapTermsCondition(List<Quote> quotes){
        List<Terms_And_Conditions__c> tcListTobeInsert = new List<Terms_And_Conditions__c>();
        for(Quote qu : quotes){
            Terms_And_Conditions__c tc = new Terms_And_Conditions__c();
            // tc.Terms_of_Payments__c = 'Fees shall be agreed as stated in the relevant quotation. 50% of the Fees is required as deposit for the reservation of';
            // tc.Cancellation__c = 'Full payment of the Fees is required to be settled if the Event is cancelled within 7 working days before the Event.';
            // tc.Address_of_the_Beneficiary__c = 'ITW India Pvt. Ltd, 497E, 14th Cross Road, Maruthi Nagar, Peenya, KIADB Industrial Area, Dabaspet, Nelmangala Taluk, Bangalore – 562111';
            // tc.Failure__c = 'All the rights that are released and quoted are only given subject to payment in full.';
            // tc.Additional_Fee__c = 'An additional fee will be imposed upon confirmation for last-minute venue/ceremony installation/preparation written requests';
            // tc.Permission__c = 'You confirm that the Event Manager is given the right and permission to use any and all images, both photographic prints and digital images and videos or other recording media, in their advertising, studio, literature,event exhibitions, editorial, trade or any other purpose and in any manner and medium';
            // tc.Co_operation__c = 'The Parties agree to positive cooperation and communication for the best possible results';
            // tc.House_Rules__c = 'Although all efforts to negotiate with the venue site management shall be made by the Event Manager, the Event Manager is limited by the guidelines of the venue site management';
            // tc.Weather_contingency__c = 'Cost of weather contingency is NOT inclusive of the quote';
            // tc.Non_guarantee__c = 'Although every possible care will be taken to plan and co-ordinate the Event and vendors for the Event, the Event Manager cannot place an unconditional guarantee on the above';
            //tc.Warranty__c = '2 years';
            tc.Payment__c = 'Payment in full is due no later than 7 days prior to the event date. This may be made via electronic transfer, debit card, cheque or credit card (3% fee - 4% on AMEX). The company reserves the right to cancel the event if payment has not been received in full.';
            tc.Inclusions__c = 'The company will supply all activity equipment and instructors, venue costs as detailed in the invoice (if applicable), event management and public liability insurance of £5,000,000.';
            tc.Substitution__c = 'The company reserves the right to substitute a comparable activity for another in the event of equipment failure or circumstances beyond its reasonable control.';
            tc.Drugs_and_Alcohol__c = 'The company may refuse participation to guests who are believed to be under the influence of drugs or alcohol. No refund will be made in such circumstances.';
            tc.Company_Authority__c = 'The customer recognises the authority of the company’s Event manager and Skippers, understanding that they may take any decision they regard as necessary to ensure the health, welfare and safety of those taking part in the event.';
            tc.Changing_Dates__c	 = 'Every effort will be made to change the event date when requested, although the company reserves the right to charge 10% of the event value. The charge may be higher when it has not been possible to cancel subcontractors or venues. No change may be made within 30 days of the event.';
            tc.Cancellation__c = 'Whether or not payment has been made, if the customer cancels within 4 weeks of the event there is a 100% cancellation fee. Cancellation between 4 weeks and 8 weeks from the event incurs a 50% cancellation fee. Cancellation more than 8 weeks from the event incurs a 15% cancellation fee.';
            tc.Change_in_number_of_attendees__c ='A reduction in the number of attendees does not usually result in a refund and never within 30 days of the event. If numbers are reduced more than 30 days before the event, then every effort will be made to save variable costs such as catering etc. ';
            tc.Force_Majeure__c = 'The company may postpone the event where forces outside of the company’s control such as bad weather, acts of terrorism or other events which cannot be reasonably mitigated against, impact the running of the event. No liability for any costs or expenses incurred by the customer are accepted by the company in the event of cancellation or postponement.';
            tc.Weather__c = 'When rain is forecast, the company will use extra marquees, move activities indoors where possible and issue complimentary rapmacs.  The event will take place unless it is deemed unsafe to do so by the Event Manager, and if this is the case, an alternative date will be arranged.';
            tc.Inflatable_Events__c = 'It is unsafe to operate ‘Inflatable’ events in the rain. The company will use a Met Office forecast 48 hours prior to the event to determine whether the event should proceed. If continuous rain is forecast, then the customer will be offered the opportunity to postpone to a mutually convenient date or a refund. The company accepts no liability for consequential losses incurred by the customer such as hotels and flights in the event of postponement or cancellation.';
            tc.Liability_for_Damage__c	 = 'The customer is liable for loss or damage caused by guests whilst on the event to boats, vehicles, clothing or other equipment supplied by the company but limited to the amount of the company’s insurance excess.';
            tc.Copyright__c	 = 'The company retains rights to images taken on behalf of the customer. Where the customer has paid for photography, the company gives the customer permission to use such images freely.  The customer gives the company permission to use images or video taken during the event in company marketing and advertising materials.';
            tc.Quote__c = qu.Id;
            tcListTobeInsert.add(tc);
        }
        
        if(!tcListTobeInsert.isEmpty()){
            insert tcListTobeInsert;
        }
    }
    
    @AuraEnabled
    global static String leadConversionMethod(String visaId){
        Visa_Inquiry__c visaDetails = [select id,Lead__C,lead__r.Sales_Team_Member__c from Visa_Inquiry__c where id =: visaId];
        Id salesMemberId = visaDetails.lead__r.Sales_Team_Member__c;
        List<Invoice__c> invoiceListToUpdate = new List<Invoice__c>();
        List<Visa_Inquiry__c> visaInqList = new List<Visa_Inquiry__c>();
        visaInqList = [select id,Sales_Team_Member__c,Name,Visa_Purpose__c,Visa_Type__c,Stage__c,(Select Id,Opportunity__c FROM Invoices__r) from Visa_Inquiry__c where Lead__C =: visaDetails.Lead__C];
        system.debug('visaInqList-->'+visaInqList);    
        Database.LeadConvert convert = new Database.LeadConvert();
        convert.setConvertedStatus('Qualified');
        convert.setLeadId(visaDetails.Lead__C);
        convert.setDoNotCreateOpportunity(TRUE); 
        
        system.debug('convert'+convert);
        Database.LeadConvertResult convertedLead = Database.convertLead(convert);
        system.debug('convertedLead.getLeadId()::'+convertedLead.getLeadId());
        system.debug('getOpportunityId()::'+convertedLead.getOpportunityId());
        system.debug('convertedLead.getLeadTitle()::'+convertedLead);
        List<Opportunity> opportunityTobeInsert = New List<Opportunity>();
        for(Visa_Inquiry__c vsInq : visaInqList){
            Opportunity opp = new Opportunity();
            opp.AccountId = convertedLead.getAccountId();
            opp.Name = vsInq.Name;
            opp.CloseDate = System.today() + 15;
            opp.Visa_Inquiry__c = vsInq.Id;
            system.debug('vsInq.Invoices__r.size()-->'+vsInq.Invoices__r.size());
            if(visaId != vsInq.Id){
                opp.Sales_Team_Member__c = salesMemberId;
                opp.StageName = vsInq.Stage__c;
                opp.OwnerId = '005N000000AkhoZIAR';
            }else{
                opp.OwnerId = '005N000000AkhoZIAR';
                opp.StageName = vsInq.Stage__c;
            }
            opportunityTobeInsert.add(opp);
        }
        
        if(!opportunityTobeInsert.isEmpty()){
            insert opportunityTobeInsert;
        }
        if(!invoiceListToUpdate.isEmpty()){
            update invoiceListToUpdate;
        }
        
        return 'Success';
    }
    
    public static Task opportunityTaskCreationForITW(String subject,Id taskOwnerId,Id taskWhatId){
        Task ts = new Task();
        ts.WhatId = taskWhatId;
        ts.OwnerId = taskOwnerId;
        ts.Subject = subject;
        ts.Status = 'Open';
        
        return ts;
    }
}