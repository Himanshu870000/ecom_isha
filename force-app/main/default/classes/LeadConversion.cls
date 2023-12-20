public class LeadConversion {
    @future
    public static void convertLeadToOrder(set<Id>  leadIdSet) {
        
        List<Database.LeadConvert> convertList = new List<Database.LeadConvert>(  );
        
        
        LeadStatus convertStatus = [SELECT Id, MasterLabel
                                    FROM LeadStatus
                                    WHERE IsConverted = true
                                    LIMIT 1];
        for(Id leadId : leadIdSet){
            Database.LeadConvert convert = new Database.LeadConvert(  );
            convert.setConvertedStatus(convertStatus.MasterLabel);
            convert.setDoNotCreateOpportunity(True);
            convert.setLeadId(leadId);
            convertList.add(convert);
        }
        if(!convertList.isEmpty()){
            Database.convertLead(convertList);
        }
        //        Database.LeadConvertResult convertedLead =
    }
}