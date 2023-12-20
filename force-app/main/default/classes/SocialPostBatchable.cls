public class SocialPostBatchable implements Database.Batchable<sObject>,Database.AllowsCallouts {
    
    DateTime scheduleDateTime;
    
    public SocialPostBatchable(DateTime scheduleDateTime){
    	this.scheduleDateTime = scheduleDateTime;    
    }
    
    public Database.QueryLocator start(Database.BatchableContext bc){
        String query='SELECT Id, Header__c, Footer__c, Plateform__c,Schedule_Date_Time__c  FROM Content__c WHERE Schedule_Date_Time__c=:scheduleDateTime';
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext bc, List<Content__c> scope){
        
        Map<Id,Content__c> mapOfInstagramPost = new Map<Id,Content__c>();
        
        for(Content__c post : scope){
            if(post.Plateform__c.contains('Instagram')){
            	mapOfInstagramPost.put(post.Id,post);    
            }if(post.Plateform__c.contains('Twitter')){
                
            }if(post.Plateform__c.contains('Facebook')){
                
            }if(post.Plateform__c.contains('LinkedIn')){
                
            }		    
        }
        if(!mapOfInstagramPost.isEmpty()){
        	InstagramPostIntegration.postContentOnInstagram(mapOfInstagramPost);   
        }
    }
    
    public void finish(Database.BatchableContext bc){
    	List<Content__c> contentList = [SELECT Id, Header__c, Footer__c, Plateform__c,Schedule_Date_Time__c  FROM Content__c WHERE Schedule_Date_Time__c >:scheduleDateTime];
        if(!contentList.isEmpty()){
        	ContentTriggerHandler.schedularHandler(contentList);   
        }
    }
}