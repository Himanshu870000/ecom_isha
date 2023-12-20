public class OpportunityPaymentScheduleExtn {
    
    Deal__c opp;
    
    static Map<Integer, String> flooringMap = new Map<Integer, String>{null => '', 1 => 'First',2 => 'Second',3 => 'Third',4 => 'Fourth',5 => 'Fifth',6 => 'Sixth',7 => 'Seventh',8 => 'Eighth',9 => 'Ninth',10 => 'Tenth',11 => 'Eleventh',12 => 'Twelveth',13 => 'Thirteenth',14 => 'Fourteenth',15 => 'Fifteen th'};
        public OpportunityPaymentScheduleExtn(ApexPages.StandardController stdController) {
            stdController.addFields(new List<String>{'Total_Amount__c', 'Contact__r.Email', 'Contact__r.Name', 'Unit__r.Slab__c', 'Unit__c', 'Unit__r.Slab__r.Project__c', 'Booking_Amount__c', 'X30_Days_From_Booking_Amount__c', 'Parking_Amount__c', 'Foundation_Completion_Amount__c','Basement_Completion_Amount__c'});
            this.opp = (Deal__c)stdController.getRecord();
        }
    
    public PageReference createSchedule() {
        
        if(opp != null) {
            System.debug('--- opp'+opp);
            System.debug('--- Processing');
            List<Payment_Schedule__c> paySchedules = [SELECT Id FROM Payment_Schedule__c WHERE Deal__c=:this.opp.Id];
            List<Emi_Schedule__c> emiSchedules = [SELECT Id FROM Emi_Schedule__c WHERE Deal__c=:this.opp.Id];
            if(!paySchedules.isEmpty()) {
                System.debug('--- deleting existing pay schedules'+paySchedules);
                delete paySchedules;
                delete emiSchedules;
            }
            if(this.opp.Unit__r != null && this.opp.Unit__r.Slab__c != null && this.opp.Unit__r.Slab__r.Project__c != null) {
                AggregateResult slabsCountResult = [SELECT Count(Id) FROM Slabs__c WHERE Project__c =: this.opp.Unit__r.Slab__r.Project__c];
                List<Payment_Schedule__c> paymentSchedulesToInsert = new List<Payment_Schedule__c>();
                List<Emi_Schedule__c> emiScheduleSchedulesToInsert = new List<Emi_Schedule__c>();
                Integer serialNo = 1;
                Integer emiNameCounter = 1;
                Date thisDay = System.today();
                if(this.opp.Total_Amount__c != null && this.opp.Total_Amount__c > 0 && (Integer)slabsCountResult.get('expr0') > 0) {
                    if(this.opp.Booking_Amount__c != null) {
                        this.opp.Total_Amount__c -= this.opp.Booking_Amount__c;
                        paymentSchedulesToInsert.add(new Payment_Schedule__c(Deal__c = this.opp.Id, Name='Booking Amount', Amount__c = this.opp.Booking_Amount__c, Serial_No__c = serialNo++));
                        emiScheduleSchedulesToInsert.add(new Emi_Schedule__c(Start_Date__c = thisDay, Due_Date__c = thisDay.addDays(5), Deal__c = this.opp.Id, Name=flooringMap.get(emiNameCounter++), EMI_Amount__c = this.opp.Booking_Amount__c));
                        thisDay = thisDay.addMonths(1);
                    }
                    
                    if(this.opp.X30_Days_From_Booking_Amount__c != null && this.opp.X30_Days_From_Booking_Amount__c > 0) {
                        this.opp.Total_Amount__c -= this.opp.X30_Days_From_Booking_Amount__c;
                        paymentSchedulesToInsert.add(new Payment_Schedule__c(Deal__c = this.opp.Id, Name='30 Days from booking', Amount__c = this.opp.X30_Days_From_Booking_Amount__c, Serial_No__c = serialNo++));
                        emiScheduleSchedulesToInsert.add(new Emi_Schedule__c(Start_Date__c = thisDay, Due_Date__c = thisDay.addDays(5), Deal__c = this.opp.Id, Name=flooringMap.get(emiNameCounter++), EMI_Amount__c = this.opp.Booking_Amount__c));
                        thisDay = thisDay.addMonths(1);
                    }
                    
                    if(this.opp.Basement_Completion_Amount__c != null && this.opp.Basement_Completion_Amount__c > 0) {
                        this.opp.Total_Amount__c -= this.opp.Basement_Completion_Amount__c;
                        paymentSchedulesToInsert.add(new Payment_Schedule__c(Deal__c = this.opp.Id, Name='On completion of basement slab of respective block', Amount__c = this.opp.Basement_Completion_Amount__c, Serial_No__c = serialNo++));
                        emiScheduleSchedulesToInsert.add(new Emi_Schedule__c(Start_Date__c = thisDay, Due_Date__c = thisDay.addDays(5), Deal__c = this.opp.Id, Name=flooringMap.get(emiNameCounter++), EMI_Amount__c = this.opp.Booking_Amount__c));
                        thisDay = thisDay.addMonths(1);
                    }
                    
                    if(this.opp.Foundation_Completion_Amount__c != null && this.opp.Foundation_Completion_Amount__c > 0) {
                        this.opp.Total_Amount__c -= this.opp.Foundation_Completion_Amount__c;
                        paymentSchedulesToInsert.add(new Payment_Schedule__c(Deal__c = this.opp.Id, Name='On completion of foundation slab of respective block', Amount__c = this.opp.Foundation_Completion_Amount__c, Serial_No__c = serialNo++));
                        emiScheduleSchedulesToInsert.add(new Emi_Schedule__c(Start_Date__c = thisDay, Due_Date__c = thisDay.addDays(5), Deal__c = this.opp.Id, Name=flooringMap.get(emiNameCounter++), EMI_Amount__c = this.opp.Booking_Amount__c));
                        thisDay = thisDay.addMonths(1);
                    }
                    
                    //other slabs/unit
                    Integer payScheduleCount = (Integer)slabsCountResult.get('expr0') + 4;
                    Double installment = this.opp.Total_Amount__c/payScheduleCount;
                    System.debug('--- installment'+installment);
                    for(Integer i = 1; i <= payScheduleCount; i++) {
                        if(i == payScheduleCount - 3) {
                            paymentSchedulesToInsert.add(new Payment_Schedule__c(Deal__c = this.opp.Id, Name='On completion of brick/block work of respective flat', Amount__c = installment, Serial_No__c = serialNo++));
                            emiScheduleSchedulesToInsert.add(new Emi_Schedule__c(Start_Date__c = thisDay, Due_Date__c = thisDay.addDays(5), Deal__c = this.opp.Id, Name=flooringMap.get(emiNameCounter++), EMI_Amount__c = this.opp.Booking_Amount__c));
                            thisDay = thisDay.addMonths(1);
                        }else if(i == payScheduleCount - 2) {
                            paymentSchedulesToInsert.add(new Payment_Schedule__c(Deal__c = this.opp.Id, Name='On completion of internal plastering of respective flat', Amount__c = installment, Serial_No__c = serialNo++));
                            emiScheduleSchedulesToInsert.add(new Emi_Schedule__c(Start_Date__c = thisDay, Due_Date__c = thisDay.addDays(5), Deal__c = this.opp.Id, Name=flooringMap.get(emiNameCounter++), EMI_Amount__c = this.opp.Booking_Amount__c));
                            thisDay = thisDay.addMonths(1);
                        }else if(i == payScheduleCount - 1) {
                            paymentSchedulesToInsert.add(new Payment_Schedule__c(Deal__c = this.opp.Id, Name='On completion of internal flooring of respective flat', Amount__c = installment, Serial_No__c = serialNo++));
                            emiScheduleSchedulesToInsert.add(new Emi_Schedule__c(Start_Date__c = thisDay, Due_Date__c = thisDay.addDays(5), Deal__c = this.opp.Id, Name=flooringMap.get(emiNameCounter++), EMI_Amount__c = this.opp.Booking_Amount__c));
                            thisDay = thisDay.addMonths(1);
                        }else if(i == payScheduleCount){
                            paymentSchedulesToInsert.add(new Payment_Schedule__c(Deal__c = this.opp.Id, Name='On offer of Fit-out possession/handover of respective flat', Amount__c = installment, Serial_No__c = serialNo++));
                            emiScheduleSchedulesToInsert.add(new Emi_Schedule__c(Start_Date__c = thisDay, Due_Date__c = thisDay.addDays(5), Deal__c = this.opp.Id, Name=flooringMap.get(emiNameCounter++), EMI_Amount__c = this.opp.Booking_Amount__c));
                            thisDay = thisDay.addMonths(1);
                        }else {
                            paymentSchedulesToInsert.add(new Payment_Schedule__c(Deal__c = this.opp.Id, Name='On completion of '+ flooringMap.get(i) +' floor slab of respective flat', Amount__c = installment, Serial_No__c = serialNo++));
                            emiScheduleSchedulesToInsert.add(new Emi_Schedule__c(Start_Date__c = thisDay, Due_Date__c = thisDay.addDays(5), Deal__c = this.opp.Id, Name=flooringMap.get(emiNameCounter++), EMI_Amount__c = this.opp.Booking_Amount__c));
                            thisDay = thisDay.addMonths(1);
                        }
                    }
                    
                    if(this.opp.Parking_Amount__c != null && this.opp.Parking_Amount__c > 0) {
                        paymentSchedulesToInsert.add(new Payment_Schedule__c(Deal__c = this.opp.Id, Name='Car parking (selection: first come first serve basis)', Amount__c = this.opp.Parking_Amount__c, Serial_No__c = serialNo++));
                        emiScheduleSchedulesToInsert.add(new Emi_Schedule__c(Start_Date__c = thisDay, Due_Date__c = thisDay.addDays(5), Deal__c = this.opp.Id, Name=flooringMap.get(emiNameCounter++), EMI_Amount__c = this.opp.Booking_Amount__c));
                    }
                    
                    if(!paymentSchedulesToInsert.isEmpty()) {
                        Database.SaveResult[] resultList = Database.insert(paymentSchedulesToInsert);
                        Integer rsCount = 0;
                        for(Database.SaveResult psResult : resultList) {
                            if(psResult.isSuccess()) {
                                emiScheduleSchedulesToInsert.get(rsCount++).Payment_Schedule__c = psResult.getId();
                            }
                        }
                        
                        if(!emiScheduleSchedulesToInsert.isEmpty()) {
                            insert emiScheduleSchedulesToInsert;
                            generatePDF(this.opp.Id);
                            //GeneratePDF and send email here
                            
                            
                            //InterestDetailsCompController.createInterestPDF(this.opp.Id);
                        }
                    }
                    
                }
            }
            
        }
        PageReference acctPage = new ApexPages.StandardController(opp).view();
        acctPage.setRedirect(true);
        return acctPage;
    }
    @future(callout=true)
    public static  void generatePDF(String oppId) {
        Deal__c dealRec = [Select id, Total_Amount__c, Contact__r.Email, Contact__r.Name, Unit__r.Slab__c, Unit__c,Unit__r.Slab__r.Project__c, Booking_Amount__c, X30_Days_From_Booking_Amount__c, Parking_Amount__c,Foundation_Completion_Amount__c,Basement_Completion_Amount__c from Deal__c where Id=:oppId ];
        sendEmail('Payment_Schedule.pdf', createDealPageController.createQuotePDF(oppId),dealRec);
        
        sendEmail('Interest_Schedule.pdf', InterestDetailsCompController.createInterestPDF(oppId),dealRec);
        
    }
    private static void sendEmail(String attName, Blob attachmentBody,Deal__c dealRec) {
        // Define the email
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage(); 
        // Create the email attachment    
        Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
        efa.setFileName(attName);
        efa.setBody(attachmentBody);
        // Set the paramaters to the email object
        email.setSubject('Payment Schedule');
        
        // Here I am accessing current user email id to whom we are sending email
        email.setToAddresses( new String[] {dealRec.Contact__r.Email} );
        email.setPlainTextBody( 'Dear '+dealRec.Contact__r.Name+', \n Thanks for your interest in the property. It was a pleasure meeting you. Please find the attached Payment_Schedule.pdf for the purchase.' );
        
        // Attach file using setFileAttachments function
        email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
        email.setSaveAsActivity(true);
        // Sends the email
        Messaging.SendEmailResult [] r = 
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});   
    }
}