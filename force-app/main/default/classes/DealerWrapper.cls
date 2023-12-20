public class DealerWrapper {
    public TargetWrapper DealerTargetWrapperInstance;
    public OrderWrapper DealerOrderWrapperInstance;
    public InvoiceWrapper DealerInvoiceWrapperInstance;
    public TicketWrapper DealerTicketWrapperInstance;
    
    public DealerWrapper(){
        DealerTargetWrapperInstance = new TargetWrapper(2000,1000,1000);
        DealerOrderWrapperInstance = new OrderWrapper(200,100,100);
        DealerInvoiceWrapperInstance = new InvoiceWrapper(20,10,10);
        DealerTicketWrapperInstance = new TicketWrapper(5,3,2);
    }
    
    @AuraEnabled
    public static DealerWrapper getDealerData(String accId){
        
        return new DealerWrapper();
    }
    
    class InvoiceWrapper {
        public Integer InvoiceByCompany;
        public Integer InvoiceAcheived;
        public Integer InvoicePending;
        
        InvoiceWrapper(Integer ic,Integer ia,Integer ip){
            this.InvoiceByCompany = ic;
            this.InvoiceAcheived = ia;
            this.InvoicePending = ip;
        }
    }
    
    class TicketWrapper {
        public Integer TicketByCompany;
        public Integer TicketAcheived;
        public Integer TicketPending;
        
        TicketWrapper(Integer tc,Integer ta,Integer tp){
            this.TicketByCompany = tc;
            this.TicketAcheived = ta;
            this.TicketPending = tp;
        }
    }
    class OrderWrapper {
        public Integer OrderSetByCompany;
        public Integer OrderAcheived;
        public Integer OrderPending;
        
        OrderWrapper(Integer oc,Integer oa,Integer op){
            this.OrderSetByCompany = oc;
            this.OrderAcheived = oa;
            this.OrderPending = op;
        }
    }
    class TargetWrapper {
        public Integer targetSetByCompany;
        public Integer targetAcheived;
        public Integer targetPending;
        
        TargetWrapper(Integer toc,Integer ta,Integer tp){
            this.targetSetByCompany = toc;
            this.targetAcheived = ta;
            this.targetPending = tp;
        }
    }
    
    @AuraEnabled
    public static DealerWrapper_v1 getAllInvoicesCount(String accountId){
        try{
            system.debug('accountId-->'+accountId);
            Account accRec = [SELECT Id,Targetted_Number_Of_Order__c,Targetted_Order_Achieved__c,Targetted_Order_Pending__c From Account WHERE Id=: accountId];
            DealerWrapper_v1 dealerInstance = new DealerWrapper_v1(accRec,10,8,2,500,455,45,250,180,70,50,42,8);
            return dealerInstance;
        }catch(Exception e){
            system.debug('error-->'+e.getMessage());
            system.debug('error-->'+e.getLineNumber());
            return null;
        }
    }
    public class DealerWrapper_v1{
        @auraEnabled
        public Account accRec ;
        @auraEnabled
        public integer yearlyTargetSet;
        @auraEnabled
        public integer yearlyTargetAchieved;
        @auraEnabled
        public integer yearlyTargetPending;
        @auraEnabled
        public integer orderTargetSet;
        @auraEnabled
        public integer orderTargetAchieved;
        @auraEnabled
        public integer ordeTargetPending;
        @auraEnabled
        public integer orderTotalInvoice;
        @auraEnabled
        public integer orderTotalInvoicePaid;
        @auraEnabled
        public integer orderTotalInvoicepending;
        @auraEnabled
        public integer caseRaised;
        @auraEnabled
        public integer CaseRessolved;  
        @auraEnabled
        public integer CasePending;  
        
        public DealerWrapper_v1(Account accRec,integer yearlyTargetSet,integer yearlyTargetAchieved,integer yearlyTargetPending,integer orderTargetSet,integer orderTargetAchieved,integer ordeTargetPending,integer orderTotalInvoice,integer orderTotalInvoicePaid,integer orderTotalInvoicepending,integer caseRaised,integer CaseRessolved,integer CasePending){
            this.accRec = accRec;
            this.yearlyTargetSet = yearlyTargetSet;
            this.yearlyTargetAchieved = yearlyTargetAchieved;
            this.yearlyTargetPending = yearlyTargetPending;
            this.orderTargetSet = orderTargetSet;
            this.orderTargetAchieved = orderTargetAchieved;
            this.ordeTargetPending = ordeTargetPending;
            this.orderTotalInvoice = orderTotalInvoice;
            this.orderTotalInvoicePaid = orderTotalInvoicePaid;
            this.orderTotalInvoicepending = orderTotalInvoicepending;
            this.caseRaised = caseRaised;
            this.CaseRessolved = CaseRessolved;
            this.CasePending = CasePending;
        }
    }
}