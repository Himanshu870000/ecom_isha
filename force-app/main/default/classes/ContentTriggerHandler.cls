public class ContentTriggerHandler {
    
    public static void afterInsert(List<Content__c> contentNewList){
    	List<Content__c> contentList = new List<Content__c>();
        for(Content__c post : contentList){
            if(post.Schedule_Date_Time__c !=null){
            	contentList.add(post);   
            }    
        }
        if(!contentList.isEmpty()){
        	//Calling schedularHandler() method
        	schedularHandler(contentList);   
        }
    }
    public static void afterUpdate(List<Content__c> contentNewList, Map<Id,Content__c> contentOldMap){
    	List<Content__c> contentList = new List<Content__c>();
        for(Content__c post : contentNewList){
            if(post.Schedule_Date_Time__c !=null && post.Schedule_Date_Time__c != contentOldMap.get(post.Id).Schedule_Date_Time__c){
            	contentList.add(post);    
            }    
        }
        if(!contentList.isEmpty()){
        	//Calling schedularHandler() method
        	schedularHandler(contentList);   
        }
    }
    
    public static void schedularHandler(List<Content__c> contentList){
        if(!contentList.isEmpty()){
        	List<Schedular_Date__c > schedulaDateList = Schedular_Date__c.getAll()?.values();
            System.debug('schedulaDateList @@'+schedulaDateList);
            DateTime earlierCalcDate;
            for(Content__c contentObj : contentList){
                System.debug('contentObj.Schedule_Date_Time__c @@'+ contentObj.Schedule_Date_Time__c);
                System.debug('schedulaDateList[0].Schedule_Date_Time__c @@'+ schedulaDateList[0].Schedule_Date_Time__c);
                if(contentObj.Schedule_Date_Time__c < schedulaDateList[0].Schedule_Date_Time__c){
                	earlierCalcDate = contentObj.Schedule_Date_Time__c;	    
                }  
            }
            if(earlierCalcDate !=null){
                // Abort existing scheduled jobs
                List<CronTrigger> existingTriggers = [SELECT Id FROM CronTrigger WHERE CronJobDetail.Name = 'SocialPostSchedular'];//AND NextFireTime !=null
                if (!existingTriggers.isEmpty()) {
                    for(CronTrigger cronstrigger : existingTriggers){
                    	System.abortJob(cronstrigger.Id);  
                    }   
                }
                
                //Calculate the cron expression based on the Date and Time
                String cronExp = '0 '+ earlierCalcDate.minute()+' '+earlierCalcDate.hour()+' '+ earlierCalcDate.day()+' '+ earlierCalcDate.month()+' ? '+ earlierCalcDate.year();
                System.debug('cronExp @@@'+cronExp);
                //Schedule the SocialPostSchedular class with the calculated cron expression
                System.schedule('SocialPostSchedular', cronExp, new SocialPostSchedular(earlierCalcDate));
                
                //Updating new earlier date for scheduling.
                schedulaDateList[0].Schedule_Date_Time__c = earlierCalcDate;
                UPDATE schedulaDateList;
            }
        }   
    }
}