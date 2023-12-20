public class ReserachProductTriggerHelper {
    
    //public static boolean RunOnce = False;
    
    public static ReserachProductTriggerHelper helperInstance{get;set;}
    
    private ReserachProductTriggerHelper(){
    }
    
    public static ReserachProductTriggerHelper getInstance(){
        if(helperInstance == null){
            return new ReserachProductTriggerHelper();
        }else{
            return helperInstance;
        }
    }
    
    public void convertToProduct(List<Research_Product__c> allResProduct){
        
        List<Product2> ProdList = new List<Product2>();
        for(Research_Product__c RP : allResProduct)
        {
            if(RP.Stages__c == 'Launch'){
                product2 prodl = new product2();
                prodl.IsActive = RP.IsActive__c;
                prodl.DisplayUrl = RP.DisplayUrl__c;
                prodl.Externalid = RP.Externalid__c;
                prodl.ProductCode = RP.ProductCode__c;
                prodl.Description = RP.Description__c;
                prodl.Name = RP.Name;
                prodl.StockKeepingUnit = RP.StockKeepingUnit__c;
                prodl.QuantityUnitOfMeasure = RP.QuantityUnitOfMeasure__c;
                // prodl.Quality__c = RP.Quality__c;
                //prodl.
                ProdList.add(prodl);     
            }
            
        }
        insert ProdList; 
        
    }

}