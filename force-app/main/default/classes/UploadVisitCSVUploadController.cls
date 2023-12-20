public class UploadVisitCSVUploadController {
    
     
    @AuraEnabled
    public static void processData(String fileData,String sobjectName,List<String> fields, String recordId){
        system.debug('fileData-------------------->'+fileData);
        system.debug('sobjectName----------------->'+sobjectName);
        system.debug('fileData-------------------->'+fields);
        system.debug('recordId-------------------->'+recordId);
        
        map<String,String> apiNameByLabelName 					    = new map<String,String>();
        map<String,String> internalAppIdsByName					    = new map<String,String>();
        //map<String,String> internalAppIdsByintIds					= new map<String,String>();
        //Map<String, Visit__c> vistiMap 	                        = new Map<String, Visit__c>();
        
        List<Upload_Visit__mdt> uploadCSVFileFormat = [SELECT Field_API_Name__c,Id,Label,Sequence__c FROM Upload_Visit__mdt];
        
        for(Upload_Visit__mdt upcsv : uploadCSVFileFormat) {
            apiNameByLabelName.put(upcsv.Label,upcsv.Field_API_Name__c);
        }       
        
        List<sObject> recordList = new List<sObject>();
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get(sobjectName);
        
        try{
            if(fileData!=null) { 
                String[] fileLines = new String[]{};
                    fileLines = fileData.split('\n');
                //for content
                
                system.debug('fileLines.size()'+fileLines.size());
                for (Integer i=1,j=fileLines.size();i<j;i++){
                    
                    String[] inputvalues = new String[]{};
                        inputvalues = fileLines[i].split(',');
                    
                    sObject obj = targetType.newSObject();
                    integer rowsize=inputvalues.size(); 
                    system.debug('rowsize.size()'+rowsize);
                    for(integer l=0;l<rowsize;l++){      
                        if(String.isNotBlank(inputvalues[l])) {
                            String value= inputvalues[l].length()>255 ? inputvalues[l].substring(0,254) : inputvalues[l];
                            
                            if(fields.get(l) == 'Planned Visit Date'){
                                obj.put(apiNameByLabelName.get(fields.get(l)),date.valueOf(value));  
                            }
                            else if(fields.get(l) == 'Visit Start Date Time'){
                                try{
                                    system.debug(value);
                                    obj.put(apiNameByLabelName.get(fields.get(l)),Datetime.valueOf(value)); 
                                }
                                catch(Exception e){
                                    throw new CustomException('Visit Start Date Time is mandatory.'); 
                                }
                            }
                            else if(fields.get(l) == 'Visit End Date Time'){
                                try{
                                    obj.put(apiNameByLabelName.get(fields.get(l)),Datetime.valueOf(value)); 
                                }
                                catch(Exception e){
                                    throw new CustomException('Visit End Date Time is mandatory.'); 
                                }
                             }
                            else if(fields.get(l) == 'District'){
                                obj.put(apiNameByLabelName.get(fields.get(l)),value);  
                            }
                            else if(fields.get(l) == 'Taluk'){
                                obj.put(apiNameByLabelName.get(fields.get(l)),value);  
                            }
                            else if(fields.get(l) == 'Night Stay?'){
                                system.debug('value' + value);
                                obj.put(apiNameByLabelName.get(fields.get(l)),boolean.valueOf(value));  
                            }
                            else if(fields.get(l) == 'Visit Objective'){
                                obj.put(apiNameByLabelName.get(fields.get(l)),value);  
                            }
                            system.debug('Testing--->'+obj);
                        }
                    }
                    system.debug('obj'+obj);
                    recordList.add(obj);    
                    system.debug('recordList'+recordList);
                }
                if (recordList.size() > 0) { 
                    for(sObject obj : recordList){
                        obj.put('Monthly_Beat_Plan__c', recordId);
                    }               
                    insert recordList;
                    system.debug('recordList'+recordList);
                }
            }
            
        }
        catch(Exception e){
              system.debug('Exception @ '+e.getLineNumber());
                throw new CustomException(e.getMessage());
            }
        }

}