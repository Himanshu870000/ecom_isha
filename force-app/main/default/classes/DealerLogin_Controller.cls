public without sharing class DealerLogin_Controller {

    @RemoteAction
    public static string loginDealer(string username){
        try{
            Account accRec = New Account();
            if(!String.isBlank(username)){
                accRec = [SELECT Id,Name,Email__c,Password__c From Account WHERE Email__c=: username];
            }
            return accRec.Id;
        }catch(Exception e){
           return e.getMessage()+e.getLineNumber(); 
        }
    }
}