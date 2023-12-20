public class BidBrandingCustomNotification {
    public static void afrertUpdae(Map<Id, Bid_Branding_Asset__c> bidNewMap){
        set<string> userIds = new Set<string>();
        userIds.add('0052v00000gOuCEAA0');
        userIds.add('005N000000AkhoZIAR');
        for(Bid_Branding_Asset__c bidREc : bidNewMap.values()){
            if(bidREc.Available_quantity__C == 0){
                CustomNotificationType notificationType = [SELECT Id, DeveloperName FROM CustomNotificationType WHERE DeveloperName='FollowUpTaskReminder'];
                if(notificationType != null){
                    Messaging.CustomNotification notification = new Messaging.CustomNotification();
                    notification.setTitle(bidREc.Name+' stock update');
                    notification.setBody(bidREc.Name+' stock update'+'- OUT OF STOCK');
                    notification.setNotificationTypeId(notificationType.Id);
                    notification.setTargetId(bidREc.Id);
                    try {
                        system.debug('sending');
                        notification.send(userIds);
                    }
                    catch (Exception e) {
                        System.debug('Problem sending notification: ' + e.getMessage());
                    }
                }
            }  
        }
    }
    
}