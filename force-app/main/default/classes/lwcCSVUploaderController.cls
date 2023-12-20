public with sharing class lwcCSVUploaderController { 
 /*   @AuraEnabled 
    public static List<String> loadData(Id contentDocumentId)  {       
        String strMessage; 
        List <Resource_Schedule_Item__c> pendingBankList = new List <Resource_Schedule_Item__c>(); 
        //     List<string> records = new List<String>(); 
        List<sObject> listOfSobject = new List<sObject>(); 
        if ( contentDocumentId != null ) {  
            csvFileLines = data.tostring().split('\n'); 
        }       System.debug('kalsflsf');          
        //  List<String> csvFileLines = new List<String>(); 
        ContentVersion cv = [SELECT Id, ContentDocumentId, VersionData FROM ContentVersion WHERE ContentDocumentId =:ContentDocumentId]; 
        List<String> csvFileLines = cv.VersionData.toString().split('\n'); 
        System.debug('@@records'+csvFileLines);          
        //  Blob data = EncodingUtil.base64Decode(cv.VersionData); //decoded string 
        //get all the rows from the file data 
        //   csvFileLines = data.tostring().split('\n'); 
        List <String> listOfHeaders = csvFileLines[0].split(','); 
        //   List<String> listOfValues = new List<String>(); 
        list<String> listOfHeaderApi = new list<String>(); 
        Set<Integer> clmIndex = new Set<Integer>(); 
        Map<String, Resource_Schedule_Item__c> mapB2BCustomSetting = new Map<String, Resource_Schedule_Item__c>();        
        Map<String,List<String>> newMap= new Map<String,List<String>>(); 
        List<String> headerValuesCsvFile = new List<String>(csvFileLines[0].trim().split(',')); 
        System.debug('@@headerValuesCsvFile'+headerValuesCsvFile);          
        mapB2BCustomSetting = Resource_Schedule_Item__c.getAll(); 
        System.debug('@@mapB2BCustomSetting'+mapB2BCustomSetting); 
        Integer IndexOfHeader=0; 
        //  Map<String,List<String>> mapOfCSV = new Map<String,List<String>>(); 
        //   mapOfCSV.put(records[0],listOfHeaderApi); 
        //  if(mapOfCSV.containsKey()) 
        for(String header : headerValuesCsvFile){ 
            System.debug('@@header'+header); 
            //   headerValues.add(mapB2BCustomSetting.get(headerValue).FieldAPI__c); 
            header = header.removeEnd('\r'); 
            header = header.normalizeSpace();              
            If(mapB2BCustomSetting.containsKey(header)){                  
                listOfHeaderApi.add(mapB2BCustomSetting.get(header).FieldAPI__c); 
                System.debug('@@listOfRecord'+listOfHeaderApi);  
            }  
            else{ 
                listOfHeaderApi.add(''); 
            } 
        } 
        //  List<String> listOfValues = new List<String>(); 
        System.debug('@@listOfRecord'+listOfHeaderApi);       
        for(Integer i = 1; i < csvFileLines.size(); i++){ 
            List<String> inputvalues = csvFileLines[i].split(','); 
            sObject sObj = Schema.getGlobalDescribe().get('Pending_Bank_Deposits__c').newSObject();    
            for(Integer j=0; j<listOfHeaderApi.size(); j++){                                   
                System.debug('demo value of j'+ j); 
                inputvalues[j] = inputvalues[j].remove('\r'); 
                if(inputvalues[j] != '' && inputvalues[j] != null && listOfHeaderApi[j] != '' && listOfHeaderApi[j] != null){ 
                    if(listOfHeaderApi[j] == 'RecordTypeId'){ 
                        Id recordTyeId = Schema.SObjectType.Pending_Bank_Deposits__c.getRecordTypeInfosByName().get(inputvalues[j]).getRecordTypeId(); 
                        sObj.put(listOfHeaderApi[j],recordTyeId) ;  
                    } 
                    else if(listOfHeaderApi[j] == 'Date__c'){ 
                        Date datePendingBankDeposit = date.parse(inputvalues[j]); 
                        sObj.put(listOfHeaderApi[j],datePendingBankDeposit) ;  
                    } 
                    else if(listOfHeaderApi[j] == 'Debit_Amount__c'){ 
                        Double datePendingBankDeposits = double.valueOf(inputvalues[j]); 
                        sObj.put(listOfHeaderApi[j],datePendingBankDeposits) ;  
                    } 
                    else if(listOfHeaderApi[j] == 'Credit_Amount__c'){ 
                        Double amtPendingBankDeposits = double.valueOf(inputvalues[j]); 
                        sObj.put(listOfHeaderApi[j],amtPendingBankDeposits) ;  
                    } 
                    else if(listOfHeaderApi[j] == 'Type__c'){ 
                        String typePendingBankDeposits = String.valueOf(inputvalues[j]); 
                        sObj.put(listOfHeaderApi[j],typePendingBankDeposits) ;                        
                    } 
                    else{ 
                        sObj.put(listOfHeaderApi[j],inputvalues[j]);  
                    }           
                    System.debug('@@sObj'+sObj); 
                }  
            } 
            listOfSobject.add(sObj); 
        } 
        System.debug('@@clmIndex'+clmIndex); 
        System.debug('@@listOfSobject'+listOfSobject); 
        insert listOfSobject; 
        return csvFileLines; 
    }*/
}