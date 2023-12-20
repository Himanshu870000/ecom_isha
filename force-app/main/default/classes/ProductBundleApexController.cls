public class ProductBundleApexController {
    
    Public static Map<Id,List<Features__c>> ProdIdXFeatureRec;
    Public static Map<Id,List<Product_Option__c>> FeatureIdXOptionRec;
    Public static Map<Id,Features__c> FeatureIdXFeatureRec;
    Public static Map<Id,Product2> ProductIdXProductRec;
    
    @AuraEnabled
    Public Static List<QuoteLineItem> QuoteLineItemRecs(String recordId){
        
        List<QuoteLineItem> QuoteLineItemList=[Select Product2.Name,IsOptionalProduct__c,Product2Id,Product2.Description,Product2.Pricing_Method__c,Quantity,ListPrice,UnitPrice,Discount,TotalPrice From QuoteLineItem Where QuoteId=:recordId];
        system.debug('QuoteLineItemList--'+QuoteLineItemList);
        
        return QuoteLineItemList;
    }
    
    @AuraEnabled
    Public Static List<Product2> ProductRecs(){
        List<Product2> Product2=[Select Id,Name,Description,(Select UnitPrice From PricebookEntries where IsActive = true limit 1) From Product2 where IsActive=true];
        return Product2;
    }
    
    @AuraEnabled
    Public Static List<QuoteLineItem> InsertQuoteLineItem(List<Product2> ProductList,string quoteId,List<Product_Option__c> productOptionlist){
        List<QuoteLineItem> QLItemList=new List<QuoteLineItem>();
        List<QuoteLineItem> QLItemListOption=new List<QuoteLineItem>();
        List<PricebookEntry> priceBookEntryIdList = new List<PricebookEntry>();
        priceBookEntryIdList = [Select Product2Id,name from PricebookEntry WHERE Pricebook2Id = '01s2v00000Mcv46'];
        Map<Id,Id> mapofProd2IdByEntryId = new Map<Id,Id>();
        if(!priceBookEntryIdList.isEmpty()){
            for(PricebookEntry pbe : priceBookEntryIdList){
                mapofProd2IdByEntryId.put(pbe.Product2Id,pbe.Id);
            }
        }
        for(Product2 prod:ProductList){
            PricebookEntry PbEntryRec=[Select Id,UnitPrice From PricebookEntry Where Product2Id=:prod.Id limit 1];
            
            QuoteLineItem QLItemRec=new QuoteLineItem();
            QLItemRec.Product2Id=prod.Id;
            QLItemRec.UnitPrice=PbEntryRec.UnitPrice;
            QLItemRec.Quantity=1;
            QLItemRec.QuoteId=quoteId;
            QLItemRec.PricebookEntryId=mapofProd2IdByEntryId.get(prod.Id);
            QLItemList.add(QLItemRec);
        }
        
        for(Product_Option__c option:productOptionlist){
            PricebookEntry PbEntryRec=[Select Id,UnitPrice From PricebookEntry Where Product2Id=:option.OptionalProductId__c limit 1];
            QuoteLineItem QLItemRecOption=new QuoteLineItem();
            QLItemRecOption.Product2Id=option.OptionalProductId__c;
            QLItemRecOption.UnitPrice=option.List_Price__c;
            QLItemRecOption.Quantity=1;
            QLItemRecOption.QuoteId=quoteId;
            QLItemRecOption.PricebookEntryId=mapofProd2IdByEntryId.get(option.OptionalProductId__c);
            QLItemRecOption.IsOptionalProduct__c=true;
            QLItemListOption.add(QLItemRecOption);
        }
        
        if(!QLItemList.isEmpty()){
            insert QLItemList;
            system.debug('Quote Line Item Got Inserted');
        }
        
         if(!QLItemListOption.isEmpty()){
            insert QLItemListOption;
            system.debug('Quote Line Item Got Inserted');
        }
        system.debug('QLItemList--'+QLItemList);
       List<QuoteLineItem> ReturnQuoteLineItem= QuoteLineItemRecs(quoteId);
        system.debug('ReturnQuoteLineItem--'+ReturnQuoteLineItem);
        return ReturnQuoteLineItem;
    }
    
    @AuraEnabled
    Public Static List<Product_Option__c>  ShowAllOptions(List<string> ProductIds){
        system.debug('ProductIds--'+ProductIds);
         List<Product_Option__c> ProductOptionList=[Select Name,Quantity__c,Description__c,ProductId__r.Name,Option_Code__c,List_Price__c
                                                    ,OptionalProductId__c,OptionalProductId__r.Name From Product_Option__c where ProductId__c =:ProductIds];
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
    Public Static List<QuoteLineItem> GetQuotelineItemlist(list<QuoteLineItem> quoteLineItemRec,boolean Isinsertable){
        
        list<QuoteLineItem> BlockPriceQLitem=new list<QuoteLineItem>();
        list<QuoteLineItem> ListPriceQLitem=new list<QuoteLineItem>();
        List<Block_Price__c> BlockRec=new List<Block_Price__c>();
        set<Id> BlockPriceProdId=new set<Id>();
        
        Map<Id,List<Block_Price__c>> ProdIdXBlockPrice=new Map<Id,List<Block_Price__c>>();
        
        for(QuoteLineItem QLiRec:quoteLineItemRec){
            
            if(QLiRec.Product2.Pricing_Method__c=='Block'){
                BlockPriceQLitem.add(QLiRec);
                
                BlockPriceProdId.add(QLiRec.Product2Id);
            }else{
                ListPriceQLitem.add(QLiRec);
            } 
        }
        
        
        List<Block_Price__c> BlockPriceRec=[Select Id,ProductId__c,Name,Lower_Bound__c,Upper_Bound__c,Price__c From Block_Price__c where ProductId__c=:BlockPriceProdId];
        system.debug('BlockPriceRec---'+BlockPriceRec);
        
        for(Block_Price__c BPRec:BlockPriceRec){
                
            if(ProdIdXBlockPrice.containsKey(BPRec.ProductId__c)){
                  list<Block_Price__c> existingrec = ProdIdXBlockPrice.get(BPRec.ProductId__c);
                  existingrec.add(BPRec);
                  ProdIdXBlockPrice.put(BPRec.ProductId__c, existingrec);
            }else{
                  List<Block_Price__c> TempBlockRecId=new List<Block_Price__c>();
                  TempBlockRecId.add(BPRec);
                ProdIdXBlockPrice.put(BPRec.ProductId__c,TempBlockRecId);
            }
         }
        
        system.debug('ProdIdXBlockPrice---'+ProdIdXBlockPrice);
        system.debug('BlockPriceQLitem---'+BlockPriceQLitem);
        system.debug('BlockPriceProdId---'+BlockPriceProdId);
        system.debug('ListPriceQLitem---'+ListPriceQLitem);
        
        for(QuoteLineItem TempQuoteRec:BlockPriceQLitem){
            
            if(ProdIdXBlockPrice.containsKey(TempQuoteRec.Product2Id) && ProdIdXBlockPrice.get(TempQuoteRec.Product2Id)!=null){
                for(Block_Price__c TempRec:ProdIdXBlockPrice.get(TempQuoteRec.Product2Id)){
                    if(TempQuoteRec.Quantity>=TempRec.Lower_Bound__c && TempQuoteRec.Quantity<=TempRec.Upper_Bound__c){
                        TempQuoteRec.UnitPrice=TempRec.Price__c;
                        system.debug('TempQuoteRec.UnitPrice--'+TempQuoteRec.UnitPrice);
                        break;
                    }
                }
            }
          }
        for(QuoteLineItem QRec:ListPriceQLitem){
            BlockPriceQLitem.add(QRec);
        }
        
        if(Isinsertable==true){
           Update BlockPriceQLitem;
            system.debug('Quote Line Item Is Updated');
        }else{
            system.debug('Only Calculate');
        }
              system.debug('BlockPriceQLitem After Quantity and UnitPrice Change--'+BlockPriceQLitem);
        
        return BlockPriceQLitem;
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