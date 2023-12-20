public class AccountTriggerHandler {
	static AccountTriggerHandler accTriggerHandler;
    public static AccountTriggerHandler getInstance(){
        if(accTriggerHandler==null)
            accTriggerHandler = new AccountTriggerHandler();
        return accTriggerHandler;
    }
    
    
    public void afterInsert(Map<Id,Account> accMap){
        Explorer_Configuration__c  accDocConfig = Explorer_Configuration__c.getValues('Account');
        String accFoldersString = accDocConfig.Folders__c;
        
        List<String> accFolders = accFoldersString.split(';');
        
        List<Folder__c> folders = new List<Folder__c>();
        
        for(Account acc : accMap.values()){
            for(String fName : accFolders){
                Folder__c folder = new Folder__c(Name=fName, Account__c = acc.Id);
                folders.add(folder);
            }
        }
        
        if(!folders.isEmpty()){
         	insert folders; 
        }
    }
    
        public void CreateDocumentCategories(List<Account> accList){
        String document_cat = [select Category_Names__c from Document_Categories__c WHERE Name = 'Account'].Category_Names__c;
        List<String> document_cat_list = document_cat.split(',');
        List<Document_Category__c> DocCatListToBeInserted = new List<Document_Category__c>();
        for(Account acc : accList){
            for(String doccat:document_cat_list){
                Document_Category__c doc_cat = new Document_Category__c();
                doc_cat.Name = doccat;
                doc_cat.Deal__c = acc.Id;
                DocCatListToBeInserted.add(doc_cat);
            } 
        }
        insert DocCatListToBeInserted;
    }
    
    // Method to update Billing Address and Geolocatio if Geo-Location is empty
    // Author -: Vaibhav Kumar Chauhan
    // Organisation -: Utilitarian Labs Pvt. Ltd.
    // Date of Creation -: 19-Dec-2023
    // Last Updated By-: 
    // Last Updated on-: 19-Dec-2023
    
    public void fillNeccesaryDetailsForFSL(List<Account> accList){
        try{
            System.debug('accList==> ' + accList);
            Map<String,String> geoLocationByBillingAddress = new Map<String,String>{
              '5th Block Koramangala Panduranga Nagar,Bengaluru,Karnataka,560095,India' => '12.9325595,77.6158329',
                  '2nd Block Jaya Nagar,Bengaluru,Karnataka,560011,India' => '12.9402552,77.5799369',
                  'Hoysala Nagar HSR Layout,Bengaluru,Karnataka,560038,India' => '12.9792041,77.6320594',
                  'Whitefield Main Rd Electronic City,Bengaluru,Karnataka,560066,India' => '12.9646085,77.7159331',
                  'Whitefield Cabbon Park,Bengaluru,Karnataka,560066,India' => '12.9646085,77.7159331',
                  'Domlur Sarjapur,Bengaluru,Karnataka,560071,India' => '12.96299,77.6304705',
                  'Gottigere Richmond Circle,Bengaluru,Karnataka,560083,India' => '12.8540436,77.5794313',
                  'JP Nagar 2nd Phase,Bengaluru,Karnataka,560078,India' => '12.9116607,77.5852796',
                  'Ashok Nagar BTM Layout,Bengaluru,Karnataka,560025,India' => '12.9707499,77.601524'
            };
                Set<String> billingAddressSet = geoLocationByBillingAddress.keySet();
           		List<String> billingAddressList = new List<String>(billingAddressSet);
            System.debug('billingAddressList==> ' + billingAddressList);
            if(!accList.isEmpty()){
                for(Account accRec : accList){
                    if(accRec.Geo_Location__c == null){
                        System.debug('inside Geolocation is Null Block');
                        Integer randomNumber = Integer.valueof((Math.random() * 8));
                        String billingAddressToUpdateTo = billingAddressList.get(randomNumber);
                        List<String> billingAddressSplitted = billingAddressToUpdateTo.split(',');
                        String billingStreet = billingAddressSplitted.get(0);
                        String billingCity = billingAddressSplitted.get(1);
                        String billingState = billingAddressSplitted.get(2);
                        String billingPostalCode = billingAddressSplitted.get(3);
                        String billingCountry = billingAddressSplitted.get(4);
                        
                        String latLongString = geoLocationByBillingAddress.get(billingAddressToUpdateTo);
                        List<String> latLongStringSplitted = latLongString.split(',');
                        String latitudeVal = latLongStringSplitted.get(0);
                        String longitudeVal = latLongStringSplitted.get(1);
                        
                        accRec.BillingStreet = billingStreet;
                        accRec.BillingCity = billingCity;
                        accRec.BillingState = billingState;
                        accRec.BillingPostalCode = billingPostalCode;
                        accRec.BillingCountry = billingCountry;
                        
                        accRec.Geo_Location__Latitude__s = Double.valueOf(latitudeVal);
                        accRec.Geo_Location__Longitude__s = Double.valueOf(longitudeVal);
                    }
                }
                System.debug('accList==> ' + accList);
            }
        }catch(exception e){
            System.debug('Error Message ==> ' + e.getMessage() + ' at Line Number: ' + e.getLineNumber());
        }
    }
}