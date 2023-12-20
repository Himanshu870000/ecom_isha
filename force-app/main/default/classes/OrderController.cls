public class OrderController {
	@AuraEnabled
    public static List<Order> getOrderList(Integer pageSize, Integer pageNumber, string accountId){
        
        if(string.isBlank(accountId)){
            accountId = '0010k00001eSMIQAA4'; // acc name:  people tree Hospital
        }
        
        Integer offset = (pageNumber - 1) * pageSize;
        List<Order> ordList = new List<Order>();
        ordList = [Select Id,OrderNumber,Status,EffectiveDate,EndDate,TotalAmount FROM Order WHERE AccountId=: accountId LIMIT :pageSize OFFSET :offset];
        return ordList;
    }
    
    @AuraEnabled
    public static void createOrderRecord(Order order) {
        try{
            insert order;
        }catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
        
    }
}