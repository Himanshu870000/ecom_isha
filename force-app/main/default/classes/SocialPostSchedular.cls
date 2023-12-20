public class SocialPostSchedular implements System.Schedulable{
    
    DateTime scheduleDateTime;
    
    public SocialPostSchedular(DateTime scheduleDateTime){
    	this.scheduleDateTime = scheduleDateTime;   
    }
    
    public void execute(SchedulableContext sc){
    	Database.executeBatch(new SocialPostBatchable(scheduleDateTime));  
    }
}