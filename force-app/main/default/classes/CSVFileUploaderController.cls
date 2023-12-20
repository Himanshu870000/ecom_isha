public class CSVFileUploaderController {
    
    @AuraEnabled
    public static void processData(String fileData,String sobjectName,List<String> fields, String recordId){
        system.debug('fileData-------------------->'+fileData);
        system.debug('sobjectName----------------->'+sobjectName);
        system.debug('fileData-------------------->'+fields);
        system.debug('recordId-------------------->'+recordId);
        
        map<String,String> apiNameByLabelName 					    = new map<String,String>();
        map<String,String> internalAppIdsByName					    = new map<String,String>();
        List<Monthly_Beat_Plan__c> intApplicationList		    = new List<Monthly_Beat_Plan__c>();
        
        intApplicationList = [Select Id, Name from Monthly_Beat_Plan__c where Id =: recordId];
        
        List<Group_Series_Rates_Mapping__mdt> gsrCSVFileFormatList = [SELECT Group_Series_Field_API_Name__c,Id,Label,Sequence__c FROM Group_Series_Rates_Mapping__mdt];
        
        for(Group_Series_Rates_Mapping__mdt gsrm : gsrCSVFileFormatList) {
            apiNameByLabelName.put(gsrm.Label,gsrm.Group_Series_Field_API_Name__c);
        }   
        
        List<Id> internalStudentIds = new List<Id>();
        List<Id> LMSstudentIds = new List<Id>();
        
        for(Monthly_Beat_Plan__c intAppObj : intApplicationList) {
            internalAppIdsByName.put(intAppObj.Name,intAppObj.Id);
        }
                   
        
        List<KPI_Target__c> recordList = new List<KPI_Target__c>();
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get(sobjectName);
        
        try{
            if(fileData!=null) { 
                String[] fileLines = new String[]{};
                    fileLines = fileData.split('\n');
                //for content
                system.debug('fileLines'+fileLines);
                system.debug('fileLines.size()'+fileLines.size());
                
                for (Integer i=1,j=fileLines.size();i<j;i++){
                    
                    String[] inputvalues = new String[]{};
                        inputvalues = fileLines[i].split(',');
                    
                    system.debug('inputvalues'+inputvalues);
                    
                    sObject obj = targetType.newSObject();
                    integer rowsize=inputvalues.size(); 
                    system.debug('rowsize.size()'+rowsize);
                    
                    for(integer l=0;l<rowsize;l++){      
                        if(String.isNotBlank(inputvalues[l])) {
                            String value= inputvalues[l].length()>255 ? inputvalues[l].substring(0,254) : inputvalues[l];
                             system.debug('value'+value);
                            //KPI_Target__c kTarget
                            /*Roles_and_KPI__c rKPI = new Roles_and_KPI__c();
                            rKPI.Name = value;*/
                            if(fields.get(l) == 'KPI Name'){
                                if( internalAppIdsByName.containsKey(value)){
                                    //obj.put('Id',internalAppIdsByName.get(value), value);
                                } 
                            }
                            else if(fields.get(l) == 'Target'){
                               obj.put(apiNameByLabelName.get(fields.get(l)),10);
                            }
                        }
                    }
                    
                    recordList.add((KPI_Target__c)obj);    
                    
                }

                                
                if (recordList.size() > 0) { 
                    for(sObject obj : recordList){
                        //obj.put();
                        obj.put('Monthly_Beat_Plan__c', recordId);
                        //obj.put('Roles_and_KPI__c', 'a890k0000000Q25AAE');
                    }               
                    insert recordList;
                }
            }
            
        }
        catch(Exception e){
            system.debug('Exception @ '+e.getLineNumber());
        }
    }
    
}