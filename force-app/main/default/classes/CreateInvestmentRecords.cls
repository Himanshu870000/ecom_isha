global without sharing class CreateInvestmentRecords implements Database.Batchable<Sobject>, Database.Stateful, Database.RaisesPlatformEvents{
    
    global List<string> recordsId = new List<String>();
    global List<Sobject> Start(Database.BatchableContext bc){
        List<sObject> scope = new List<sObject>();
        scope.addAll([SELECT Id, Name, Investment_Created__c, OwnerId FROM Account WHERE Investment_Created__c = FALSE LIMIT 1]);
        scope.addAll([SELECT Id, Name, Investment_Created__c, OwnerId, Company FROM Lead WHERE Investment_Created__c = FALSE LIMIT 1]);
        return scope;
        //return Database.getQueryLocator('SELECT Id, Name, Investment_Created__c, OwnerId FROM Account WHERE Investment_Created__c = FALSE LIMIT 10');
    }
    global void Execute(Database.BatchableContext bc, List<Sobject> allList){
        try{
            System.debug('allList :: ' + allList[0]);
            List<Investment__c> investmentListToBeInserted = new List<Investment__c>();
            CustomNotificationType notificationType = [SELECT Id, DeveloperName FROM CustomNotificationType WHERE DeveloperName='Funding_Notification'];
            system.debug('notificationType == ' + notificationType);
            
            for(sObject scope : allList){
                system.debug('scope -- ' + scope);
                switch on scope
                {
                    when Account acc
                    {
                        Investment__c newInv = new Investment__c();
                        newInv.Account__c = acc.Id;
                        newInv.Funding_Amount__c = 100000;
                        newInv.Funding_Date__c = System.today();
                        newInv.Funding_Purpose__c = 'Expansion';
                        newInv.Funding_Round__c = 'Series A';
                        newInv.Investment_Firms__c = 'Dream Sports Group';
                        acc.Investment_Created__c = TRUE;
                        
                        Messaging.CustomNotification notification = new Messaging.CustomNotification();
                        notification.setTitle('Funding Notification for ' + acc.Name);
                        notification.setBody('Funding Batch has been intialized!');
                        notification.setNotificationTypeId(notificationType.Id);
                        notification.setTargetId(acc.Id);
                        notification.send(new Set<String> { Userinfo.getUserId() });
                        
                        investmentListToBeInserted.add(newInv);
                        
                    }
                    when Lead ld
                    {
                        Investment__c newInv = new Investment__c();
                        newInv.Lead__c = ld.Id;
                        newInv.Funding_Amount__c = 100000;
                        newInv.Funding_Date__c = System.today();
                        newInv.Funding_Purpose__c = 'Expansion';
                        newInv.Funding_Round__c = 'Series A';
                        newInv.Investment_Firms__c = 'Dream Sports Group';
                        ld.Investment_Created__c = TRUE;
                        
                        Messaging.CustomNotification notification = new Messaging.CustomNotification();
                        notification.setTitle('New Funding');
                        notification.setBody('Funding Notification for ' + ld.Company);
                        notification.setNotificationTypeId(notificationType.Id);
                        notification.setTargetId(ld.Id);
                        notification.send(new Set<String> { Userinfo.getUserId() });
                        
                        investmentListToBeInserted.add(newInv);
                    }
                }
            }
            
            system.debug('investmentListToBeInserted -- ' + investmentListToBeInserted);            
            if(investmentListToBeInserted.size()>0){
                update allList;
                Database.SaveResult[] srList = database.insert(investmentListToBeInserted,false);
                integer recordIndex=0;
                for (Database.SaveResult  sr : srList) {
                    if (sr.isSuccess()) {
                        system.debug('recordsId -- ' + investmentListToBeInserted[0].id);  
                        recordsId.add(investmentListToBeInserted[recordIndex].id);
                    }
                    recordIndex++;
                }
                system.debug('recordsId -- ' + recordsId);  
                
            } 
        }
        catch(Exception e){
            System.debug('Error :: ' + e.getMessage() + 'At Line No :: ' + e.getLineNumber());
        }
    }
    global void Finish(Database.BatchableContext bc){
        System.debug('The Batch Run Successfully');
        
        Funding_Event__e newEvent = new Funding_Event__e(Record_Id__c = string.join(recordsId,','));
        Database.SaveResult sr = EventBus.publish(newEvent);
        
        if (sr.isSuccess()) {
            System.debug('Successfully published event.');
        } else {
            for(Database.Error err : sr.getErrors()) {
                System.debug('Error returned: ' +  err.getStatusCode() +' - ' + err.getMessage());
            }
        }
    }
}