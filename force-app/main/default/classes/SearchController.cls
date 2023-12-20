public class SearchController {
	@AuraEnabled
    public static List <Account> getAccounts() {
        return [SELECT Id, name, Type, Phone FROM Account ORDER BY createdDate ASC];
    }    
    @AuraEnabled
    public static List<Account> findByName(String searchKey) {
        String name =  + searchKey + '%';
        return [SELECT id, name, phone,type FROM Account WHERE name LIKE :name];
    }
}