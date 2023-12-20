/**
 * @author [Dinesh B]
 * @email dinesh.b@utilitarianLab.com
 * @create date 2023-03-28 19:13:38
 * @modify date 2023-03-28 19:13:38
 * @desc [description]
 */

public with sharing class ContractCreateController {
    @AuraEnabled
    public Static List<Contract> CreateContract(String recordId){
        if(!String.isBlank(recordId)){
            System.debug('recordId === >'+recordId);
            Opportunity oppDetails = [SELECT Id,Name,AccountId,StageName,CloseDate FROM Opportunity WHERE Id=:recordId];
            Quote quotedata = [SELECT Id,Name,BillingStreet,BillingCity,BillingState,BillingPostalCode,BillingCountry,ShippingStreet,ShippingCity,ShippingState,ShippingPostalCode,ShippingCountry,OpportunityId,AccountId FROM Quote WHERE OpportunityId =:recordId LIMIT 1];
           System.debug('quotedata.AccountId ==> '+quotedata.AccountId);
            String quoteAccountId = quotedata.AccountId;
            System.debug('quotedata.id ===> '+quotedata.id);
            String quoteId = quotedata.id;

            String BillingStreet = quotedata.BillingStreet;
            String BillingCity = quotedata.BillingCity;
            String BillingState = quotedata.BillingState;
            String BillingPostalCode = quotedata.BillingPostalCode;
            String BillingCountry = quotedata.BillingCountry;

            String ShippingStreet = quotedata.ShippingStreet;
            String ShippingCity = quotedata.ShippingCity;
            String ShippingState = quotedata.ShippingState;
            String ShippingPostalCode = quotedata.ShippingPostalCode;
            String ShippingCountry = quotedata.ShippingCountry;

             List<Contract> ContractToInsertList = new List<Contract>();
            List<OpportunityLineItem> oppLineitemList = [SELECT id,name,OpportunityId,Product2Id FROM OpportunityLineItem WHERE OpportunityId =:recordId];
            if(oppLineitemList.size() > 0 ){
                for(OpportunityLineItem ooplineitem : oppLineitemList){
                    Contract con = new Contract();
                    if(!String.isBlank(quoteAccountId)){
                        con.AccountId = quoteAccountId;
                    }
                    if(!String.isBlank(quoteId)){
                        con.Quote__c = quoteId;
                    }
                    if(!String.isBlank(ooplineitem.OpportunityId)){
                        con.Opportunity__c = ooplineitem.OpportunityId;
                    }
                    if(!String.isBlank(ooplineitem.Product2Id)){
                        con.Product__c = ooplineitem.Product2Id;
                    }  
                    con.BillingStreet = BillingStreet;
                    con.BillingCity = BillingCity;
                    con.BillingState = BillingState;
                    con.BillingPostalCode = BillingPostalCode;
                    con.BillingCountry = BillingCountry;
                    con.ShippingStreet = ShippingStreet;
                    con.ShippingCity = ShippingCity;
                    con.ShippingState = ShippingState;
                    con.ShippingPostalCode = ShippingPostalCode;
                    con.ShippingStreet = ShippingStreet;
                    con.ContractTerm = 1;
                    ContractToInsertList.add(con);
                }
            }
            if(ContractToInsertList.size() > 0){
                insert ContractToInsertList;
                System.debug('Inserted Contract Record ===> '+ContractToInsertList[0].Id);
            }
           return ContractToInsertList;
        }
        return null;
    }

    @AuraEnabled
    public Static String insertEventAggrement(String recordId){
        if(!String.isBlank(recordId)){
            List<Attachment> attachList = new List<Attachment>();
            Opportunity con = [SELECT Id,Name FROM Opportunity WHERE Id =: recordId];
            if(!String.isBlank(con.id)){
                PageReference pdfPage = Page.EventAggrement;   
                pdfPage.getParameters().put('id',recordId);
                blob pdfBody;
                pdfBody = (!Test.isRunningTest() ? pdfPage.getContent() : Blob.valueOf('Fake content'));
                Attachment attach = new Attachment(); 
                attach.Body = pdfBody;
                attach.Name = 'EventAggrement.pdf';
                attach.IsPrivate = false;
                attach.ParentId = recordId;
                attach.ContentType = 'application/pdf';
                attachList.add(attach);
            }
            if(attachList.size() > 0){
                insert attachList;
                
                Opportunity opp = new Opportunity();
                opp.Id = recordId;
                opp.StageName = 'Under Aggrement';
                update opp;
                return 'SUCCESS';
            }
        }
      
       return 'ERROR';

    }


    public Static Task createTaskForEventSchedular(List<Event_Schedular__c> eventSchedList){
        try{
            System.debug('eventSchedList ==> '+eventSchedList);
            List<Task> tkListToInsert = new List<Task>();
         if(eventSchedList.size() > 0){
            for(Event_Schedular__c est : eventSchedList){
                Task tk = new Task();
                tk.OwnerId = est.OwnerId;
                tk.WhatId = est.id;
                tk.subject = 'Please tag available asset';
                tk.Status = 'Open';
                tk.Priority = 'Normal';
                tkListToInsert.add(tk);
            }
         }
         if(tkListToInsert.size() > 0){
            insert tkListToInsert;
            System.debug('task === >'+tkListToInsert);
         }
            return tkListToInsert[0];
        }catch(Exception e){
                System.debug('The Error '+e.getMessage());
                System.debug('Erron Line '+e.getLineNumber());
            }
      return null;
    }
}