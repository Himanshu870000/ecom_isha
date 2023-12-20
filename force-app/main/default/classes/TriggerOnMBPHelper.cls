public class TriggerOnMBPHelper {
    
    // Method to delete WBP, KPI Targets and Related Visits upon deletion of MBP
    // Author -: Vaibhav Kumar Chauhan
    // Organisation -: Utilitarian Labs Pvt. Ltd.
    // Date of Creation -: 19-Dec-2023
    // Last Updated By-: 
    // Last Updated on-: 19-Dec-2023
    
    public static void beforeDelete(List<Monthly_Beat_Plan__c> mbpList){
        try{
            Set<Id> setOfMBPids = new Set<Id>();
            if(!mbpList.isEmpty()){
                System.debug('MBP List ==> ' + mbpList);
                for(Monthly_Beat_Plan__c MBPrec : mbpList){
                    setOfMBPids.add(MBPrec.Id);
                }
                if(!setOfMBPids.isEmpty()){
                    List<Weekly_Beat_Plan__c> wbpList = [SELECT Id, Name FROM Weekly_Beat_Plan__c WHERE Monthly_Beat_Plan__c IN: setOfMBPids];
                    List<KPI_Target__c> kpiTargetList = [SELECT Id, Name FROM KPI_Target__c WHERE Monthly_Beat_Plan__c IN: setOfMBPids];
                    if(!kpiTargetList.isEmpty()){
                        System.debug('KPI Target List ==> ' + kpiTargetList);
                        delete kpiTargetList;
                    }
                    if(!wbpList.isEmpty()){
                        System.debug('WBP List ==> ' + wbpList);
                        Set<Id> setOfWBPids = new Set<Id>();
                        for(Weekly_Beat_Plan__c WBPrec : wbpList){
                            setOfWBPids.add(WBPrec.Id);
                        }
                        if(!setOfWBPids.isEmpty()){
                            List<Visit__c> visitList = [SELECT Id, Name FROM Visit__c WHERE Weekly_Beat_Plan__c IN: setOfWBPids];
                            if(!visitList.isEmpty()){
                                System.debug('Visit List ==> ' + visitList);
                                delete visitList;
                            }
                        }
                        delete wbpList;
                    }
                }
                System.debug('Successful Deletion');
            }
        }catch(exception e){
            System.debug('Error Message ==> ' + e.getMessage() + ' at Line Number ==> ' + e.getLineNumber());
        }
    }
}