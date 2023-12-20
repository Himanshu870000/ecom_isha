global  without sharing class CSV_Controller {
    
    @AuraEnabled
    public static string processData(String fileData,String sobjectName,List<String> fields, String woLIId) 
    {
        map<String,String> ConIdByName = new  map<String,String>();
        map<string,String> apiNameByLabelName = new map<String,String>();
        map<string,String> resLIIdByOppName = new map<String,String>();
        map<string,String> resLIIdByResLIName = new map<String,String>();
        List<Resource_Schedule_Item__c> resSchItems = new List<Resource_Schedule_Item__c>();
        List<Resource_Schedule_Item__c> resLIListToBeInserted = new List<Resource_Schedule_Item__c>();
        
        WorkOrderLineItem woLI = [SELECT Id, WorkOrder.Work_Order_Stages__c, WorkOrderId FROM WorkOrderLineItem WHERE Id=: woLIId];
        woLI.WorkOrder.Work_Order_Stages__c = 'Upload Resource Schedule';
        update woLI.WorkOrder;
        system.debug('woLI -- ' + woLI.WorkOrder.Work_Order_Stages__c);   
        
        WorkOrder woRec = [SELECT Id, Opportunity__c FROM WorkOrder WHERE Id =: woLI.WorkOrderId];
        Opportunity opp = [SELECT Id FROM Opportunity WHERE Id =: woRec.Opportunity__c];
                
        List<Resource__c> resourceList = [SELECT Id, User__r.Name, Opportunity__r.Name, Opportunity__c FROM Resource__c WHERE User__r.Name = 'Mukesh Sharma' AND Opportunity__c =: opp.Id];
        List<Jira_Tasks_Fields__c> jtFields = [SELECT API_Name__c,Name FROM Jira_Tasks_Fields__c];
        
        for(Resource__c res : resourceList){
            resLIIdByOppName.put(res.Opportunity__r.Name , res.Id);
            resLIIdByResLIName.put(res.User__r.Name, res.Id);
        }
        
        for(Jira_Tasks_Fields__c jtf : jtFields){
            apiNameByLabelName.put(jtf.Name , jtf.API_Name__c);
        }
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get(sobjectName);
        
        try{
            if(fileData!=null) { 
                String[] fileLines = new String[]{};
                    fileLines = fileData.split('\n');
                
                for (Integer i=1,j=fileLines.size();i<j;i++){
                    String[] inputvalues = new String[]{};
                        inputvalues = fileLines[i].split(',');
                    Resource_Schedule_Item__c obj = new Resource_Schedule_Item__c();
                    integer rowsize=inputvalues.size();
                    for(integer l=0;l<rowsize;l++){ 
                        system.debug('rowsize'+rowsize);
                        if (fields.get(l) == 'Resource Name') { 
                            String value= inputvalues[l].length()>255 ? inputvalues[l].substring(0,254) : inputvalues[l];
                            if(resLIIdByResLIName.get(value) != null){
                                obj.put('Resource__c',resLIIdByResLIName.get(value));
                            }else{
                                obj.put('Resource__c',resLIIdByOppName.get(value));
                            }
                            
                        }else if (fields.get(l) == 'Agenda' || fields.get(l) == 'Status' || fields.get(l) == 'Activity') { 
                            if(String.isNotBlank(inputvalues[l]) )
                            {
                                String value= inputvalues[l].length()>255 ? inputvalues[l].substring(0,254) : inputvalues[l];
                                obj.put(apiNameByLabelName.get(fields.get(l)), value);
                            }else{
                                obj.put(apiNameByLabelName.get(fields.get(l)),'');
                            }
                        }else if(fields.get(l) == 'Schedule Date' ){
                            String value= inputvalues[l].length()>255 ? inputvalues[l].substring(0,254) : inputvalues[l];
                            obj.put(apiNameByLabelName.get(fields.get(l)),date.valueOf(value));
                        }else{
                            if(String.isNotBlank(inputvalues[l]) )
                            {
                                String value= inputvalues[l].length()>255 ? inputvalues[l].substring(0,254) : inputvalues[l];
                                obj.put(apiNameByLabelName.get(fields.get(l)),value);
                                
                            }else{
                                obj.put(apiNameByLabelName.get(fields.get(l)),'');
                            }
                        }
                    }
                    System.debug('Obj::::'+obj);
                    resSchItems.add(obj);
                }
            }
            
            if (resSchItems.size() > 0) { 
                for(Resource_Schedule_Item__c sobj:resSchItems){
                    resLIListToBeInserted.add(sobj);
                }
                insert resLIListToBeInserted;
                
                
                return 'Records Saved Sucesfully';
            }else{
                return 'Some Error Occured.';
            }
        }catch(Exception e){
            System.debug('exception'+e + 'Line number' +e.getLineNumber());
            return e.getMessage();
        }
    }
    
}