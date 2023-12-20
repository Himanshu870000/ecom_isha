public class InterestDetailsCompController {
    
    public Contact conRec{get;set;}
    public Unit__c unitRec{get;set;}
    public Boolean value{get;set;}
    public Deal__c dealRec{get;set;}
 	public  List<Emi_Schedule__c> emiRec{get;set;}    
    
 
    
    public InterestDetailsCompController(){
        
        conRec = new Contact();
        unitRec = new Unit__c();
        dealRec = new Deal__c();
        emiRec = new List<Emi_Schedule__c>();
        
       	//dealRec = [SELECT id,Unit__c,Registration_Date__c ,Contact__c,Total_Amount__c,(Select id,Name,Amount__c,Serial_No__c,Status__c from Payment_Schedules__r) FROM Deal__c where id=:ApexPages.currentPage().getParameters().get('id')];
        System.debug(dealRec.Payment_Schedules__r);
        //conRec = [Select id,Name,Pan_No__c,MailingCountry,MailingCity,MailingStreet,MailingState,MailingPostalCode,Aadhar_No__c,Phone,MobilePhone,Email,tdc_tsw__Type__c,Flat_Booked__c,Flat_Area__c from Contact where Id =:dealRec.Contact__c Limit 1];
        //unitRec = [Select id,Date_Of_Booking__c,Initial_Area_sq_ft__c,Base_Area_sq_ft__c ,Name,Unit_Type__c,Super_Built_Up_Area__c from Unit__c where Id =:dealRec.Unit__c Limit 1];
        emiRec = [SELECT Amount_Received__c,Balance__c,Bank_Name__c,Cheque_No__c,CreatedById,CreatedDate,Deal__c,Delay_Days__c,Due_Date__c,EMI_Amount__c,Id,Interest_Amount__c,Interest__c,IsDeleted,LastModifiedById,LastModifiedDate,LastReferencedDate,LastViewedDate,Name,OwnerId,Payment_Mode__c,Payment_Schedule__c,Recorded_date__c,Start_Date__c,SystemModstamp,Total_Amount__c FROM Emi_Schedule__c limit 5];
        system.debug('emiRec'+emiRec);
    }
    
    public static Blob createInterestPDF(String dealId){
        PageReference PDf =  Page.InterestDetailsComp;//Replace attachmentPDf with the page you have rendered as PDF
        PDf.getParameters().put('Id',dealId);
        PDf.setRedirect(true);
        
        Blob b ;
        b = PDf.getContent();
        
        Attachment attach = new Attachment();
        attach.Body = b;
        attach.Name = 'Interest Schedule.pdf';
        attach.IsPrivate = false;
        attach.ParentId = dealId;
        attach.ContentType = 'application/pdf';
        insert attach;
        
        String docCatId = [Select id from Document_Category__c where deal__c = :dealId AND Name = 'Interest Schedule'][0].Id;
                
        Documents_Attachment__c da = new Documents_Attachment__c();
        da.Attachement_Id__c  = attach.Id;
        da.name = 'Interest Schedule';
        da.Document_Category__c =  docCatId;  
        insert da;
        
        return b;
    }

}