public class OrderStageController {
    @AuraEnabled
    public static Order statusNamePath(String recordId){
        Order stageList = [Select Id,Name ,Status from Order where Id=:recordId] ; 
        system.debug('stageList'+stageList);
        return stageList;
        
    }
}