public class YearlyGoalController {
	@AuraEnabled
    public static List<Yearly_Goal__c> getYearlyGoalList(Integer pageSize, Integer pageNumber){
        system.debug('pageSize--->'+pageSize);
        system.debug('pageNumber--->'+pageNumber);
                
        Integer offset = (pageNumber - 1) * pageSize;
        
        List<Yearly_Goal__c> yearlyGoalList = [SELECT Id, Name,Dealer_Product__r.Product__r.Name,Target_Count__c FROM Yearly_Goal__c  LIMIT :pageSize OFFSET :offset];
        System.debug('yearlyGoalList::::'+yearlyGoalList);
        return yearlyGoalList;
    }
    
    @AuraEnabled
    public static Integer calculateProgress(Integer startValue, Integer stopValue, Integer currentValue) {
        Integer range = stopValue - startValue;
        if (range == 0) {
            return 0;
        }
        return (currentValue - startValue) * 100 / range;
    }
    
    @AuraEnabled
    public static void createYearlyGoal(Yearly_Goal__c yearlyGoal){
       try{
            insert yearlyGoal;
        }catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }
}