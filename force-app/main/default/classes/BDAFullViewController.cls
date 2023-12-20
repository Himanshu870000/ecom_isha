public without Sharing class BDAFullViewController{
    
    @auraEnabled
    public static List<BDAActivityWrapper> GetAllBDARecords (String UserId, Date DateTobeQuery) {
        List<BDAActivityWrapper> ActivityWrapperList = new List<BDAActivityWrapper>();
        try{
            ActivityWrapperList = BDAFullViewHelper.GetAllRecord(UserId, DateTobeQuery);
            for(BDAActivityWrapper BDAactivityWrap : ActivityWrapperList){
                system.debug('BDAactivityWrap ::  ' + BDAactivityWrap);
            }
            return ActivityWrapperList;
        }
        catch(Exception e){
            system.debug('The following exception has occurred: ' + e.getMessage() + 'at line Number : ' + e.getLineNumber());
            return null;
        }
    } 
}