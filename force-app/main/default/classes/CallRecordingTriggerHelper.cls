public class CallRecordingTriggerHelper {
    
    public static void getQuestionTempForCallRecording(Map<Id,Call_Recording__c> newUpdateCallRecordMap,Map<Id,Call_Recording__c> oldUpdateCallRecordMap){
        System.debug('newUpdateCallRecordMap == >'+newUpdateCallRecordMap);
         System.debug('oldUpdateCallRecordMap == >'+oldUpdateCallRecordMap);
        Set<Id> QuesTempIdSet = new Set<Id>();
        List<Questions__c> questionList = new List<Questions__c>();
        Question_Template__c quetemp = new Question_Template__c();
        List<Call_Question__c> callQuestionListToInsert = new List<Call_Question__c	>();
        Map<Id,Id> mapOfCallIdandQuestempRecordId = new Map<Id,Id>();
        try{
            
            if(newUpdateCallRecordMap.size()>0){
                for(Call_Recording__c call : newUpdateCallRecordMap.values()){
                    System.debug('New call.Question_Template__c === >'+call.Question_Template__c);
                    System.debug('Old oldUpdateCallRecordMap.get(call.id).Question_Template__c === >'+oldUpdateCallRecordMap.get(call.id).Question_Template__c);
                    if(call.Question_Template__c !=null && call.Question_Template__c !=oldUpdateCallRecordMap.get(call.id).Question_Template__c){
                        QuesTempIdSet.add(call.Question_Template__c);
                        if(!mapOfCallIdandQuestempRecordId.containsKey(call.id)){
                            mapOfCallIdandQuestempRecordId.put(call.Question_Template__c,call.id);
                        }else{
                            mapOfCallIdandQuestempRecordId.put(call.Question_Template__c,call.id);
                        }
                    }  
                }
                if(QuesTempIdSet.size()>0){
                    for(Questions__c que : [SELECt Id,Name,Question_Name__c,Question_Template__c FROM Questions__c WHERE Question_Template__c IN:mapOfCallIdandQuestempRecordId.keySet()]){
                        Call_Question__c callque = new Call_Question__c();
                        callque.Questions__c = que.Id;
                        callque.Call_Recording__c = mapOfCallIdandQuestempRecordId.get(que.Question_Template__c);
                        callque.Call_Question_Name__c = que.Question_Name__c;
                        callQuestionListToInsert.add(callque);
                    }
                    if(callQuestionListToInsert.size()>0){
                        insert callQuestionListToInsert;
                    }
                }
            }
            
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
        }
    }
}