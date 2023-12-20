public with sharing class QuoteConfigurationEditLine {
    Public static Map<Id,List<Features__c>> ProdIdXFeatureRec;
    Public static Map<Id,List<Product_Option__c>> FeatureIdXOptionRec;
    Public static Map<Id,Features__c> FeatureIdXFeatureRec;
    Public static Map<Id,Product2> ProductIdXProductRec;
    public QuoteConfigurationEditLine() {

    }

    @AuraEnabled
    public static List<Features__c> getAllFeaturesFromProduct(List<String> ProductIdsList){
          // Id productId = '01t5i000004MXwXAAW';
            List<Features__c> featureList = [select id,Name,Min_Options__c,Max_Option__c,Number__c,Category__c	 from Features__c where ProductId__c =: ProductIdsList];

            return featureList;
    }

    @AuraEnabled
    Public Static List<Product_Option__c>  ShowAllOptions(List<String> ProductIds){

       // List<String> ProductIds = new List<string>{'01t5i000004MXwXAAW'};
        //system.debug('ProductIds--'+ProductIds);
         List<Product_Option__c> ProductOptionList=[Select Name,Quantity__c,Description__c,ProductId__r.Name,Option_Code__c,List_Price__c
                                                    ,OptionalProductId__c,OptionalProductId__r.Name,FeatureId__r.Name From Product_Option__c where ProductId__c =:ProductIds];
          //system.debug('ProductOptionList--'+ProductOptionList);
        
         List<Features__c> FeatureRecList=[Select Name,ProductId__c,Category__c From Features__c Where ProductId__c=:ProductIds];
         system.debug('FeatureRecList--'+FeatureRecList);
         set<Id> FeatureId=new set<Id>();
        
        //Map Of ProductId and List<Feature>
        //Map<Id,List<Features__c>> ProdIdXFeatureRec=new Map<Id,List<Features__c>>();
          ProdIdXFeatureRec=new Map<Id,List<Features__c>>();
        
                for(Features__c featureRec:FeatureRecList){
                     FeatureId.add(featureRec.Id);
                    if(ProdIdXFeatureRec.containsKey(featureRec.ProductId__c)){
                        List<Features__c> TempRec=ProdIdXFeatureRec.get(featureRec.ProductId__c);
                        TempRec.add(featureRec);
                        ProdIdXFeatureRec.put(featureRec.ProductId__c,TempRec);
                    }else{
                        ProdIdXFeatureRec.put(featureRec.ProductId__c,new List<Features__c>{featureRec});
                    }
                }
           system.debug('ProdIdXFeatureRec--'+ProdIdXFeatureRec);
        
        
        
        List<Product_Option__c> TempProductOptionList=[Select Name,Quantity__c,Description__c,ProductId__r.Name,FeatureId__c,Option_Code__c,List_Price__c,
                                                              OptionalProductId__c,OptionalProductId__r.Name From Product_Option__c where FeatureId__c =:FeatureId];
        system.debug('TempProductOptionList--'+TempProductOptionList);
        
        //Map Of FeatureId and List<Option>
        //Map<Id,List<Product_Option__c>> FeatureIdXOptionRec=new Map<Id,List<Product_Option__c>>();
         FeatureIdXOptionRec=new Map<Id,List<Product_Option__c>>();  
             for(Product_Option__c OptionRec:TempProductOptionList){
                   if(FeatureIdXOptionRec.containsKey(OptionRec.FeatureId__c)){
                        List<Product_Option__c> TempRec=FeatureIdXOptionRec.get(OptionRec.FeatureId__c);
                        TempRec.add(OptionRec);
                        FeatureIdXOptionRec.put(OptionRec.FeatureId__c,TempRec);
                    }else{
                        FeatureIdXOptionRec.put(OptionRec.FeatureId__c,new List<Product_Option__c>{OptionRec});
                    }  
                }
             system.debug('FeatureIdXOptionRec--'+FeatureIdXOptionRec);
        
          //Map of FeatureId and FeatureRec
           // Map<Id,Features__c> 
           FeatureIdXFeatureRec=new Map<Id,Features__c>();
                for(Features__c featureRec:FeatureRecList){
                    if(FeatureIdXFeatureRec.containsKey(featureRec.Id)){
                       FeatureIdXFeatureRec.put(featureRec.Id,FeatureIdXFeatureRec.get(featureRec.Id)); 
                     }else{
                         FeatureIdXFeatureRec.put(featureRec.Id,featureRec);       
                      }  
                }
              system.debug('FeatureIdXFeatureRec--'+FeatureIdXFeatureRec);
        
            //Map Of ProductId and ProductRec
            List<Product2> ProductList=[select Id,Name From Product2 Where Id=:ProductIds];
            system.debug('ProductList--'+ProductList);
            //Map<Id,Product2> ProductIdXProductRec=new Map<Id,Product2>();
            ProductIdXProductRec=new Map<Id,Product2>();
                    for(Product2 ProdRec:ProductList){
                        if(ProductIdXProductRec.containsKey(ProdRec.Id)){
                            ProductIdXProductRec.put(ProdRec.Id,ProductIdXProductRec.get(ProdRec.Id));
                        }else{
                            ProductIdXProductRec.put(ProdRec.Id,ProdRec);
                        } 
                    }
        
            system.debug('ProductIdXProductRec--'+ProductIdXProductRec);
        AllMaps();
        return ProductOptionList;
    }

    @AuraEnabled
    Public static List<wrapperClass> AllMaps(){
        List<wrapperClass> ReturnMapWrapper=new List<wrapperClass>();
        wrapperClass WrapperRecList=new wrapperClass();
        if(ProdIdXFeatureRec!=null){
          WrapperRecList.ProductIdXFeature=ProdIdXFeatureRec;  
        }
        if(FeatureIdXOptionRec!=null){
          WrapperRecList.FeatureIdXOptionRecord=FeatureIdXOptionRec;  
        }
        if(FeatureIdXFeatureRec!=null){
          WrapperRecList.FeatureIdXFeatureRecord=FeatureIdXFeatureRec;  
        }
        if(ProductIdXProductRec!=null){
          WrapperRecList.ProductIdXProductRecord=ProductIdXProductRec;  
        }
        ReturnMapWrapper.add(WrapperRecList);
        
         system.debug('WrapperRecList prodFeature--'+WrapperRecList.ProductIdXFeature);
         system.debug('WrapperRecList FeatureOption--'+WrapperRecList.FeatureIdXOptionRecord);
         system.debug('WrapperRecList featureIdFeatureRecord--'+WrapperRecList.FeatureIdXFeatureRecord);
         system.debug('WrapperRecList ProdIdProdRecord--'+WrapperRecList.ProductIdXProductRecord);
         system.debug('ReturnMapWrapper--'+ReturnMapWrapper);
        return ReturnMapWrapper;
    }

    Public class wrapperClass{
        Map<Id,List<Features__c>> ProductIdXFeature{get;set;}
        Map<Id,List<Product_Option__c>> FeatureIdXOptionRecord{get;set;}
        Map<Id,Features__c> FeatureIdXFeatureRecord{get;set;}
        Map<Id,Product2> ProductIdXProductRecord{get;set;}
    }
}