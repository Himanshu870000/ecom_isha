trigger QuoteTrigger on Quote (After insert,before insert) {
    if(Trigger.isInsert && Trigger.isAfter){
        System.debug('After Insert');
        System.debug('');
        //Utility.mapTermsCondition(Trigger.new);
        QuoteTriggerHelper.insertQuoteLineItem(trigger.new);
    }
    
    if(trigger.isInsert && trigger.isbefore){
        for(Quote qu : trigger.new){
            qu.Pricebook2Id   = '01s2v00000Mcv46';
        }
    }
    
}