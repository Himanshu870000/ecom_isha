public class inititateCreditLimitController {
    @auraEnabled
    public static decimal getRecCreditLimits(String recordId){
        System.debug('recordId--> ' + recordId);
        if(recordId.startsWith('00Q')){
           Lead leadRec =[SELECT Id, Name, Recommended_Credit_Limit__c, OwnerId FROM Lead WHERE Id=:recordId]; 
           System.debug('leadRec--> ' + leadRec);
            Loan_Application__c loanAppliForLead = New Loan_Application__c();
            loanAppliForLead.Lead__c = leadRec.Id;
            loanAppliForLead.Full_Name__c = leadRec.LastName;
            loanAppliForLead.Amount__c = leadRec.Recommended_Credit_Limit__c;
            loanAppliForLead.Stage__c = 'Application Capture';
            loanAppliForLead.Loan_Type__c = 'Working Capital Loan';
            loanAppliForLead.Tenure__c = '12 months';
            insert loanAppliForLead;
        if(leadRec.Recommended_Credit_Limit__c > 0){
            List<String> nbfcList = new List<String>{'Faircent', 'Kreditbee', 'Pay Sense', 'CASHe'};
            List<Task> taskToInsert = new List<Task>();
            for(integer i=0 ; i<4 ; i++){
                Date today = system.today();
                Task taskRec = new Task();
                taskRec.OwnerId = leadRec.OwnerId;
                taskRec.WhoId = leadRec.id;
                taskRec.Priority = 'High';
                taskRec.Subject = nbfcList[i] + ' has been notified for credit limit allocation';
                taskRec.ActivityDate = today.addDays(1);
                taskToInsert.add(taskRec);
                
            }
            System.debug('taskToInsert-->' + taskToInsert);
            insert taskToInsert;
            return leadRec.Recommended_Credit_Limit__c;
        }else{
            return null;
        }
        }else{
            Account accRec =[SELECT Id, Name, Recommended_Credit_Limit__c, OwnerId FROM Account WHERE Id=:recordId];
            System.debug('accRec--> ' + accRec);
            Loan_Application__c loanAppliForLead = New Loan_Application__c();
            loanAppliForLead.Account__c = accRec.Id;
            loanAppliForLead.Full_Name__c = accRec.Name;
            loanAppliForLead.Amount__c = accRec.Recommended_Credit_Limit__c;
            loanAppliForLead.Stage__c = 'Application Capture';
            loanAppliForLead.Loan_Type__c = 'Working Capital Loan';
            loanAppliForLead.Tenure__c = '12 months';
            insert loanAppliForLead;
        if(accRec.Recommended_Credit_Limit__c > 0){
            List<String> nbfcList = new List<String>{'Faircent', 'Kreditbee', 'Pay Sense', 'CASHe'};
            List<Task> taskToInsert = new List<Task>();
            for(integer i=0 ; i<4 ; i++){
                Date today = system.today();
                Task taskRec = new Task();
                taskRec.OwnerId = accRec.OwnerId;
                taskRec.WhatId = accRec.id;
                taskRec.Priority = 'High';
                taskRec.Subject = nbfcList[i] + ' has been notified for credit limit allocation';
                taskRec.ActivityDate = today.addDays(1);
                taskToInsert.add(taskRec);
                
            }
            System.debug('taskToInsert-->' + taskToInsert);
            insert taskToInsert;
            return accRec.Recommended_Credit_Limit__c;
        }else{
            return null;
        }
        }
        
    }
}