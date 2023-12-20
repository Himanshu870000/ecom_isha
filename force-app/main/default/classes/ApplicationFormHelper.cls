public class ApplicationFormHelper {
    
     @AuraEnabled
    Public Static School__c getSchoolRecord(String recordId){
        system.debug('recordId'+recordId);
        School__c screc=[SELECT ID,Account_Person_Email__c,Account_Person_Phone__c,Budget__c,City__c,Email__c,Fee_Range__c,Principal_Phone__c FROM School__c WHERE ID=:recordId];
        system.debug('screc'+screc);
        return screc;
    }
    
    @AuraEnabled
    Public Static Void UpdateStudentForm(School__c studentRec,String recordId){
        system.debug('studentRec'+studentRec);
        system.debug('recordId'+recordId);
        studentRec.Id=recordId;
        studentRec.Status__c='Registration Completed';
        update studentRec;
    }

}