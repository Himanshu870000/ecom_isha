public class UpdateOpportunityOnFinalDeck {
   
    Public static string OppId{get;set;}
    Public static string currentURl{get;set;}
    
    Public UpdateOpportunityOnFinalDeck(){
        OppId=ApexPages.currentPage().getParameters().get('id');
        currentURl=Apexpages.currentPage().getUrl();
        system.debug('OppId--'+OppId);
        system.debug('currentURl--'+currentURl);
        
    }
    
    public PageReference UpdateCurrentFinalOpportunity(){
        Opportunity Opp=new Opportunity();
        Opp.Id=OppId;
        Opp.Sub_Stage__c='Design Approved';
        system.debug('Opp--'+Opp);
        Update Opp;
        PageReference pageRef = new PageReference('https://www.itwglobal.com/');
        return pageRef;
        
    }
}