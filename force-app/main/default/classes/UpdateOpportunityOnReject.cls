public class UpdateOpportunityOnReject {

    Public static string OppId{get;set;}
    
    Public UpdateOpportunityOnReject(){
        OppId=ApexPages.currentPage().getParameters().get('id');
        system.debug('OppId--'+OppId);
        
    }
    
    public PageReference UpdateCurrentRejectedOpportunity(){
        Opportunity Opp=new Opportunity();
        Opp.Id=OppId;
        Opp.StageName='Junk';
        system.debug('Opp--'+Opp);
        Update Opp;
        
       PageReference pageRef = new PageReference('http://www1.allsportfit.com/?tm=1&subid4=1682933201.0225080000');
       return pageRef;
    }
    
    
}