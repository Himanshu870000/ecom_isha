trigger CallRecordingTrigger on Call_Recording__c (after update) {

    if(trigger.isAfter && trigger.isUpdate){
        CallRecordingTriggerHelper.getQuestionTempForCallRecording(trigger.newmap,trigger.oldmap);
    }
}