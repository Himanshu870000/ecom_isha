global class CaseDetails {
    public class transcriptInput{
        @InvocableVariable(required=true)
        public String caseNo;
    }
    
    public class transcriptOutput{
        @InvocableVariable(required=true)
        public String Origin;
        @InvocableVariable(required=true)
        public String Priority;
        @InvocableVariable(required=true)
        public String Reason;
        @InvocableVariable(required=true)
        public String Status;
        @InvocableVariable(required=true)
        public String Subject;
        @InvocableVariable(required=true)
        public String Type;
    }
    
    @InvocableMethod(label='getCaseDdetails')
    public static list<transcriptOutput> GetinviceData(List<transcriptInput> getCaseDdetails){
        system.debug('getCaseDdetails::'+getCaseDdetails);
        Case caseDetails = [SELECT AccountId,CaseNumber,ContactId,Origin,Priority,Reason,Status,Type,Subject FROM Case WHERE CaseNumber =: getCaseDdetails[0].caseNo];
        list<transcriptOutput> responseList = new list<transcriptOutput>();
        transcriptOutput outputRes = new transcriptOutput();
        outputRes.Origin = String.valueOf(caseDetails.Origin);
        outputRes.Priority = String.valueOf(caseDetails.Priority);
        outputRes.Reason = String.valueOf(caseDetails.Reason);
        outputRes.Status = String.valueOf(caseDetails.Status);
        outputRes.Subject = String.valueOf(caseDetails.Subject);
        outputRes.Type = String.valueOf(caseDetails.Type);
        responseList.add(outputRes);
        return responseList;
    }
}