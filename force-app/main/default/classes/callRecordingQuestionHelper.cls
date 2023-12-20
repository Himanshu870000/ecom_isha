public class callRecordingQuestionHelper {
	@AuraEnabled
    public static List<Call_Question__c> fetchQuestions(Id recordId){
        try{
            //Map<String, List<Questions__c>> listOfQuestionsByTemplateName = new Map<String, List<Questions__c>>();
            List<Call_Question__c> listOfCallQuestions= new List<Call_Question__c>();
            Call_Recording__c callRec = [SELECT Id, Name, Question_Template__c, Question_Template__r.Name FROM Call_Recording__c WHERE Id =: recordId LIMIT 1];
            List<Call_Question__c> callQuesList = [SELECT Id, Name, Call_Question_Name__c, Call_Recording__c, Questions__c, Response__c 
                                                  FROM Call_Question__c WHERE Call_Recording__c =: recordId];
            System.debug(callRec);
            System.debug(callQuesList);
            //List<Questions__c> questionList = [SELECT Id, Name, Question_Name__c, Question_Template__r.Name FROM Questions__c WHERE Question_Template__c =: callRec.Question_Template__c];
            if(callQuesList.size() > 0){
                listOfCallQuestions = callQuesList;
            }/*else if(questionList.size() > 0){
                if(listOfQuestionsByTemplateName.containsKey(callRec.Question_Template__r.Name)){
                    listOfQuestionsByTemplateName.put(callRec.Question_Template__r.Name, questionList);
                    return listOfQuestionsByTemplateName;
                }
            }*/
            System.debug(listOfCallQuestions);
            return listOfCallQuestions;
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
            return null;
        }
    }
    
    
}