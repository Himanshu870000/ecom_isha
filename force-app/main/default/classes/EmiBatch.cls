// Batch Job for Processing the Records
global class EmiBatch implements Database.Batchable<sobject> {
   global String [] email = new String[] {'test@test.com'};
       // Add here your email address here
       
       // Start Method
       global Database.Querylocator start (Database.BatchableContext BC) {
           Date todaydate = system.today();
           //Integer todayDay = todayDate.day();
           Integer todayMonth = todayDate.month();					
           Integer todayYear= todaydate.year();
           date FirstDateOfMonth = todaydate.toStartOfMonth();
           Integer numberOfDaysInThisMonth = date.daysInMonth(todayYear, todayMonth);
           date LastDateOfMonth = FirstDateOfMonth.addDays(numberOfDaysInThisMonth);
       
      return Database.getQueryLocator('SELECT Balance__c,Delay_Days__c,Due_Date_Month__c,Deal__r.Contact__r.name,Deal__r.Contact__r.Email,Due_Date__c,EMI_Amount__c,Interest_Amount__c,Interest__c,Start_Date__c FROM Emi_Schedule__c WHERE (Start_Date__c >= : FirstDateOfMonth AND Start_Date__c <= : LastDateOfMonth) OR (Due_Date__c >= : FirstDateOfMonth AND Due_Date__c <= : LastDateOfMonth)');
      // Query which will be determine the scope of Records fetching the same
   }
    
    // Execute method
    global void execute (Database.BatchableContext BC, List<Emi_Schedule__c> scope) {
        
        system.debug('scope'+scope);
        List<Emi_Schedule__c> customerList = new List<Emi_Schedule__c>();
        map<string,String> contactEmailandName = new map<string,String>();
        map<string,Emi_Schedule__c> contactEmisByName = new map<string,Emi_Schedule__c>();
        for(Emi_Schedule__c emi:scope){
            contactEmailandName.put(emi.Deal__r.Contact__r.Name,emi.Deal__r.Contact__r.Email);
            contactEmisByName.put(emi.Deal__r.Contact__r.Name,emi);
            
        }
        system.debug('contactDetailsByEmi'+contactEmisByName);
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        for(String cont : contactEmailandName.keySet()){
            if(contactEmailandName.get(cont) != null && contactEmailandName.get(cont) != ''){
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                string[] to = new string[] {contactEmailandName.get(cont)};
                    email.setToAddresses(to);
                email.setSubject('Your EMI is Due for '+String.valueOf(contactEmisByName.get(cont).Due_Date_Month__c));
                email.setPlainTextBody('Hello '+Cont + '\n' +'I hope that you are well. I just wanted to drop you a quick note to remind you that amount of :'+ contactEmisByName.get(cont).EMI_Amount__c +'  is due for the month of '+contactEmisByName.get(cont).Due_Date_Month__c  + ' Dated :'+String.valueOf(contactEmisByName.get(cont).Due_Date__c).substring(0,10));
                emails.add(email);
            }
        }
        Messaging.sendEmail(emails);
    }
    
    // Finish Method
    global void finish(Database.BatchableContext BC) {
        
    }
}