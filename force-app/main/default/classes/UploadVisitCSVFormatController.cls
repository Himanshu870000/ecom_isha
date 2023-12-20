public class UploadVisitCSVFormatController {
    
     @AuraEnabled
    
    public static Upload_Visit__mdt uploadVisitCSVFormat(){
        
        List<Upload_Visit__mdt> uploadCSVFileFormat = [SELECT Field_API_Name__c, Id, Label, Sequence__c FROM Upload_Visit__mdt];
        system.debug('uploadCSVFileFormat'+uploadCSVFileFormat);
        return uploadCSVFileFormat[0];
    } 

}