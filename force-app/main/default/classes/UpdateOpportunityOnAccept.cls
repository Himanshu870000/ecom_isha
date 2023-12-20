public class UpdateOpportunityOnAccept {
    
    Public static string OppId{get;set;}
    Public static string currentURl{get;set;}
    
    Public UpdateOpportunityOnAccept(){
        OppId=ApexPages.currentPage().getParameters().get('id');
        currentURl=Apexpages.currentPage().getUrl();
        system.debug('OppId--'+OppId);
        system.debug('currentURl--'+currentURl);
        
    }
    
    public PageReference UpdateCurrentOpportunity(){
        Opportunity Opp=new Opportunity();
        Opp.Id=OppId;
        Opp.StageName='Accepted By Client';
        system.debug('Opp--'+Opp);
        Update Opp;
        PageReference pageRef = new PageReference('http://www1.allsportfit.com/?tm=1&subid4=1682933201.0225080000');
        return pageRef;
        
    }
}