public class ProductController {
	@AuraEnabled
    public static List<Product2> getProductList(Integer pageSize, Integer pageNumber){
        Integer offset = (pageNumber - 1) * pageSize;
        List<Product2> prodList = new List<Product2>();
        prodList = [SELECT Id, Name,ProductCode FROM Product2 LIMIT :pageSize OFFSET :offset];
        return prodList;
    }
}