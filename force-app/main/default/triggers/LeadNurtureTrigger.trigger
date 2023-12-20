trigger LeadNurtureTrigger on Lead_Nurture_Step__c (after insert,after update) {
    if(trigger.isAfter && (trigger.isInsert || trigger.isUpdate))
    {
        utility.calculateLeadNurtureScore();
    }
}